/mob/proc/get_damage(damage_type)
	switch(damage_type)
		if(BRUTE)
			return getBruteLoss()
		if(BURN)
			return getFireLoss()
		if(TOX)
			return getToxLoss()
		if(CLONE)
			return getCloneLoss()
		if(OXY)
			return getOxyLoss()
		if(IRRADIATE)
			return radiation
		if(PAIN)
			return getHalLoss()
		if(BRAIN)
			return getBrainLoss()
		//if(ELECTROCUTE)
	return 0

/mob/proc/set_damage(damage_type, amount, do_update_health)
	switch(damage_type)
		if(BRUTE)
			return setBruteLoss(amount, do_update_health)
		if(BURN)
			return setFireLoss(amount, do_update_health)
		if(TOX)
			return setToxLoss(amount, do_update_health)
		if(CLONE)
			return setCloneLoss(amount, do_update_health)
		if(OXY)
			return setOxyLoss(amount, do_update_health)
		if(PAIN)
			return setHalLoss(amount, do_update_health)
		if(BRAIN)
			return setBrainLoss(amount, do_update_health)
		//if(IRRADIATE)
		//if(ELECTROCUTE)
	return 0

/mob/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	switch(damage_type)
		if(BRUTE)
			return adjustBruteLoss(damage, do_update_health)
		if(BURN)
			return adjustFireLoss(damage, do_update_health)
		if(TOX)
			return adjustToxLoss(damage, do_update_health)
		if(CLONE)
			return adjustCloneLoss(damage, do_update_health)
		if(OXY)
			return adjustOxyLoss(damage, do_update_health)
		if(PAIN)
			return adjustHalLoss(damage, do_update_health)
		if(IRRADIATE)
			return apply_radiation(damage)
		if(BRAIN)
			return adjustBrainLoss(damage, do_update_health)
		//if(ELECTROCUTE)
	return 0

/mob/proc/heal_damage(damage_type, amount, do_update_health)
	return take_damage(-(amount), damage_type, do_update_health = do_update_health)

/// Returns TRUE if updates should happen, FALSE if not.
/mob/proc/update_health()
	SHOULD_CALL_PARENT(TRUE)
	return !(status_flags & GODMODE)

// Damage stubs to allow for calling on /mob (usr etc)
/mob/proc/getBruteLoss()
	return 0
/mob/proc/getOxyLoss()
	return 0
/mob/proc/getToxLoss()
	return 0
/mob/proc/getFireLoss()
	return 0
/mob/proc/getHalLoss()
	return 0
/mob/proc/getCloneLoss()
	return 0

/mob/proc/setBruteLoss(var/amount)
	return
/mob/proc/setOxyLoss(var/amount)
	return
/mob/proc/setToxLoss(var/amount)
	return
/mob/proc/setFireLoss(var/amount)
	return
/mob/proc/setHalLoss(var/amount)
	return
/mob/proc/setBrainLoss(var/amount)
	return
/mob/proc/setCloneLoss(var/amount)
	return

/mob/proc/adjustToxLoss(var/amount, var/do_update_health = TRUE)
	return
/mob/proc/adjustFireLoss(var/amount, var/do_update_health = TRUE)
	return
/mob/proc/adjustHalLoss(var/amount, var/do_update_health = TRUE)
	return

/mob/proc/adjustBruteLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(do_update_health)
		update_health()

/mob/proc/adjustOxyLoss(var/damage, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(do_update_health)
		update_health()

/mob/proc/adjustBrainLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(do_update_health)
		update_health()

/mob/proc/adjustCloneLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(do_update_health)
		update_health()

// Calculates the Siemen's coefficient for a given area of the body.
// 1 is 100% vulnerability, 0 is immune.
/mob/proc/get_siemens_coefficient_for_coverage(coverage_flags = SLOT_HANDS)
	var/decl/species/my_species = get_species()
	. = my_species ? my_species.shock_vulnerability : 1
	if(. <= 0)
		return 0
	if(coverage_flags)
		for(var/obj/item/clothing/clothes in get_equipped_items(include_carried = FALSE))
			if(clothes.body_parts_covered & coverage_flags)
				if(clothes.siemens_coefficient <= 0)
					return 0
				. *= clothes.siemens_coefficient
				if(. <= 0)
					return 0
	. = max(round(., 0.1), 0)

//this proc returns the Siemens coefficient of electrical resistivity for a particular external organ.
/mob/proc/get_siemens_coefficient_organ(var/obj/item/organ/external/def_zone)
	return (istype(def_zone) && def_zone.body_part) ? get_siemens_coefficient_for_coverage(def_zone.body_part) : 1

/mob/proc/apply_radiation(var/damage = 0)
	return

