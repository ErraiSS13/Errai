/obj/item/organ/internal/appendix
	name = "appendix"
	icon_state = "appendix"
	parent_organ = BP_GROIN
	organ_tag = BP_APPENDIX
	var/inflamed = 0

/obj/item/organ/internal/appendix/on_update_icon()
	..()
	if(inflamed)
		icon_state = "appendixinflamed"
		SetName("inflamed appendix")

/obj/item/organ/internal/appendix/Process()
	..()
	if(inflamed && owner)
		inflamed++
		if(prob(5))
			if(owner.can_feel_pain())
				owner.custom_pain("You feel a stinging pain in your abdomen!")
				if(owner.can_feel_pain())
					owner.visible_message("<B>\The [owner]</B> winces slightly.")
		if(inflamed > 200)
			if(prob(3))
				take_damage(0.1)
				if(owner.can_feel_pain())
					owner.visible_message("<B>\The [owner]</B> winces painfully.")
				owner.take_damage(1, TOX)
		if(inflamed > 400)
			if(prob(1))
				germ_level += rand(2,6)
				owner.vomit()
		if(inflamed > 600)
			if(prob(1))
				if(owner.can_feel_pain())
					owner.custom_pain("You feel a stinging pain in your abdomen!")
					SET_STATUS_MAX(owner, STAT_WEAK, 10)

				var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(owner, parent_organ)
				E.sever_artery()
				E.germ_level = max(INFECTION_LEVEL_TWO, E.germ_level)
				owner.take_damage(25, TOX)
				qdel(src)
