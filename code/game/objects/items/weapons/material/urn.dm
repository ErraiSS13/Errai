/obj/item/urn
	name = "urn"
	desc = "A vase used to store the ashes of the deceased."
	icon = 'icons/obj/items/urn.dmi'
	icon_state = "urn"
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/organic/wood/oak

/obj/item/urn/afterattack(var/obj/A, var/mob/user, var/proximity)
	if(!istype(A, /obj/effect/decal/cleanable/ash))
		return ..()
	else if(proximity)
		if(contents.len)
			to_chat(user, "<span class='warning'>\The [src] is already full!</span>")
			return
		user.visible_message("\The [user] scoops \the [A] into \the [src], securing the lid.", "You scoop \the [A] into \the [src], securing the lid.")
		A.forceMove(src)

/obj/item/urn/attack_self(mob/user)
	if(!contents.len)
		to_chat(user, "<span class='warning'>\The [src] is empty!</span>")
		return
	else
		for(var/obj/effect/decal/cleanable/ash/A in contents)
			A.dropInto(loc)
			user.visible_message("\The [user] pours \the [A] out from \the [src].", "You pour \the [A] out from \the [src].")

/obj/item/urn/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(contents.len)
		. += "\The [src] is full."
