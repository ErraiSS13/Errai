/obj/item/grab
	name                   = "grab"
	canremove              = FALSE
	item_flags             = ITEM_FLAG_NO_BLUDGEON
	pickup_sound           = null
	drop_sound             = null
	equip_sound            = null
	is_spawnable_type      = FALSE
	obj_flags              = OBJ_FLAG_NO_STORAGE
	needs_attack_dexterity = DEXTERITY_GRAPPLE

	var/atom/movable/affecting             // Atom being targeted by this grab.
	var/mob/assailant                      // Mob that instantiated this grab.
	var/decl/grab/current_grab             // Current grab archetype, used to handle actions/overrides/etc.
	var/last_action                        // Tracks world.time of last action.
	var/last_upgrade                       // Tracks world.time of last upgrade.
	var/special_target_functional = TRUE   // Indicates if the current grab has special interactions applied to the target organ (eyes and mouth at time of writing)
	var/is_currently_resolving_hit = FALSE // Used to avoid stacking interactions that sleep during /decl/grab/proc/on_hit_foo() (ie. do_after() is used)
	var/target_zone                        // Records a specific bodypart that was targetted by this grab.
	var/done_struggle = FALSE              // Used by struggle grab datum to keep track of state.

/*
	This section is for overrides of existing procs.
*/
/obj/item/grab/Initialize(mapload, atom/movable/target, var/use_grab_state, var/defer_hand)
	. = ..(mapload)
	if(. == INITIALIZE_HINT_QDEL)
		return

	current_grab = GET_DECL(use_grab_state)
	if(!istype(current_grab))
		return INITIALIZE_HINT_QDEL
	assailant = loc
	if(!istype(assailant) || !assailant.add_grab(src, defer_hand = defer_hand))
		return INITIALIZE_HINT_QDEL
	affecting = target
	if(!istype(affecting))
		return INITIALIZE_HINT_QDEL
	target_zone = assailant.get_target_zone()

	var/mob/living/affecting_mob = get_affecting_mob()
	if(affecting_mob)
		affecting_mob.update_posture()
		if(ishuman(affecting_mob))
			var/mob/living/human/H = affecting_mob
			var/obj/item/uniform = H.get_equipped_item(slot_w_uniform_str)
			if(uniform)
				uniform.add_fingerprint(assailant)

	LAZYADD(affecting.grabbed_by, src) // This is how we handle affecting being deleted.
	adjust_position()
	action_used()
	INVOKE_ASYNC(assailant, TYPE_PROC_REF(/atom/movable, do_attack_animation), affecting)
	playsound(affecting.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	update_icon()

	events_repository.register(/decl/observ/moved, affecting, src, PROC_REF(on_affecting_move))
	var/obj/screen/zone_selector/zone_selector = assailant.get_hud_element(HUD_ZONE_SELECT)
	if(zone_selector)
		events_repository.register(/decl/observ/zone_selected, zone_selector, src, PROC_REF(on_target_change))

	var/obj/item/organ/O = get_targeted_organ()
	var/decl/pronouns/pronouns = assailant.get_pronouns()
	if(affecting_mob && O) // may have grabbed a buckled mob, so may be grabbing their holder
		SetName("[name] (\the [affecting_mob]'s [O.name])")
		events_repository.register(/decl/observ/dismembered, affecting_mob, src, PROC_REF(on_organ_loss))
		if(affecting_mob != assailant)
			visible_message(SPAN_DANGER("\The [assailant] has grabbed [affecting_mob]'s [O.name]!"))
		else
			visible_message(SPAN_NOTICE("\The [assailant] has grabbed [pronouns.his] [O.name]!"))
	else
		if(affecting != assailant)
			visible_message(SPAN_DANGER("\The [assailant] has grabbed \the [affecting]!"))
		else
			visible_message(SPAN_NOTICE("\The [assailant] has grabbed [pronouns.self]!"))

	if(affecting_mob && assailant?.check_intent(I_FLAG_HARM))
		upgrade(TRUE)

/obj/item/grab/mob_can_unequip(mob/user, slot, disable_warning = FALSE, dropping = FALSE)
	if(dropping)
		return TRUE
	return FALSE

/obj/item/grab/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/mob/M = get_affecting_mob()
	var/obj/item/O = get_targeted_organ()
	if(M && O)
		. += "A grip on \the [M]'s [O.name]."
	else
		. += "A grip on \the [affecting]."

/obj/item/grab/Process()
	current_grab.process(src)

/obj/item/grab/attack_self(mob/user)
	if(assailant.check_intent(I_FLAG_HELP))
		downgrade()
	else
		upgrade()

/obj/item/grab/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(affecting == target)
		var/datum/extension/abilities/abilities = get_extension(user, /datum/extension/abilities)
		if(abilities?.do_grabbed_invocation(target))
			return TRUE
	. = ..()

/obj/item/grab/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(QDELETED(src) || !current_grab || !assailant || proximity_flag) // Close-range is handled in resolve_attackby().
		return
	if(current_grab.hit_with_grab(src, target, proximity_flag))
		return
	. = ..()

/obj/item/grab/resolve_attackby(atom/A, mob/user, var/click_params)
	if(QDELETED(src) || !current_grab || !assailant)
		return TRUE
	if(A.grab_attack(src, user) || current_grab.hit_with_grab(src, A, get_dist(user, A) <= 1))
		return TRUE
	. = ..()

/obj/item/grab/dropped()
	..()
	if(!QDELETED(src))
		qdel(src)

/obj/item/grab/can_be_dropped_by_client(mob/M)
	if(M == assailant)
		return TRUE
	return FALSE

/obj/item/grab/Destroy()
	var/atom/old_affecting = affecting
	if(affecting)
		events_repository.unregister(/decl/observ/dismembered, affecting, src)
		events_repository.unregister(/decl/observ/moved, affecting, src)
		LAZYREMOVE(affecting.grabbed_by, src)
		affecting.reset_plane_and_layer()
		affecting = null
	if(assailant)
		var/obj/screen/zone_selector/zone_selector = assailant.get_hud_element(HUD_ZONE_SELECT)
		if(zone_selector)
			events_repository.unregister(/decl/observ/zone_selected, zone_selector, src)
		assailant = null
	. = ..()
	if(old_affecting)
		old_affecting.reset_offsets(5)
		old_affecting.reset_plane_and_layer()

/*
	This section is for newly defined useful procs.
*/

/obj/item/grab/proc/on_target_change(obj/screen/zone_selector/zone, old_sel, new_sel)
	if(src != assailant.get_active_held_item())
		return // Note that because of this condition, there's no guarantee that target_zone = old_sel
	if(target_zone == new_sel)
		return
	var/old_zone = target_zone
	target_zone = check_zone(new_sel, affecting)
	if(!istype(get_targeted_organ(), /obj/item/organ))
		current_grab.let_go(src)
		return
	current_grab.on_target_change(src, old_zone, new_sel)

/obj/item/grab/proc/on_organ_loss(mob/victim, obj/item/organ/lost)
	if(affecting != victim)
		PRINT_STACK_TRACE("A grab switched affecting targets without properly re-registering for dismemberment updates.")
		return
	var/obj/item/organ/O = get_targeted_organ()
	if(!istype(O))
		current_grab.let_go(src)
		return // Sanity check in case the lost organ was improperly removed elsewhere in the code.
	if(lost != O)
		return
	current_grab.let_go(src)

/obj/item/grab/proc/on_affecting_move()
	if(!affecting || !isturf(affecting.loc) || get_dist(affecting, assailant) > 1)
		force_drop()

/obj/item/grab/proc/force_drop()
	assailant.drop_from_inventory(src)

/obj/item/grab/proc/get_affecting_mob()
	if(isobj(affecting))
		var/obj/O = affecting
		return O.buckled_mob
	if(isliving(affecting))
		return affecting

// Returns the organ of the grabbed person that the grabber is targeting
/obj/item/grab/proc/get_targeted_organ()
	var/mob/affecting_mob = get_affecting_mob()
	if(istype(affecting_mob))
		. = GET_EXTERNAL_ORGAN(affecting_mob, check_zone(target_zone, affecting_mob))
/obj/item/grab/proc/resolve_item_attack(var/mob/living/M, var/obj/item/I, var/target_zone)
	if(M && ishuman(M) && I)
		return current_grab.resolve_item_attack(src, M, I, target_zone)
	return 0

/obj/item/grab/proc/action_used()
	if(ishuman(assailant))
		var/mob/living/human/H = assailant
		H.remove_mob_modifier(/decl/mob_modifier/cloaked, source = H.species)
	last_action = world.time
	leave_forensic_traces()

/obj/item/grab/proc/check_action_cooldown()
	return (world.time >= last_action + current_grab.action_cooldown)

/obj/item/grab/proc/check_upgrade_cooldown()
	return (world.time >= last_upgrade + current_grab.upgrade_cooldown)

/obj/item/grab/proc/leave_forensic_traces()
	if(ishuman(affecting))
		var/mob/living/human/affecting_mob = affecting
		var/obj/item/clothing/C = affecting_mob.get_covering_equipped_item_by_zone(target_zone)
		if(istype(C))
			C.leave_evidence(assailant)
			if(prob(50))
				C.ironed_state = WRINKLES_WRINKLY

/obj/item/grab/proc/upgrade(var/bypass_cooldown = FALSE)
	if(!check_upgrade_cooldown() && !bypass_cooldown)
		return
	var/decl/grab/upgrab = current_grab.upgrade(src)
	if(upgrab)
		current_grab = upgrab
		last_upgrade = world.time
		adjust_position()
		update_icon()
		leave_forensic_traces()
		current_grab.enter_as_up(src)

/obj/item/grab/proc/downgrade()
	var/decl/grab/downgrab = current_grab.downgrade(src)
	if(downgrab)
		current_grab = downgrab
		adjust_position()
		update_icon()

/obj/item/grab/on_update_icon()
	. = ..()
	if(current_grab.grab_icon)
		icon = current_grab.grab_icon
	if(current_grab.grab_icon_state)
		icon_state = current_grab.grab_icon_state

/obj/item/grab/proc/throw_held()
	return current_grab.throw_held(src)

/obj/item/grab/proc/handle_resist()
	current_grab.handle_resist(src)

/obj/item/grab/proc/adjust_position(var/force = 0)

	if(!QDELETED(assailant) && force)
		affecting.forceMove(assailant.loc)

	if(QDELETED(assailant) || QDELETED(affecting) || !assailant.IsMultiZAdjacent(affecting))
		qdel(src)
		return 0

	var/adir = get_dir(assailant, affecting)
	if(assailant)
		assailant.set_dir(adir)
	if(current_grab.same_tile)
		affecting.forceMove(get_turf(assailant))
		affecting.set_dir(assailant.dir)
	affecting.reset_offsets(5)
	affecting.reset_plane_and_layer()

/*
	This section is for the simple procs used to return things from current_grab.
*/
/obj/item/grab/proc/stop_move()
	return current_grab.stop_move

/obj/item/grab/attackby(obj/item/used_item, mob/user)
	if(user == assailant)
		return current_grab.item_attack(src, used_item)
	return FALSE

/obj/item/grab/proc/assailant_reverse_facing()
	return current_grab.reverse_facing

/obj/item/grab/proc/shield_assailant()
	return current_grab.shield_assailant

/obj/item/grab/proc/point_blank_mult()
	return current_grab.point_blank_mult

/obj/item/grab/proc/damage_stage()
	return current_grab.damage_stage

/obj/item/grab/proc/force_danger()
	return current_grab.force_danger

/obj/item/grab/proc/grab_slowdown()
	. = ceil(affecting?.get_object_size() * current_grab.grab_slowdown)
	. /= (affecting?.movable_flags & MOVABLE_FLAG_WHEELED) ? 2 : 1
	. = max(.,1)

/obj/item/grab/proc/assailant_moved()
	affecting.glide_size = assailant.glide_size // Note that this is called _after_ the Move() call resolves, so while it adjusts affecting's move animation, it won't adjust anything else depending on it.
	current_grab.assailant_moved(src)

/obj/item/grab/proc/restrains()
	return current_grab.restrains

/obj/item/grab/proc/resolve_openhand_attack()
	return current_grab.resolve_openhand_attack(src)
