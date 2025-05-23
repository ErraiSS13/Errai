//backpack item
/obj/item/defibrillator
	name = "auto-resuscitator"
	desc = "A device that delivers powerful shocks via detachable paddles to resuscitate incapacitated patients."
	icon = 'icons/obj/defibrillator.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	origin_tech = @'{"biotech":4,"powerstorage":2}'
	action_button_name = "Remove/Replace Paddles"
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/copper = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/steel  = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon      = MATTER_AMOUNT_TRACE,
	)

	var/obj/item/shockpaddles/linked/paddles
	var/obj/item/cell/bcell = null

/obj/item/defibrillator/Initialize() //starts without a cell for rnd
	if(ispath(paddles))
		paddles = new paddles(src, src)
	else
		paddles = new(src, src)
	if(ispath(bcell))
		bcell = new bcell(src)
	. = ..()
	update_icon()

/obj/item/defibrillator/Destroy()
	. = ..()
	QDEL_NULL(paddles)
	QDEL_NULL(bcell)

/obj/item/defibrillator/loaded //starts with regular power cell for R&D to replace later in the round.
	bcell = /obj/item/cell/apc

/obj/item/defibrillator/on_update_icon()
	. = ..()
	if(paddles) //in case paddles got destroyed somehow.
		if(paddles.loc == src)
			add_overlay("[icon_state]-paddles")
		if(bcell && bcell.check_charge(paddles.chargecost))
			if(!paddles.safety)
				add_overlay("[icon_state]-emagged")
			else
				add_overlay("[icon_state]-powered")
	if(bcell)
		var/ratio = ceil(bcell.percent()/25) * 25
		add_overlay("[icon_state]-charge[ratio]")
	else
		add_overlay("[icon_state]-nocell")

/obj/item/defibrillator/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(bcell)
		. += "The charge meter is showing [bcell.percent()]% charge left."
	else
		. += SPAN_WARNING("There is no cell inside.")

/obj/item/defibrillator/ui_action_click()
	toggle_paddles()

/obj/item/defibrillator/attack_hand(mob/user)
	if(loc != user || !user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	toggle_paddles()
	return TRUE

// TODO: This should really use the cell extension
/obj/item/defibrillator/attackby(obj/item/used_item, mob/user, params)
	if(used_item == paddles)
		reattach_paddles(user)
		return TRUE
	else if(istype(used_item, /obj/item/cell))
		if(bcell)
			to_chat(user, "<span class='notice'>\The [src] already has a cell.</span>")
		else
			if(!user.try_unequip(used_item))
				return TRUE
			used_item.forceMove(src)
			bcell = used_item
			to_chat(user, "<span class='notice'>You install a cell in \the [src].</span>")
			update_icon()
		return TRUE

	else if(IS_SCREWDRIVER(used_item))
		if(bcell)
			bcell.update_icon()
			bcell.dropInto(loc)
			bcell = null
			to_chat(user, "<span class='notice'>You remove the cell from \the [src].</span>")
			update_icon()
			return TRUE
		return FALSE
	else
		return ..()

/obj/item/defibrillator/emag_act(var/uses, var/mob/user)
	if(paddles)
		return paddles.emag_act(uses, user, src)
	return NO_EMAG_ACT

//Paddle stuff

/obj/item/defibrillator/verb/toggle_paddles()
	set name = "Toggle Paddles"
	set category = "Object"

	var/mob/living/human/user = usr
	if(!paddles)
		to_chat(user, "<span class='warning'>The paddles are missing!</span>")
		return

	if(paddles.loc != src)
		reattach_paddles(user) //Remove from their hands and back onto the defib unit
		return

	if(!slot_check())
		to_chat(user, "<span class='warning'>You need to equip [src] before taking out [paddles].</span>")
	else
		if(!usr.put_in_hands(paddles)) //Detach the paddles into the user's hands
			to_chat(user, "<span class='warning'>You need a free hand to hold the paddles!</span>")
		update_icon() //success

//checks that the base unit is in the correct slot to be used
/obj/item/defibrillator/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back_str) == src)
		return 1
	if((slot_flags & SLOT_LOWER_BODY) && M.get_equipped_item(slot_belt_str) == src)
		return 1

	return 0

/obj/item/defibrillator/dropped(mob/user)
	..()
	reattach_paddles(user) //paddles attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/defibrillator/proc/reattach_paddles(mob/user)
	if(!paddles) return

	if(ismob(paddles.loc))
		var/mob/M = paddles.loc
		if(M.drop_from_inventory(paddles, src))
			to_chat(user, "<span class='notice'>\The [paddles] snap back into the main unit.</span>")
	else
		paddles.forceMove(src)

	update_icon()

/*
	Base Unit Subtypes
*/

/obj/item/defibrillator/compact
	name = "compact defibrillator"
	desc = "A belt-equipped defibrillator that can be rapidly deployed."
	icon = 'icons/obj/defibrillator_compact.dmi'
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_LOWER_BODY
	origin_tech = @'{"biotech":5,"powerstorage":3}'

/obj/item/defibrillator/compact/loaded
	bcell = /obj/item/cell/high


/obj/item/defibrillator/compact/combat
	name = "combat defibrillator"
	desc = "A belt-equipped blood-red defibrillator that can be rapidly deployed. Does not have the restrictions or safeties of conventional defibrillators and can revive through space suits."
	paddles = /obj/item/shockpaddles/linked/combat

/obj/item/defibrillator/compact/combat/loaded
	bcell = /obj/item/cell/high

/obj/item/shockpaddles/linked/combat
	combat = 1
	safety = 0
	chargetime = (1 SECONDS)

//paddles
/obj/item/shockpaddles
	name = "defibrillator paddles"
	desc = "A pair of plastic-gripped paddles with flat metal surfaces that are used to deliver powerful electric shocks."
	icon = 'icons/obj/defibrillator_paddles.dmi'
	icon_state = ICON_STATE_WORLD
	gender = PLURAL
	w_class = ITEM_SIZE_LARGE
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/metal/copper = MATTER_AMOUNT_SECONDARY, /decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY)
	max_health = ITEM_HEALTH_NO_DAMAGE
	_base_attack_force = 2
	can_be_twohanded = TRUE
	minimum_size_to_twohand = MOB_SIZE_SMALL

	var/safety = 1 //if you can zap people with the paddles on harm mode
	var/combat = 0 //If it can be used to revive people wearing thick clothing (e.g. spacesuits)
	var/cooldowntime = (6 SECONDS) // How long in deciseconds until the defib is ready again after use.
	var/chargetime = (2 SECONDS)
	var/chargecost = 100 //units of charge
	var/burn_damage_amt = 5

	var/wielded = 0
	var/cooldown = 0
	var/busy = 0

/obj/item/shockpaddles/proc/set_cooldown(var/delay)
	cooldown = 1
	update_icon()

	spawn(delay)
		if(cooldown)
			cooldown = 0
			update_icon()
			make_announcement("beeps, \"Unit is re-energized.\"", "notice")
			playsound(src, 'sound/machines/defib_ready.ogg', 50, 0)

/obj/item/shockpaddles/update_twohanding()
	var/mob/living/M = loc
	if(istype(M) && is_held_twohanded(M))
		wielded = 1
		SetName("[initial(name)] (wielded)")
	else
		wielded = 0
		SetName(initial(name))
	update_icon()
	..()

/obj/item/shockpaddles/on_update_icon()
	. = ..()
	if(cooldown)
		add_overlay("[icon_state]-cooldown")

/obj/item/shockpaddles/proc/can_use(mob/user, mob/M)
	if(busy)
		return 0
	if(!check_charge(chargecost))
		to_chat(user, "<span class='warning'>\The [src] doesn't have enough charge left to do that.</span>")
		return 0
	if(!wielded && !isrobot(user))
		to_chat(user, "<span class='warning'>You need to wield the paddles with both hands before you can use them on someone!</span>")
		return 0
	if(cooldown)
		to_chat(user, "<span class='warning'>\The [src] are re-energizing!</span>")
		return 0
	return 1

//Checks for various conditions to see if the mob is revivable
/obj/item/shockpaddles/proc/can_defib(mob/living/human/H) //This is checked before doing the defib operation
	if(H.has_body_flag(BODY_FLAG_NO_DEFIB))
		return "buzzes, \"Unrecogized physiology. Operation aborted.\""

	if(!check_contact(H))
		return "buzzes, \"Patient's chest is obstructed. Operation aborted.\""

/obj/item/shockpaddles/proc/can_revive(mob/living/human/H) //This is checked right before attempting to revive
	if(H.stat == DEAD)
		return "buzzes, \"Resuscitation failed - Severe neurological decay makes recovery of patient impossible. Further attempts futile.\""

/obj/item/shockpaddles/proc/check_contact(mob/living/human/H)
	if(!combat)
		for(var/slot in list(slot_wear_suit_str, slot_w_uniform_str))
			var/obj/item/clothing/cloth = H.get_equipped_item(slot)
			if(istype(cloth) && (cloth.body_parts_covered & SLOT_UPPER_BODY) && (cloth.item_flags & ITEM_FLAG_THICKMATERIAL))
				return FALSE
	return TRUE

/obj/item/shockpaddles/proc/check_blood_level(mob/living/human/H)
	if(H.should_have_organ(BP_HEART))
		var/obj/item/organ/internal/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
		if(!heart || H.get_blood_volume() < BLOOD_VOLUME_SURVIVE)
			return TRUE
	return FALSE

/obj/item/shockpaddles/proc/check_charge(var/charge_amt)
	return 0

/obj/item/shockpaddles/proc/checked_use(var/charge_amt)
	return 0

/obj/item/shockpaddles/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(!ishuman(target) || user.check_intent(I_FLAG_HARM))
		return ..() //Do a regular attack. Harm intent shocking happens as a hit effect
	var/mob/living/human/H = target
	if(can_use(user, H))
		busy = 1
		update_icon()
		do_revive(H, user)
		busy = 0
		update_icon()
	return TRUE

//Since harm-intent now skips the delay for deliberate placement, you have to be able to hit them in combat in order to shock people.
/obj/item/shockpaddles/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(ishuman(target) && can_use(user, target))
		busy = 1
		update_icon()

		do_electrocute(target, user, hit_zone)

		busy = 0
		update_icon()

		return 1

	return ..()

// This proc is used so that we can return out of the revive process while ensuring that busy and update_icon() are handled
/obj/item/shockpaddles/proc/do_revive(mob/living/human/H, mob/living/user)
	if(H.ssd_check())
		to_chat(find_dead_player(H.ckey, 1), "<span class='notice'>Someone is attempting to resuscitate you. Re-enter your body if you want to be revived!</span>")

	//beginning to place the paddles on patient's chest to allow some time for people to move away to stop the process
	user.visible_message("<span class='warning'>\The [user] begins to place [src] on [H]'s chest.</span>", "<span class='warning'>You begin to place [src] on [H]'s chest...</span>")
	if(!user.do_skilled(3 SECONDS, SKILL_MEDICAL, H))
		return
	user.visible_message("<span class='notice'>\The [user] places [src] on [H]'s chest.</span>", "<span class='warning'>You place [src] on [H]'s chest.</span>")
	playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)

	var/error = can_defib(H)
	if(error)
		make_announcement(error, "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	if(check_blood_level(H))
		make_announcement("buzzes, \"Warning - Patient is in hypovolemic shock and may require a blood transfusion.\"", "warning") //also includes heart damage

	//People may need more direct instruction
	var/obj/item/organ/internal/heart = GET_INTERNAL_ORGAN(H, BP_HEART)
	if(heart?.is_bruised())
		make_announcement("buzzes, \"Danger! The patient has sustained a cardiac contusion and will require surgical treatment for full recovery!\"", "danger")

	//placed on chest and short delay to shock for dramatic effect, revive time is 5sec total
	if(!do_after(user, chargetime, H))
		return

	//deduct charge here, in case the base unit was EMPed or something during the delay time
	if(!checked_use(chargecost))
		make_announcement("buzzes, \"Insufficient charge.\"", "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	H.visible_message("<span class='warning'>\The [H]'s body convulses a bit.</span>")
	playsound(get_turf(src), "bodyfall", 50, 1)
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
	set_cooldown(cooldowntime)

	error = can_revive(H)
	if(error)
		make_announcement(error, "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return
	if(!user.skill_check(SKILL_MEDICAL, SKILL_BASIC) && !lowskill_revive(H, user))
		return
	H.apply_damage(burn_damage_amt, BURN, BP_CHEST)

	//set oxyloss so that the patient is just barely in crit, if possible
	make_announcement("pings, \"Resuscitation successful.\"", "notice")
	playsound(get_turf(src), 'sound/machines/defib_success.ogg', 50, 0)
	H.resuscitate()
	var/obj/item/organ/internal/cell/potato = H.get_organ(BP_CELL, /obj/item/organ/internal/cell)
	if(potato && potato.cell)
		var/obj/item/cell/cell = potato.cell
		cell.give(chargecost)

	ADJ_STATUS(H, STAT_ASLEEP, -60)
	log_and_message_admins("used \a [src] to revive [key_name(H)].")

/obj/item/shockpaddles/proc/lowskill_revive(mob/living/human/H, mob/living/user)
	if(prob(60))
		playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 100, 1, -1)
		H.electrocute_act(burn_damage_amt*4, src, def_zone = BP_CHEST)
		user.visible_message("<span class='warning'><i>The paddles were misaligned! \The [user] shocks [H] with \the [src]!</i></span>", "<span class='warning'>The paddles were misaligned! You shock [H] with \the [src]!</span>")
		return 0
	if(prob(50))
		playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 100, 1, -1)
		user.electrocute_act(burn_damage_amt*2, src, def_zone = BP_L_HAND)
		user.electrocute_act(burn_damage_amt*2, src, def_zone = BP_R_HAND)
		user.visible_message("<span class='warning'><i>\The [user] shocks themselves with \the [src]!</i></span>", "<span class='warning'>You forget to move your hands away and shock yourself with \the [src]!</span>")
		return 0
	return 1

/obj/item/shockpaddles/proc/do_electrocute(mob/living/human/H, mob/user, var/target_zone)
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, check_zone(target_zone, H, TRUE)) //Shouldn't defib someone's eyes or mouth
	if(!affecting)
		to_chat(user, SPAN_WARNING("They are missing that body part!"))
		return

	//no need to spend time carefully placing the paddles, we're just trying to shock them
	user.visible_message(SPAN_DANGER("\The [user] slaps [src] onto [H]'s [affecting.name]."), SPAN_DANGER("You overcharge [src] and slap them onto [H]'s [affecting.name]."))

	//Just stop at awkwardly slapping electrodes on people if the safety is enabled
	if(safety)
		to_chat(user, SPAN_WARNING("You can't do that while the safety is enabled."))
		return

	playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)
	audible_message(SPAN_WARNING("\The [src] lets out a steadily rising hum..."))

	if(!do_after(user, chargetime, H))
		return

	//deduct charge here, in case the base unit was EMPed or something during the delay time
	if(!checked_use(chargecost))
		make_announcement("buzzes, \"Insufficient charge.\"", "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	user.visible_message(SPAN_DANGER("<i>\The [user] shocks [H] with \the [src]!</i>"), SPAN_WARNING("You shock [H] with \the [src]!"))
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 100, 1, -1)
	playsound(loc, 'sound/weapons/Egloves.ogg', 100, 1, -1)
	set_cooldown(cooldowntime)

	H.stun_effect_act(2, 120, target_zone)
	var/burn_damage = H.electrocute_act(burn_damage_amt*2, src, def_zone = target_zone)
	if(burn_damage > 15 && H.can_feel_pain())
		H.emote(/decl/emote/audible/scream)
	var/obj/item/organ/internal/heart/doki = locate() in affecting.internal_organs
	if(istype(doki) && doki.pulse && !doki.open && prob(10))
		to_chat(doki, SPAN_DANGER("Your [doki] has stopped!"))
		doki.pulse = PULSE_NONE

	admin_attack_log(user, H, "Electrocuted using \a [src]", "Was electrocuted with \a [src]", "used \a [src] to electrocute")

/obj/item/shockpaddles/proc/make_announcement(var/message, var/msg_class)
	audible_message("<b>\The [src]</b> [message]", "\The [src] vibrates slightly.")

/obj/item/shockpaddles/emag_act(var/uses, var/mob/user, var/obj/item/defibrillator/base)
	if(istype(src, /obj/item/shockpaddles/linked))
		var/obj/item/shockpaddles/linked/dfb = src
		if(dfb.base_unit)
			base = dfb.base_unit
	if(!base)
		return
	if(safety)
		safety = 0
		to_chat(user, "<span class='warning'>You silently disable \the [src]'s safety protocols with the cryptographic sequencer.</span>")
		burn_damage_amt *= 3
		base.update_icon()
		return 1
	else
		safety = 1
		to_chat(user, "<span class='notice'>You silently enable \the [src]'s safety protocols with the cryptographic sequencer.</span>")
		burn_damage_amt = initial(burn_damage_amt)
		base.update_icon()
		return 1

/obj/item/shockpaddles/emp_act(severity)
	var/new_safety = rand(0, 1)
	if(safety != new_safety)
		safety = new_safety
		if(safety)
			make_announcement("beeps, \"Safety protocols enabled!\"", "notice")
			playsound(get_turf(src), 'sound/machines/defib_safetyon.ogg', 50, 0)
		else
			make_announcement("beeps, \"Safety protocols disabled!\"", "warning")
			playsound(get_turf(src), 'sound/machines/defib_safetyoff.ogg', 50, 0)
		update_icon()
	..()

/obj/item/shockpaddles/robot
	name = "defibrillator paddles"
	desc = "A pair of advanced shock paddles powered by a robot's internal power cell, able to penetrate thick clothing."
	chargecost = 50
	combat = 1
	cooldowntime = (3 SECONDS)

/obj/item/shockpaddles/robot/check_charge(var/charge_amt)
	if(isrobot(loc))
		var/mob/living/silicon/robot/robot = loc
		return robot.cell?.check_charge(charge_amt)

/obj/item/shockpaddles/robot/checked_use(var/charge_amt)
	if(isrobot(loc))
		var/mob/living/silicon/robot/robot = loc
		return robot.cell?.checked_use(charge_amt)

/obj/item/shockpaddles/rig
	name = "mounted defibrillator"
	desc = "If you can see this something is very wrong, report this bug."
	cooldowntime = (4 SECONDS)
	chargetime = (1 SECOND)
	chargecost = 150
	safety = 0
	wielded = 1

/obj/item/shockpaddles/rig/check_charge(var/charge_amt)
	if(istype(loc, /obj/item/rig_module/device/defib))
		var/obj/item/rig_module/device/defib/module = loc
		return (module.holder && module.holder.cell && module.holder.cell.check_charge(charge_amt))

/obj/item/shockpaddles/rig/checked_use(var/charge_amt)
	if(istype(loc, /obj/item/rig_module/device/defib))
		var/obj/item/rig_module/device/defib/module = loc
		return (module.holder && module.holder.cell && module.holder.cell.checked_use(charge_amt))

/obj/item/shockpaddles/rig/set_cooldown(var/delay)
	..()
	if(istype(loc, /obj/item/rig_module/device/defib))
		var/obj/item/rig_module/device/defib/module = loc
		module.next_use = world.time + delay
/*
	Shockpaddles that are linked to a base unit
*/
/obj/item/shockpaddles/linked
	var/obj/item/defibrillator/base_unit

/obj/item/shockpaddles/linked/Initialize(mapload, obj/item/defibrillator/defib)
	. = ..(mapload)
	base_unit = defib

/obj/item/shockpaddles/linked/Destroy()
	if(base_unit)
		//ensure the base unit's icon updates
		if(base_unit.paddles == src)
			base_unit.paddles = null
			base_unit.update_icon()
		base_unit = null
	return ..()

/obj/item/shockpaddles/linked/dropped(mob/user)
	..() //update twohanding
	if(base_unit)
		base_unit.reattach_paddles(user) //paddles attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/shockpaddles/linked/check_charge(var/charge_amt)
	return (base_unit.bcell && base_unit.bcell.check_charge(charge_amt))

/obj/item/shockpaddles/linked/checked_use(var/charge_amt)
	return (base_unit.bcell && base_unit.bcell.checked_use(charge_amt))

/obj/item/shockpaddles/linked/make_announcement(var/message, var/msg_class)
	base_unit.audible_message("<b>\The [base_unit]</b> [message]", "\The [base_unit] vibrates slightly.")

/*
	Standalone Shockpaddles
*/

/obj/item/shockpaddles/standalone
	desc = "A pair of shock paddles powered by an experimental miniaturized reactor" //Inspired by the advanced e-gun
	var/fail_counter = 0

/obj/item/shockpaddles/standalone/Destroy()
	. = ..()
	if(fail_counter)
		STOP_PROCESSING(SSobj, src)

/obj/item/shockpaddles/standalone/check_charge(var/charge_amt)
	return 1

/obj/item/shockpaddles/standalone/checked_use(var/charge_amt)
	SSradiation.radiate(src, charge_amt/12) //just a little bit of radiation. It's the price you pay for being powered by magic I guess
	return 1

/obj/item/shockpaddles/standalone/Process()
	if(fail_counter > 0)
		SSradiation.radiate(src, (fail_counter * 2))
		fail_counter--
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/shockpaddles/standalone/emp_act(severity)
	..()
	var/new_fail = 0
	switch(severity)
		if(1)
			new_fail = max(fail_counter, 20)
			visible_message("\The [src]'s reactor overloads!")
		if(2)
			new_fail = max(fail_counter, 8)
			if(ismob(loc))
				to_chat(loc, "<span class='warning'>\The [src] feel pleasantly warm.</span>")

	if(new_fail && !fail_counter)
		START_PROCESSING(SSobj, src)
	fail_counter = new_fail

/obj/item/shockpaddles/standalone/traitor
	name = "defibrillator paddles"
	desc = "A pair of unusual looking paddles powered by an experimental miniaturized reactor. It possesses both the ability to penetrate armor and to deliver powerful shocks."
	combat = 1
	safety = 0
	chargetime = (1 SECONDS)
	burn_damage_amt = 15
