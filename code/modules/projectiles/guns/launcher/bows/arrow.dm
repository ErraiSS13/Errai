/obj/item/stack/material/bow_ammo
	abstract_type = /obj/item/stack/material/bow_ammo
	icon_state = ICON_STATE_WORLD
	base_state = ICON_STATE_WORLD
	plural_icon_state = ICON_STATE_WORLD + "-mult"
	max_icon_state = ICON_STATE_WORLD + "-max"
	w_class = ITEM_SIZE_NORMAL
	sharp = TRUE
	edge = FALSE
	lock_picking_level = 3
	material = /decl/material/solid/organic/wood/oak
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	matter_multiplier = 0.2
	is_spawnable_type = TRUE
	_base_attack_force = 7 // Legolas mode...
	_thrown_force_multiplier = 1.15
	var/superheated = FALSE

/obj/item/stack/material/bow_ammo/on_update_icon()
	. = ..()
	if(superheated)
		add_overlay(overlay_image(icon, "[icon_state]-superheated", COLOR_WHITE, RESET_COLOR))

/obj/item/stack/material/bow_ammo/update_attack_force()
	. = ..()
	if(superheated)
		_cached_attack_force *= 2

/obj/item/stack/material/bow_ammo/proc/make_superheated()
	if(!superheated)
		superheated = TRUE
		update_attack_force()
		update_icon()

/// Helper for metal rods falling apart.
/obj/item/stack/material/bow_ammo/proc/removed_from_bow(mob/user)
	if(!superheated)
		return
	// The rod has been superheated - we don't want it to be useable when removed from the bow.
	to_chat(user, SPAN_DANGER("\The [src] shatters into a scattering of overstressed metal shards as it leaves the crossbow."))
	var/obj/item/shard/shrapnel/S = new()
	S.dropInto(loc)
	qdel(src)

/obj/item/stack/material/bow_ammo/arrow
	name = "arrow"
	singular_name = "arrow"
	plural_name = "arrows"
	icon = 'icons/obj/items/weapon/arrow.dmi'
	desc = "A long, sharp stick, fletched at one end."
	var/decl/material/fletching_material

/obj/item/stack/material/bow_ammo/arrow/iron
	material = /decl/material/solid/metal/iron

/obj/item/stack/material/bow_ammo/arrow/iron/fifteen
	amount = 15

/obj/item/stack/material/bow_ammo/arrow/fifteen
	amount = 15

/obj/item/stack/material/bow_ammo/arrow/Initialize()
	if(ispath(fletching_material))
		fletching_material = GET_DECL(fletching_material)
	. = ..()
	update_icon()

/obj/item/stack/material/bow_ammo/arrow/fletched
	fletching_material = /decl/material/solid/organic/skin/feathers

/obj/item/stack/material/bow_ammo/arrow/on_update_icon()
	. = ..()
	if(fletching_material)
		add_overlay(overlay_image(icon, "[icon_state]-fletching", fletching_material.color, RESET_COLOR))

/obj/item/stack/material/bow_ammo/bolt
	name = "bolt"
	singular_name = "bolt"
	plural_name = "bolts"
	icon = 'icons/obj/items/weapon/arrow_bolt.dmi'
	desc = "It's got a tip for you - get the point?"
	_thrown_force_multiplier = 1.2

/obj/item/stack/material/bow_ammo/spike
	name = "alloy spike"
	singular_name = "alloy spike"
	plural_name = "alloy spikes"
	desc = "It's about a foot of weird silver metal with a wicked point."
	material = /decl/material/solid/metal/alienalloy
	_thrown_force_multiplier = 1.25

/obj/item/stack/material/bow_ammo/rod
	name = "rod"
	singular_name = "rod"
	plural_name = "rods"
	desc = "Don't cry for me, Orithena."
	icon = 'icons/obj/items/weapon/arrow_rod.dmi'
	material = /decl/material/solid/metal/steel
	_thrown_force_multiplier = 1.2
