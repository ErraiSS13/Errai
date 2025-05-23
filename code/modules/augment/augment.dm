/obj/item/organ/internal/augment
	name = "embedded augment"
	desc = "An embedded augment."
	icon = 'icons/obj/augment.dmi'
	w_class = ITEM_SIZE_TINY // Need to be tiny to fit inside limbs.
	//By default these fit on both flesh and robotic organs and are robotic
	organ_properties = ORGAN_PROP_PROSTHETIC
	default_action_type = /datum/action/item_action/organ/augment
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"materials":1,"magnets":2,"engineering":2,"biotech":1}'
	w_class = ITEM_SIZE_TINY

	var/descriptor = ""
	var/known = TRUE
	var/augment_flags = AUGMENTATION_MECHANIC | AUGMENTATION_ORGANIC
	var/list/allowed_organs = list(BP_AUGMENT_R_ARM, BP_AUGMENT_L_ARM)

/obj/item/organ/internal/augment/Initialize()
	. = ..()
	organ_tag = pick(allowed_organs)
	set_bodytype(/decl/bodytype/prosthetic/augment)
	update_parent_organ()
	reagents?.clear_reagents() // Removing meat from the reagents list.

/obj/item/organ/internal/augment/attackby(obj/item/used_item, mob/user)
	if(IS_SCREWDRIVER(used_item) && allowed_organs.len > 1)
		//Here we can adjust location for implants that allow multiple slots
		organ_tag = input(user, "Adjust installation parameters") as null|anything in allowed_organs
		update_parent_organ()
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		return TRUE
	return ..()

/obj/item/organ/internal/augment/do_install(var/mob/living/human/target, var/obj/item/organ/external/affected, var/in_place = FALSE, var/update_icon = TRUE, var/detached = FALSE)
	. = ..()
	parent_organ = affected.organ_tag
	update_parent_organ()

/obj/item/organ/internal/augment/proc/update_parent_organ()
	//This tries to match a parent organ to an augment slot
	//This is intended to match the possible positions to a parent organ

	if(organ_tag == BP_AUGMENT_L_LEG)
		parent_organ = BP_L_LEG
		descriptor = "left leg."
	else if(organ_tag == BP_AUGMENT_R_LEG)
		parent_organ = BP_R_LEG
		descriptor = "right leg."
	else if(organ_tag == BP_AUGMENT_L_HAND)
		parent_organ = BP_L_HAND
		descriptor = "left hand."
	else if(organ_tag == BP_AUGMENT_R_HAND)
		parent_organ = BP_R_HAND
		descriptor = "right hand."
	else if(organ_tag == BP_AUGMENT_L_ARM)
		parent_organ = BP_L_ARM
		descriptor = "left arm."
	else if(organ_tag == BP_AUGMENT_R_ARM)
		parent_organ = BP_R_ARM
		descriptor = "right arm."
	else if(organ_tag == BP_AUGMENT_HEAD)
		parent_organ = BP_HEAD
		descriptor = "head."
	else if(organ_tag == BP_AUGMENT_CHEST_ACTIVE || organ_tag == BP_AUGMENT_CHEST_ARMOUR)
		parent_organ = BP_CHEST
		descriptor = "chest."

/obj/item/organ/internal/augment/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "It is configured to be attached to the [descriptor]."
		if(augment_flags & AUGMENTATION_MECHANIC && augment_flags & AUGMENTATION_ORGANIC)
			. += "It can interface with both prosthetic and fleshy organs."
		else
			if(augment_flags & AUGMENTATION_MECHANIC)
				. += "It can interface with prosthetic organs."
			else if(augment_flags & AUGMENTATION_ORGANIC)
				. += "It can interface with fleshy organs."
