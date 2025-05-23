var/global/list/hygiene_props = list()

//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos
/obj/structure/hygiene
	var/next_gurgle = 0
	var/clogged = 0 // -1 = never clog
	var/can_drain = 0
	var/drainage = 0.5
	var/last_gurgle = 0

/obj/structure/hygiene/Initialize()
	. = ..()
	global.hygiene_props += src
	START_PROCESSING(SSobj, src)

/obj/structure/hygiene/Destroy()
	global.hygiene_props -= src
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/hygiene/proc/clog(var/severity)
	if(clogged || !anchored) //We can only clog if our state is zero, aka completely unclogged and cloggable
		return FALSE
	clogged = severity
	tool_interaction_flags &= ~TOOL_INTERACTION_ANCHOR
	return TRUE

/obj/structure/hygiene/proc/unclog()
	clogged = 0
	tool_interaction_flags = initial(tool_interaction_flags)

/obj/structure/hygiene/attackby(var/obj/item/used_item, var/mob/user)
	if(clogged > 0 && isplunger(used_item))
		user.visible_message(SPAN_NOTICE("\The [user] strives valiantly to unclog \the [src] with \the [used_item]!"))
		spawn
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
		if(do_after(user, 45, src) && clogged > 0)
			visible_message(SPAN_NOTICE("With a loud gurgle, \the [src] begins flowing more freely."))
			playsound(loc, pick(SSfluids.gurgles), 100, 1)
			clogged--
			if(clogged <= 0)
				unclog()
		return TRUE
	//toilet paper interaction for clogging toilets and other facilities
	if (istype(used_item, /obj/item/stack/tape_roll/barricade_tape/toilet))
		if (clogged == -1)
			to_chat(user, SPAN_WARNING("Try as you might, you can not clog \the [src] with \the [used_item]."))
			return TRUE
		if (clogged)
			to_chat(user, SPAN_WARNING("\The [src] is already clogged."))
			return TRUE
		if (!do_after(user, 3 SECONDS, src))
			to_chat(user, SPAN_WARNING("You must stay still to clog \the [src]."))
			return TRUE
		if (clogged || QDELETED(used_item) || !user.try_unequip(used_item))
			return TRUE
		to_chat(user, SPAN_NOTICE("You unceremoniously jam \the [src] with \the [used_item]. What a rebel."))
		clog(1)
		qdel(used_item)
		return TRUE
	. = ..()

/obj/structure/hygiene/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(clogged > 0)
		. += SPAN_WARNING("It seems to be badly clogged.")

/obj/structure/hygiene/Process()
	if(clogged <= 0)
		drain()
	var/flood_amt
	switch(clogged)
		if(1)
			flood_amt = FLUID_SHALLOW
		if(2)
			flood_amt = FLUID_OVER_MOB_HEAD
		if(3)
			flood_amt = FLUID_DEEP
	if(flood_amt)
		var/turf/T = loc
		if(istype(T))
			T.show_bubbles()
			if(world.time > next_gurgle)
				visible_message("\The [src] gurgles and overflows!")
				next_gurgle = world.time + 80
				playsound(T, pick(SSfluids.gurgles), 50, 1)
			var/adding = min(flood_amt-T?.reagents?.total_volume, rand(30,50)*clogged)
			if(adding > 0)
				T.add_to_reagents(/decl/material/liquid/water, adding)

/obj/structure/hygiene/proc/drain()
	if(!can_drain) return
	var/turf/T = get_turf(src)
	if(!istype(T)) return
	var/fluid_here = T.get_fluid_depth()
	if(fluid_here <= 0)
		return

	T.remove_fluid(ceil(fluid_here*drainage))
	T.show_bubbles()
	if(world.time > last_gurgle + 80)
		last_gurgle = world.time
		playsound(T, pick(SSfluids.gurgles), 50, 1)

/obj/structure/hygiene/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet00"
	density = FALSE
	anchored = TRUE
	tool_interaction_flags = TOOL_INTERACTION_ANCHOR

	var/open = 0			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie

/obj/structure/hygiene/toilet/Initialize()
	. = ..()
	open = round(rand(0, 1))
	update_icon()

/obj/structure/hygiene/toilet/attack_hand(var/mob/user)
	if(!user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()

	if(swirlie)
		usr.visible_message(
			SPAN_DANGER("\The [user] slams the toilet seat onto \the [swirlie]'s head!"),
			SPAN_NOTICE("You slam the toilet seat onto \the [swirlie]'s head!"),
			"You hear reverberating porcelain.")
		swirlie.take_damage(8)
		return TRUE

	// TODO: storage datum
	if(cistern && !open)
		if(!contents.len)
			to_chat(user, SPAN_NOTICE("The cistern is empty."))
		else
			var/obj/item/thing = pick(contents)
			if(ishuman(user))
				user.put_in_hands(thing)
			else
				thing.dropInto(loc)
			to_chat(user, SPAN_NOTICE("You find \a [thing] in the cistern."))
			w_items -= thing.w_class
		return TRUE

	if(user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		open = !open
		update_icon()
		return TRUE

	return ..()

/obj/structure/hygiene/toilet/on_update_icon()
	..()
	icon_state = "toilet[open][cistern]"

/obj/structure/hygiene/toilet/grab_attack(obj/item/grab/grab, mob/user)
	var/mob/living/victim = grab.get_affecting_mob()
	if(istype(victim))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(!victim.loc == get_turf(src))
			to_chat(user, SPAN_WARNING("\The [victim] needs to be on the toilet."))
			return TRUE
		if(open && !swirlie)
			user.visible_message(SPAN_DANGER("\The [user] starts jamming \the [victim]'s face into \the [src]!"))
			swirlie = victim
			if(do_after(user, 30, src))
				user.visible_message(SPAN_DANGER("\The [user] gives [victim.name] a swirlie!"))
				victim.take_damage(5, OXY)
			swirlie = null
		else
			user.visible_message(
			SPAN_DANGER("\The [user] slams \the [victim] into \the [src]!"),
			SPAN_NOTICE("You slam \the [victim] into \the [src]!"))
			victim.take_damage(8)
			playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
		return TRUE
	return ..()

/obj/structure/hygiene/toilet/attackby(obj/item/used_item, var/mob/user)
	if(IS_CROWBAR(used_item))
		to_chat(user, SPAN_NOTICE("You start to [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]."))
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
		if(do_after(user, 30, src))
			user.visible_message(
				SPAN_NOTICE("\The [user] [cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"]!"),
				SPAN_NOTICE("You [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]!"),
				"You hear grinding porcelain.")
			cistern = !cistern
			update_icon()
		return TRUE

	if(cistern && !isrobot(user)) //STOP PUTTING YOUR MODULES IN THE TOILET.
		if(used_item.w_class > ITEM_SIZE_NORMAL)
			to_chat(user, SPAN_WARNING("\The [used_item] does not fit."))
			return TRUE
		if(w_items + used_item.w_class > ITEM_SIZE_HUGE)
			to_chat(user, SPAN_WARNING("The cistern is full."))
			return TRUE
		if(!user.try_unequip(used_item, src))
			return TRUE
		w_items += used_item.w_class
		to_chat(user, SPAN_NOTICE("You carefully place \the [used_item] into the cistern."))
		return TRUE

	. = ..()

/obj/structure/hygiene/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":-32}, "WEST":{"x":32}}'
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

/obj/structure/hygiene/urinal/grab_attack(obj/item/grab/grab, mob/user)
	var/mob/living/victim = grab.get_affecting_mob()
	if(istype(victim))
		if(!victim.loc == get_turf(src))
			to_chat(user, SPAN_WARNING("\The [victim] needs to be on \the [src]."))
		else
			user.visible_message(SPAN_DANGER("\The [user] slams \the [victim] into \the [src]!"))
			victim.take_damage(8)
		return TRUE
	return ..()

/obj/structure/hygiene/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2200s by the Hygiene Division."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = FALSE
	anchored = TRUE
	clogged = -1
	can_drain = 1
	drainage = 0.2 			//showers are tiny, drain a little slower

	var/on = 0
	var/next_mist = 0
	var/next_wash = 0
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/list/temperature_settings = list("normal" = 310, "boiling" = T0C+100, "freezing" = T0C)

	var/sound_id = /obj/structure/hygiene/shower
	var/datum/sound_token/sound_token

//add heat controls? when emagged, you can freeze to death in it?

/obj/structure/hygiene/shower/Initialize()
	. = ..()
	create_reagents(5)

/obj/structure/hygiene/shower/Destroy()
	QDEL_NULL(sound_token)
	. = ..()

/obj/structure/hygiene/shower/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return ..()
	switch_state(!on, user)
	return TRUE

/obj/structure/hygiene/shower/proc/switch_state(new_state, mob/user)
	if(new_state == on)
		return
	on = new_state
	next_mist = on ? (world.time + 5 SECONDS) : INFINITY
	update_icon()
	update_sound()

/obj/structure/hygiene/shower/proc/update_sound()
	playsound(src, on ? 'sound/effects/shower_start.ogg' : 'sound/effects/shower_end.ogg', 40)
	QDEL_NULL(sound_token)
	if(on)
		sound_token = play_looping_sound(src, sound_id, 'sound/effects/shower_mid3.ogg', volume = 20, range = 7, falloff = 4, prefer_mute = TRUE)

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	layer = MOB_LAYER + 1
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE

/obj/effect/mist/Initialize()
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/datum, qdel_self)), 25 SECONDS)

/obj/structure/hygiene/shower/attackby(obj/item/used_item, var/mob/user)
	if(istype(used_item, /obj/item/scanner/gas))
		to_chat(user, SPAN_NOTICE("The water temperature seems to be [watertemp]."))
		return TRUE

	if(IS_WRENCH(used_item))
		var/newtemp = input(user, "What setting would you like to set the temperature valve to?", "Water Temperature Valve") in temperature_settings
		if(newtemp != watertemp && !QDELETED(used_item) && !QDELETED(user) && !QDELETED(src) && user.Adjacent(src) && used_item.loc == src)
			to_chat(user, SPAN_NOTICE("You begin to adjust the temperature valve with \the [used_item]."))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			if(do_after(user, (5 SECONDS), src) && newtemp != watertemp)
				watertemp = newtemp
				user.visible_message(
					SPAN_NOTICE("\The [user] adjusts \the [src] with \the [used_item]."),
					SPAN_NOTICE("You adjust the shower with \the [used_item]."))
				add_fingerprint(user)
		return TRUE
	. = ..()

/obj/structure/hygiene/shower/on_update_icon()
	..()
	if(on)
		add_overlay(image('icons/obj/watercloset.dmi', src, "water", MOB_LAYER + 1, dir))

/obj/structure/hygiene/shower/proc/update_mist()
	if(on && temperature_settings[watertemp] >= T20C && world.time >= next_mist && !(locate(/obj/effect/mist) in loc))
		new /obj/effect/mist(loc)
		next_mist = world.time + (25 SECONDS)

/obj/structure/hygiene/shower/Process()
	..()
	if(on)
		update_mist()
		for(var/thing in loc.get_contained_external_atoms())
			wash_mob(thing)
			process_heat(thing)
		add_to_reagents(/decl/material/liquid/water, REAGENTS_FREE_SPACE(reagents))
		if(world.time >= next_wash)
			next_wash = world.time + (10 SECONDS)
			reagents.splash(get_turf(src), reagents.total_volume, max_spill = 0)

/obj/structure/hygiene/shower/proc/process_heat(mob/living/M)
	if(!on || !istype(M))
		return
	var/water_temperature = temperature_settings[watertemp]
	var/temp_adj = clamp(water_temperature - M.bodytemperature, BODYTEMP_COOLING_MAX, BODYTEMP_HEATING_MAX)
	M.bodytemperature += temp_adj
	if(ishuman(M))
		var/mob/living/human/H = M
		if(water_temperature >= H.get_mob_temperature_threshold(HEAT_LEVEL_1))
			to_chat(H, SPAN_DANGER("The water is searing hot!"))
		else if(water_temperature <= H.get_mob_temperature_threshold(COLD_LEVEL_1))
			to_chat(H, SPAN_DANGER("The water is freezing cold!"))

/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/rubber_duck.dmi'
	icon_state = ICON_STATE_WORLD

/obj/structure/hygiene/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = TRUE
	directional_offset = @'{"NORTH":{"y":22},"SOUTH":{"y":28},"EAST":{"x":16},"WEST":{"x":-16}}'
	var/busy = 0 	//Something's being washed at the moment

/obj/structure/hygiene/sink/receive_mouse_drop(atom/dropping, mob/user, params)
	. = ..()
	if(!. && isitem(dropping) && ATOM_IS_OPEN_CONTAINER(dropping))
		var/obj/item/thing = dropping
		if(thing.reagents?.total_volume <= 0)
			to_chat(usr, SPAN_WARNING("\The [thing] is empty."))
		else
			visible_message(SPAN_NOTICE("\The [user] tips the contents of \the [thing] into \the [src]."))
			thing.reagents.clear_reagents()
			thing.update_icon()
		return TRUE

/obj/structure/hygiene/sink/attack_hand(var/mob/user)

	if(isrobot(user) || isAI(user) || !Adjacent(user))
		return ..()

	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return TRUE

	to_chat(usr, SPAN_NOTICE("You start washing your hands."))
	playsound(loc, 'sound/effects/sink_long.ogg', 75, 1)

	busy = TRUE
	if(!do_after(user, 40, src))
		busy = FALSE
		return TRUE
	busy = FALSE

	user.clean()
	user.visible_message(
		SPAN_NOTICE("\The [user] washes their hands using \the [src]."),
		SPAN_NOTICE("You wash your hands using \the [src]."))
	return TRUE

/obj/structure/hygiene/sink/attackby(obj/item/used_item, var/mob/user)
	if(isplunger(used_item) && clogged > 0)
		return ..()

	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return TRUE

	var/obj/item/chems/chem_container = used_item
	if (istype(chem_container) && ATOM_IS_OPEN_CONTAINER(chem_container) && chem_container.reagents)
		user.visible_message(
			SPAN_NOTICE("\The [user] fills \the [chem_container] using \the [src]."),
			SPAN_NOTICE("You fill \the [chem_container] using \the [src]."))
		playsound(loc, 'sound/effects/sink.ogg', 75, 1)
		chem_container.add_to_reagents(/decl/material/liquid/water, min(REAGENTS_FREE_SPACE(chem_container.reagents), chem_container.amount_per_transfer_from_this))
		return TRUE

	else if (istype(used_item, /obj/item/baton))
		var/obj/item/baton/baton = used_item
		var/obj/item/cell/cell = baton.get_cell()
		if(cell?.check_charge(0) && baton.status)
			if(isliving(user))
				var/mob/living/living_victim = user
				SET_STATUS_MAX(living_victim, STAT_STUN, 10)
				SET_STATUS_MAX(living_victim, STAT_STUTTER, 10)
				SET_STATUS_MAX(living_victim, STAT_WEAK, 10)
			// robot users used to be handled separately, but deductcharge handles that for us
			baton.deductcharge(baton.hitcost)
			var/decl/pronouns/user_pronouns = user.get_pronouns()
			user.visible_message(SPAN_DANGER("\The [user] was stunned by [user_pronouns.his] wet [used_item]!"))
			return TRUE
	else if(istype(used_item, /obj/item/mop))
		if(REAGENTS_FREE_SPACE(used_item.reagents) >= 5)
			used_item.add_to_reagents(/decl/material/liquid/water, 5)
			to_chat(user, SPAN_NOTICE("You wet \the [used_item] in \the [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("\The [used_item] is saturated."))
		return TRUE

	var/turf/location = user.loc
	if(!isturf(location))
		return FALSE

	if(!istype(used_item))
		return FALSE

	to_chat(usr, SPAN_NOTICE("You start washing \the [used_item]."))
	playsound(loc, 'sound/effects/sink_long.ogg', 75, 1)

	busy = TRUE
	if(!do_after(user, 40, src))
		busy = FALSE
		return TRUE
	busy = FALSE

	if(istype(used_item, /obj/item/chems/spray/extinguisher))
		return TRUE // We're washing, not filling.

	used_item.clean()
	user.visible_message( \
		SPAN_NOTICE("\The [user] washes \a [used_item] using \the [src]."),
		SPAN_NOTICE("You wash \a [used_item] using \the [src]."))
	return TRUE


/obj/structure/hygiene/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"
	directional_offset = @'{"NORTH":{"y":22},"SOUTH":{"y":28},"EAST":{"x":-22},"WEST":{"x":22}}'

/obj/structure/hygiene/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	icon_state = "puddle"
	clogged = -1 // how do you clog a puddle
	directional_offset = null

/obj/structure/hygiene/sink/puddle/attack_hand(var/mob/M)
	flick("puddle-splash", src)
	return ..()

/obj/structure/hygiene/sink/puddle/attackby(obj/item/used_item, var/mob/user)
	. = ..()
	if(.)
		flick("puddle-splash", src)

////////////////////////////////////////////////////
// Toilet Paper Roll
////////////////////////////////////////////////////
/decl/barricade_tape_template/toilet
	tape_kind         = "toilet paper"
	tape_desc         = "A length of toilet paper. Seems like custodia is marking their territory again."
	roll_desc         = "An unbranded roll of standard-issue two-ply toilet paper. Refined from carefully rendered-down seashells due to the government's 'Abuse Of The Trees Act'."
	base_icon_state   = "stripetape"
	tape_color        = COLOR_WHITE
	detail_overlay    = "stripes"
	detail_color      = COLOR_WHITE

/obj/item/stack/tape_roll/barricade_tape/toilet
	icon          = 'icons/obj/toiletpaper.dmi'
	icon_state    = ICON_STATE_WORLD
	slot_flags    = SLOT_HEAD | SLOT_OVER_BODY
	amount        = 30
	max_amount    = 30
	tape_template = /decl/barricade_tape_template/toilet

/obj/item/stack/tape_roll/barricade_tape/toilet/verb/tear_sheet()
	set category = "Object"
	set name     = "Tear Sheet"
	set desc     = "Tear a sheet of toilet paper."
	set src in usr

	if (usr.incapacitated())
		return

	if(can_use(1))
		usr.visible_message(SPAN_NOTICE("\The [usr] tears a sheet from \the [src]."), SPAN_NOTICE("You tear a sheet from \the [src]."))
		var/obj/item/paper/crumpled/bog/C =  new(loc)
		usr.put_in_hands(C)

////////////////////////////////////////////////////
// Toilet Paper Sheet
////////////////////////////////////////////////////
/obj/item/paper/crumpled/bog
	name       = "sheet of toilet paper"
	desc       = "A single sheet of toilet paper. Two-ply."
	icon       = 'icons/obj/items/paperwork/toilet_paper.dmi'

/obj/structure/hygiene/faucet
	name = "faucet"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "faucet"
	desc = "An outlet for liquids. Water you waiting for?"
	anchored = TRUE
	drainage = 0
	clogged = -1

	var/fill_level = 500
	var/open = FALSE

/obj/structure/hygiene/faucet/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES))
		return ..()
	open = !open
	if(open)
		playsound(src.loc, 'sound/effects/closet_open.ogg', 20, 1)
	else
		playsound(src.loc, 'sound/effects/closet_close.ogg', 20, 1)
	user.visible_message(SPAN_NOTICE("\The [user] has [open ? "opened" : "closed"] the faucet."))
	update_icon()
	return TRUE

/obj/structure/hygiene/faucet/on_update_icon()
	..()
	icon_state = icon_state = "[initial(icon_state)][open ? "-on" : null]"

/obj/structure/hygiene/faucet/proc/water_flow()
	if(!isturf(src.loc))
		return

	// Check for depth first, and pass if the water's too high. I know players will find a way to just submerge entire ship if I do not.
	var/turf/T = get_turf(src)

	if(!T || T.get_fluid_depth() > fill_level)
		return

	if(world.time > next_gurgle)
		next_gurgle = world.time + 80
		playsound(T, pick(SSfluids.gurgles), 50, 1)

	T.add_to_reagents(/decl/material/liquid/water, min(75, fill_level - T.get_fluid_depth()))

/obj/structure/hygiene/faucet/Process()
	..()
	if(open)
		water_flow()

/obj/structure/hygiene/faucet/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	. += "It is turned [open ? "on" : "off"]."
