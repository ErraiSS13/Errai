/obj/item/mech_component
	icon = 'icons/mecha/mech_parts_held.dmi'
	w_class = ITEM_SIZE_HUGE
	gender = PLURAL
	color = COLOR_GUNMETAL
	atom_flags = ATOM_FLAG_CAN_BE_PAINTED

	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/osmium = MATTER_AMOUNT_TRACE
	)
	dir = SOUTH

	var/on_mech_icon = 'icons/mecha/mech_parts.dmi'
	var/exosuit_desc_string
	var/total_damage = 0
	var/brute_damage = 0
	var/burn_damage = 0
	var/max_damage = 60
	var/damage_state = 1
	var/list/has_hardpoints = list()
	var/decal
	var/decal_blend = BLEND_MULTIPLY
	var/power_use = 0

/obj/item/mech_component/emp_act(var/severity)
	take_burn_damage(rand((10 - (severity*3)),15-(severity*4)))
	for(var/obj/item/thing in contents)
		thing.emp_act(severity)

/obj/item/mech_component/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(ready_to_install())
		. += SPAN_NOTICE("It is ready for installation.")
	else
		var/list/missing_parts = show_missing_parts(user)
		if(length(missing_parts))
			. += missing_parts

//These icons have multiple directions but before they're attached we only want south.
/obj/item/mech_component/set_dir()
	..(SOUTH)

/obj/item/mech_component/proc/show_missing_parts(var/mob/user)
	return

/obj/item/mech_component/proc/prebuild()
	return

/obj/item/mech_component/proc/install_component(var/obj/item/thing, var/mob/user)
	if(user.try_unequip(thing, src))
		user.visible_message(SPAN_NOTICE("\The [user] installs \the [thing] in \the [src]."))
		return TRUE
	return FALSE

/obj/item/mech_component/proc/update_component_health()
	total_damage = brute_damage + burn_damage
	if(total_damage > max_damage) total_damage = max_damage
	var/prev_state = damage_state
	damage_state = clamp(round((total_damage/max_damage) * 4), MECH_COMPONENT_DAMAGE_UNDAMAGED, MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)
	if(damage_state > prev_state)
		if(damage_state == MECH_COMPONENT_DAMAGE_DAMAGED_BAD)
			playsound(src.loc, 'sound/mecha/internaldmgalarm.ogg', 40, 1)
		if(damage_state == MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)
			playsound(src.loc, 'sound/mecha/critdestr.ogg', 50)

/obj/item/mech_component/proc/ready_to_install()
	return 1

/obj/item/mech_component/proc/repair_brute_damage(var/amt)
	take_brute_damage(-amt)

/obj/item/mech_component/proc/repair_burn_damage(var/amt)
	take_burn_damage(-amt)

/obj/item/mech_component/proc/take_brute_damage(var/amt)
	brute_damage = max(0, brute_damage + amt)
	update_component_health()
	if(total_damage == max_damage)
		take_component_damage(amt,0)

/obj/item/mech_component/proc/take_burn_damage(var/amt)
	burn_damage = max(0, burn_damage + amt)
	update_component_health()
	if(total_damage == max_damage)
		take_component_damage(0,amt)

/obj/item/mech_component/proc/take_component_damage(var/brute, var/burn)
	var/list/damageable_components = list()
	for(var/obj/item/robot_parts/robot_component/RC in contents)
		damageable_components += RC
	if(!damageable_components.len) return
	var/obj/item/robot_parts/robot_component/RC = pick(damageable_components)
	if(RC.take_damage(brute, BRUTE) || RC.take_damage(burn, BURN))
		qdel(RC)
		update_components()

/obj/item/mech_component/attackby(var/obj/item/used_item, var/mob/user)

	if(IS_SCREWDRIVER(used_item))
		if(contents.len)
			//Filter non movables
			var/list/valid_contents = list()
			for(var/atom/movable/A in contents)
				if(!A.anchored)
					valid_contents += A
			if(!valid_contents.len)
				return TRUE
			var/obj/item/removed = pick(valid_contents)
			if(!(removed in contents))
				return TRUE
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [removed] from \the [src]."))
			removed.forceMove(user.loc)
			playsound(user.loc, 'sound/effects/pop.ogg', 50, 0)
			update_components()
		else
			to_chat(user, SPAN_WARNING("There is nothing to remove."))
		return TRUE

	if(IS_WELDER(used_item))
		repair_brute_generic(used_item, user)
		return TRUE

	if(IS_COIL(used_item))
		repair_burn_generic(used_item, user)
		return TRUE

	if(istype(used_item, /obj/item/robotanalyzer))
		to_chat(user, SPAN_NOTICE("Diagnostic Report for \the [src]:"))
		return_diagnostics(user)
		return TRUE

	return ..()

/obj/item/mech_component/proc/update_components()
	return

/obj/item/mech_component/proc/repair_brute_generic(var/obj/item/weldingtool/welder, var/mob/user)
	if(!istype(welder))
		return
	if(!brute_damage)
		to_chat(user, SPAN_NOTICE("You inspect \the [src] but find nothing to weld."))
		return
	if(!welder.isOn())
		to_chat(user, SPAN_WARNING("Turn \the [welder] on, first."))
		return
	if(welder.weld((SKILL_MAX + 1) - user.get_skill_value(SKILL_CONSTRUCTION), user))
		user.visible_message(
			SPAN_NOTICE("\The [user] begins welding the damage on \the [src]..."),
			SPAN_NOTICE("You begin welding the damage on \the [src]...")
		)
		var/repair_value = 10 * max(user.get_skill_value(SKILL_CONSTRUCTION), user.get_skill_value(SKILL_DEVICES))
		if(user.do_skilled(10, SKILL_DEVICES , src, 0.6) && brute_damage)
			repair_brute_damage(repair_value)
			to_chat(user, SPAN_NOTICE("You mend the damage to \the [src]."))
			playsound(user.loc, 'sound/items/Welder.ogg', 25, 1)

/obj/item/mech_component/proc/repair_burn_generic(var/obj/item/stack/cable_coil/CC, var/mob/user)
	if(!istype(CC))
		return
	if(!burn_damage)
		to_chat(user, SPAN_NOTICE("\The [src]'s wiring doesn't need replacing."))
		return

	var/needed_amount = 6 - user.get_skill_value(SKILL_ELECTRICAL)
	if(CC.get_amount() < needed_amount)
		to_chat(user, SPAN_WARNING("You need at least [needed_amount] unit\s of cable to repair this section."))
		return

	user.visible_message("\The [user] begins replacing the wiring of \the [src]...")

	if(user.do_skilled(10, SKILL_DEVICES , src, 0.6) && burn_damage)
		if(QDELETED(CC) || QDELETED(src) || !CC.use(needed_amount))
			return

		repair_burn_damage(25)
		to_chat(user, SPAN_NOTICE("You mend the damage to \the [src]'s wiring."))
		playsound(user.loc, 'sound/items/Deconstruct.ogg', 25, 1)
	return

/obj/item/mech_component/proc/get_damage_string()
	switch(damage_state)
		if(MECH_COMPONENT_DAMAGE_UNDAMAGED)
			return SPAN_GREEN("undamaged")
		if(MECH_COMPONENT_DAMAGE_DAMAGED)
			return SPAN_YELLOW("damaged")
		if(MECH_COMPONENT_DAMAGE_DAMAGED_BAD)
			return SPAN_ORANGE("badly damaged")
		if(MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)
			return SPAN_RED("almost destroyed")
	return SPAN_RED("destroyed")

/obj/item/mech_component/proc/return_diagnostics(var/mob/user)
	to_chat(user, SPAN_NOTICE("[capitalize(src.name)]:"))
	to_chat(user, SPAN_NOTICE(" - Integrity: <b>[round((((max_damage - total_damage) / max_damage)) * 100)]%</b>" ))
