/datum/extension/holster
	base_type = /datum/extension/holster
	var/atom/atom_holder
	var/datum/storage/storage
	var/sound_in = 'sound/effects/holster/holsterin.ogg'
	var/sound_out = 'sound/effects/holster/holsterout.ogg'
	var/list/can_holster = null
	var/obj/item/holstered = null

/datum/extension/holster/New(holder, storage, sound_in, sound_out, can_holster)
	..()
	atom_holder = holder
	src.storage = storage
	src.sound_in = sound_in || src.sound_in
	src.sound_out = sound_out || src.sound_out
	src.can_holster = can_holster

	atom_holder.verbs += /atom/proc/holster_verb

/datum/extension/holster/Destroy()
	. = ..()
	atom_holder.verbs -= /atom/proc/holster_verb

/datum/extension/holster/proc/can_holster(var/obj/item/I)
	if(can_holster)
		if(is_type_in_list(I,can_holster))
			return 1
		return 0
	if(I.slot_flags & SLOT_HOLSTER)
		return 1
	return 0

/datum/extension/holster/proc/holster(var/obj/item/I, var/mob/living/user)
	if(!storage)
		return 1
	if(!holstered && storage.storage_slots != null && length(storage.get_contents()) >= storage.storage_slots - 1)
		if(!can_holster(I))
			to_chat(user, "<span class='notice'>\The [I] won't fit in \the [atom_holder]'s holster!.</span>")
			return 1
	if(can_holster(I))
		if(holstered && istype(user))
			to_chat(user, "<span class='warning'>There is already \a [holstered] holstered here!</span>")
			return 1
		if(sound_in)
			playsound(get_turf(atom_holder), sound_in, 50)
		if(istype(user))
			user.stop_aiming(no_message=1)
		holstered = I
		storage.handle_item_insertion(user, holstered, 1)
		holstered.add_fingerprint(user)
		holstered.add_fibers(atom_holder)
		if(isobj(storage?.holder))
			var/obj/obj_holder = storage.holder
			obj_holder.w_class = max(obj_holder.w_class, holstered.w_class)
		user.visible_message("<span class='notice'>\The [user] holsters \the [holstered].</span>", "<span class='notice'>You holster \the [holstered].</span>")
		atom_holder.SetName("occupied [initial(atom_holder.name)]")
		atom_holder.update_icon()
		events_repository.register(/decl/observ/moved, holstered, src, PROC_REF(check_holster))
		events_repository.register(/decl/observ/destroyed, holstered, src, PROC_REF(clear_holster))
		return 1
	return 0

/datum/extension/holster/proc/clear_holster()
	events_repository.unregister(/decl/observ/moved, holstered, src, PROC_REF(check_holster))
	events_repository.unregister(/decl/observ/destroyed, holstered, src, PROC_REF(clear_holster))
	holstered = null
	atom_holder.SetName(initial(atom_holder.name))

/datum/extension/holster/proc/unholster(mob/user, var/avoid_intent = FALSE)
	if(!holstered)
		return 0
	if(!user.get_empty_hand_slot())
		to_chat(user, SPAN_WARNING("You need an empty hand to draw \the [holstered]!"))
		return 1
	var/using_intent_preference = user.client ? user.client.get_preference_value(/datum/client_preference/holster_on_intent) == PREF_YES : FALSE
	if(avoid_intent || (using_intent_preference && !user.check_intent(I_FLAG_HELP)))
		var/sound_vol = 25
		if(user.check_intent(I_FLAG_HARM))
			sound_vol = 50
			if(istype(holstered, /obj/item/gun))
				var/obj/item/gun/G = holstered
				G.check_accidents(user)
				if(G.safety() && !user.skill_fail_prob(SKILL_WEAPONS, 100, SKILL_EXPERT, 0.5)) //Experienced shooter will disable safety before shooting.
					G.toggle_safety(user)
			user.visible_message(
				"<span class='danger'>\The [user] draws \the [holstered], ready to go!</span>",
				"<span class='warning'>You draw \the [holstered], ready to go!</span>"
				)
		else
			user.visible_message(
				"<span class='notice'>\The [user] draws \the [holstered], pointing it at the ground.</span>",
				"<span class='notice'>You draw \the [holstered], pointing it at the ground.</span>"
				)
		if(sound_out)
			playsound(get_turf(atom_holder), sound_out, sound_vol)
		holstered.add_fingerprint(user)
		holstered.queue_icon_update()
		user.put_in_hands(holstered)
		holstered = null
		if(isobj(storage?.holder))
			var/obj/obj_holder = storage.holder
			obj_holder.w_class = initial(obj_holder.w_class)
		atom_holder.update_icon()
		return 1
	return 0

/datum/extension/holster/proc/examine_holster(mob/user)
	if (holstered)
		to_chat(user, "\A [holstered] is holstered here.")
	else
		to_chat(user, "It is empty.")

/datum/extension/holster/proc/check_holster()
	if(holstered.loc != storage.holder)
		clear_holster()

/atom/proc/holster_verb(var/holster_name in get_holsters())
	set name = "Holster"
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	var/datum/extension/holster/holster = get_holsters()[holster_name]
	if(!holster)
		return

	if(!holster.holstered)
		var/obj/item/holding = usr.get_active_held_item()
		if(!istype(holding, /obj/item))
			to_chat(usr, "<span class='warning'>You're not holding anything to holster.</span>")
			return
		holster.holster(holding, usr)
	else
		holster.unholster(usr, 1)

/atom/proc/get_holsters()
	. = list()
	if(has_extension(src, /datum/extension/holster))
		.[name] = get_extension(src, /datum/extension/holster)

/obj/item/clothing/get_holsters()
	. = ..()
	var/holster_accessories_by_name = list()
	for(var/obj/accessory in accessories)
		if(has_extension(accessory, /datum/extension/holster))
			group_by(holster_accessories_by_name , accessory.name, accessory)

	for(var/accessory_name in holster_accessories_by_name)
		var/list/holster_accessories = holster_accessories_by_name[accessory_name]
		if(holster_accessories.len == 1)
			.[accessory_name] = get_extension(holster_accessories[1], /datum/extension/holster)
		else
			for(var/i = 1 to holster_accessories.len)
				var/holster_name = "[accessory_name] [i]"
				.[holster_name] = get_extension(holster_accessories[i], /datum/extension/holster)

// Basic unholster for an item at the top level.
/decl/interaction_handler/unholster
	name = "Unholster"

/decl/interaction_handler/unholster/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..() && !prop
	if(.)
		var/datum/extension/holster/holster = get_extension(target, /datum/extension/holster)
		return !!holster?.holstered

/decl/interaction_handler/unholster/invoked(atom/target, mob/user, obj/item/prop)
	var/datum/extension/holster/holster = get_extension(target, /datum/extension/holster)
	return holster?.unholster(user, avoid_intent = TRUE)

// Interaction procs for getting this interaction for basic items.
/obj/item/get_quick_interaction_handler(mob/user)
	if(!(. = ..()))
		var/datum/extension/holster/holster = get_extension(src, /datum/extension/holster)
		if(holster?.holstered)
			return GET_DECL(/decl/interaction_handler/unholster)

// More complex version of the above that iterates clothing accessories.
/decl/interaction_handler/unholster_accessory
	name = "Unholster From Accessory"
	expected_target_type = /obj/item/clothing

/decl/interaction_handler/unholster_accessory/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..() && !prop
	if(.)
		var/obj/item/clothing/clothes = target
		for(var/obj/item/thing in clothes.accessories)
			var/datum/extension/holster/holster = get_extension(thing, /datum/extension/holster)
			if(holster?.holstered)
				return TRUE
		return FALSE

/decl/interaction_handler/unholster_accessory/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/item/clothing/clothes = target
	for(var/obj/item/thing in clothes.accessories)
		var/datum/extension/holster/holster = get_extension(thing, /datum/extension/holster)
		if(holster?.unholster(user, avoid_intent = TRUE))
			return TRUE
	return FALSE

// Interaction procs for getting this interaction for clothing accessories.
/obj/item/clothing/get_alt_interactions(mob/user)
	. = ..()
	for(var/obj/item/thing in accessories)
		var/datum/extension/holster/holster = get_extension(thing, /datum/extension/holster)
		if(holster?.holstered)
			LAZYADD(., GET_DECL(/decl/interaction_handler/unholster_accessory))

/obj/item/clothing/get_quick_interaction_handler(mob/user)
	if(!(. = ..()))
		for(var/obj/item/thing in accessories)
			var/datum/extension/holster/holster = get_extension(thing, /datum/extension/holster)
			if(holster?.holstered)
				return GET_DECL(/decl/interaction_handler/unholster_accessory)
