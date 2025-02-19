// sprite stolen from vgstation

/obj/item/bell
	name = "bell"
	desc = "A bell to ring to get people's attention. Don't break it."
	icon = 'icons/obj/objects.dmi'
	icon_state = "bell"
	hitsound = 'sound/items/oneding.ogg'
	material = /decl/material/solid/metal/aluminium
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

/obj/item/bell/attack_hand(mob/user)
	if(user.check_intent(I_FLAG_GRAB))
		return ..()

	if(user.check_intent(I_FLAG_HARM))
		user.visible_message("<span class='warning'>\The [user] hammers \the [src]!</span>")
		playsound(user.loc, 'sound/items/manydings.ogg', 60)
	else
		user.visible_message("<span class='notice'>\The [user] rings \the [src].</span>")
		playsound(user.loc, 'sound/items/oneding.ogg', 20)
	flick("bell_dingeth", src)
	return TRUE

/obj/item/bell/apply_hit_effect()
	. = ..()
	shatter()