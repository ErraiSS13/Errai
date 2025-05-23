/obj/item/clothing/head/fated
	name = "strange key"
	desc = "A glowing key, uncomfortably hot to the touch."
	icon = 'icons/clothing/head/fated_key.dmi'
	body_parts_covered = 0
	armor = list(ARMOR_MELEE = 55, ARMOR_BULLET = 55, ARMOR_LASER = 55, ARMOR_ENERGY = 55, ARMOR_BOMB = 55, ARMOR_BIO = 100, ARMOR_RAD = 100)
	flags_inv = 0
	accessory_slot = null // cannot be equipped on top of helmets because this isn't really even an actual clothing item

/obj/item/clothing/head/fated/equipped(mob/living/user, slot)
	. = ..()
	if(istype(user) && canremove && loc == user && slot == slot_head_str)
		canremove = FALSE
		to_chat(user, SPAN_DANGER("<font size=3>\The [src] shatters your mind as it sears through [user.isSynthetic() ? "metal and circuitry" : "flesh and bone"], embedding itself into your skull!</font>"))
		SET_STATUS_MAX(user, STAT_PARA, 5)
		addtimer(CALLBACK(src, PROC_REF(activate_role)), 5 SECONDS)
	else
		canremove = TRUE
		name = initial(name)
		desc = initial(desc)
		body_parts_covered = initial(body_parts_covered)
		item_flags &= ~ITEM_FLAG_AIRTIGHT

/obj/item/clothing/head/fated/proc/activate_role()
	var/mob/living/starbearer = loc
	if(istype(starbearer) && !canremove)
		name = "halo of starfire"
		desc = "Beware the fire of the star-bearers; it is too terrible to touch."
		starbearer.add_mob_modifier(/decl/mob_modifier/regeneration, source = src)
		body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS|SLOT_HEAD|SLOT_FACE|SLOT_EYES|SLOT_HANDS|SLOT_FEET|SLOT_TAIL
		item_flags |= ITEM_FLAG_AIRTIGHT

/obj/item/clothing/head/fated/verb/perform_division()

	set name = "Divide"
	set desc = "The sanctioned action is to cut."
	set category = "Abilities"
	set src in usr

	var/mob/living/user = usr
	if(!istype(user))
		return

	if(user.incapacitated())
		to_chat(user, SPAN_WARNING("You are in no fit state to perform division."))
		return

	if(user.is_on_special_ability_cooldown())
		to_chat(user, SPAN_WARNING("You have not yet regained enough focus to perform division."))
		return

	var/atom/blade
	for(var/obj/item/held in shuffle(user.get_held_items()))
		if(held.has_edge())
			blade = held
			break
	if(!blade)
		to_chat(user, SPAN_WARNING("You have no blade with which to divide."))
		return

	var/decl/pronouns/pronouns = user.get_pronouns()
	user.visible_message(SPAN_DANGER("\The [user] raises [pronouns.his] [blade.name] to shoulder level!"))
	playsound(user.loc, 'sound/effects/sanctionedaction_prep.ogg', 100, 1)

	if(do_after(user, 1 SECOND, progress = 0, same_direction = 1))
		user.visible_message(SPAN_DANGER("\The [user] swings [pronouns.his] [blade.name] in a blazing arc!"))
		playsound(user.loc, 'sound/effects/sanctionedaction_cut.ogg', 100, 1)
		var/obj/item/projectile/sanctionedaction/cut = new(user.loc)
		cut.launch(get_edge_target_turf(get_turf(user.loc), user.dir), user.get_target_zone())
		user.set_special_ability_cooldown(10 SECONDS)

/obj/item/projectile/sanctionedaction
	name = "rending slash"
	desc = "O shining blade, divider of infinities."
	icon = 'icons/effects/sanctionedaction.dmi'
	icon_state = "cut"
	penetrating = 100

/obj/item/projectile/sanctionedaction/check_penetrate(var/atom/A)
	. = TRUE
	if(ishuman(A))
		var/mob/living/human/H = A
		var/list/external_organs = H.get_external_organs()
		if(LAZYLEN(external_organs))
			var/obj/item/organ/external/E = pick(external_organs)
			E.dismember()

/obj/item/projectile/sanctionedaction/before_move()
	. = ..()
	var/turf/T = get_turf(src)
	if(T)
		T.explosion_act(2)
		var/firecount = rand(5,8)
		while(firecount)
			firecount--
			new /obj/effect/white_fire(get_turf(src))

/obj/effect/white_fire
	name = "white fire"
	icon = 'icons/effects/sanctionedaction.dmi'
	alpha = 0
	layer = PROJECTILE_LAYER

/obj/effect/white_fire/Initialize()
	. = ..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	icon_state = pick(list("flame1","flame2"))
	fade_out()

/obj/effect/white_fire/proc/fade_out()
	set waitfor = FALSE
	animate(src, alpha = 255, time = 3)
	sleep(13)
	animate(src, alpha = 0, time = 40)
	if(!QDELING(src))
		QDEL_IN(src, 4 SECONDS)
