/mob/living/human/can_be_grabbed(var/mob/grabber, var/target_zone, var/defer_hand = FALSE)
	. = ..()
	if(.)
		var/obj/item/organ/external/organ = GET_EXTERNAL_ORGAN(src, check_zone(target_zone, src))
		if(!istype(organ))
			to_chat(grabber, SPAN_WARNING("\The [src] is missing that body part!"))
			return FALSE
		if(grabber == src)
			var/using_slot = defer_hand ? get_empty_hand_slot() : get_active_held_item_slot()
			if(!using_slot)
				to_chat(src, SPAN_WARNING("You cannot grab yourself without a usable hand!"))
				return FALSE
			var/list/bad_parts = list(organ.organ_tag) | organ.parent_organ
			for(var/obj/item/organ/external/child in organ.children)
				bad_parts |= child.organ_tag
			if(using_slot in bad_parts)
				to_chat(src, SPAN_WARNING("You can't grab your own [organ.name] with itself!"))
				return FALSE
		if(pull_damage())
			to_chat(grabber, SPAN_DANGER("Pulling \the [src] in their current condition would probably be a bad idea."))
		var/obj/item/clothing/C = get_covering_equipped_item_by_zone(target_zone)
		if(istype(C))
			C.leave_evidence(grabber)

/mob/living/human/make_grab(atom/movable/target, grab_tag = /decl/grab/simple, defer_hand = FALSE, force_grab_tag = FALSE)
	. = ..()
	if(.)
		remove_mob_modifier(/decl/mob_modifier/cloaked, source = species)
