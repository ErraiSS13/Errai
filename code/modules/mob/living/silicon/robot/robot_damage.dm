/mob/living/silicon/robot/getBruteLoss()
	var/amount = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 0) amount += C.brute_damage
	return amount

/mob/living/silicon/robot/getFireLoss()
	var/amount = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 0) amount += C.burn_damage
	return amount

/mob/living/silicon/robot/adjustBruteLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(FALSE) // take/heal overall call update_health regardless of arg
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)

/mob/living/silicon/robot/adjustFireLoss(var/amount, var/do_update_health = TRUE)
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)

/mob/living/silicon/robot/proc/get_damaged_components(var/brute, var/burn, var/destroyed = 0)
	var/list/datum/robot_component/parts = list()
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1 || (C.installed == -1 && destroyed))
			if((brute && C.brute_damage) || (burn && C.burn_damage) || (!C.toggled) || (!C.powered && C.toggled))
				parts += C
	return parts

/mob/living/silicon/robot/proc/get_damageable_components()
	var/list/rval = new
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1) rval += C
	return rval

/mob/living/silicon/robot/proc/get_armour()

	if(!components.len) return 0
	var/datum/robot_component/C = components["armour"]
	if(C && C.installed == 1)
		return C
	return 0

/mob/living/silicon/robot/heal_organ_damage(var/brute, var/burn, var/affect_robo = FALSE, var/update_health = TRUE)
	var/list/datum/robot_component/parts = get_damaged_components(brute, burn)
	if(!parts.len)	return
	var/datum/robot_component/picked = pick(parts)
	picked.heal_damage(brute,burn)

/mob/living/silicon/robot/take_organ_damage(var/brute = 0, var/burn = 0, var/bypass_armour = FALSE, var/override_droplimb)
	var/list/components = get_damageable_components()
	if(!components.len)
		return

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	var/obj/item/borg/combat/shield/shield = get_active_held_item()
	if(istype(shield))
		//Shields absorb a certain percentage of damage based on their power setting.
		var/absorb_brute = brute*shield.shield_level
		var/absorb_burn = burn*shield.shield_level
		var/cost = (absorb_brute+absorb_burn)*100

		cell.charge -= cost
		if(cell.charge <= 0)
			cell.charge = 0
			to_chat(src, "<span class='warning'>Your shield has overloaded!</span>")
		else
			brute -= absorb_brute
			burn -= absorb_burn
			to_chat(src, "<span class='warning'>Your shield absorbs some of the impact!</span>")

	if(!bypass_armour)
		var/datum/robot_component/armour/A = get_armour()
		if(A)
			A.take_component_damage(brute, burn)
			return

	var/datum/robot_component/C = pick(components)
	C.take_component_damage(brute, burn)

/mob/living/silicon/robot/heal_overall_damage(var/brute, var/burn)
	var/list/datum/robot_component/parts = get_damaged_components(brute,burn)

	while(parts.len && (brute>0 || burn>0) )
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.burn_damage

		picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_damage)
		burn -= (burn_was-picked.burn_damage)

		parts -= picked

/mob/living/silicon/robot/take_overall_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/used_weapon = null)
	if(status_flags & GODMODE)	return	//godmode
	var/list/datum/robot_component/parts = get_damageable_components()

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	var/obj/item/borg/combat/shield/shield = get_active_held_item()
	if(istype(shield))
		//Shields absorb a certain percentage of damage based on their power setting.
		var/absorb_brute = brute*shield.shield_level
		var/absorb_burn = burn*shield.shield_level
		var/cost = (absorb_brute+absorb_burn)*100

		cell.charge -= cost
		if(cell.charge <= 0)
			cell.charge = 0
			to_chat(src, "<span class='warning'>Your shield has overloaded!</span>")
		else
			brute -= absorb_brute
			burn -= absorb_burn
			to_chat(src, "<span class='warning'>Your shield absorbs some of the impact!</span>")

	var/datum/robot_component/armour/A = get_armour()
	if(A)
		A.take_component_damage(brute,burn,sharp)
	else
		while(parts.len && (brute>0 || burn>0) )
			var/datum/robot_component/picked = pick(parts)
			var/brute_was = picked.brute_damage
			var/burn_was = picked.burn_damage
			picked.take_component_damage(brute,burn)
			brute	-= (picked.brute_damage - brute_was)
			burn	-= (picked.burn_damage - burn_was)
			parts -= picked
	update_health()

/mob/living/silicon/robot/emp_act(severity)
	drop_held_items()
	..() //Damage is handled at /silicon/ level.
