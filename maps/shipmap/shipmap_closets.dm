/obj/structure/closet/secure_closet/wall
	anchored = TRUE
	density = FALSE
	wall_mounted = 1
	storage_types = CLOSET_STORAGE_ITEMS
	setup = 0
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":-32}, "WEST":{"x":32}}'

/obj/structure/closet/secure_closet/wall/medical_bloodbags
	name = "Blood Locker"
	desc = "It's a wall-mounted storage unit for holding emergency blood bags."
	closet_appearance = /decl/closet_appearance/wall/medical/blood
	req_access = list(access_medical_equip) // To keep out vampires.

/obj/structure/closet/secure_closet/wall/medical_bloodbags/WillContain()
	return list(
		/obj/item/chems/ivbag/blood/ominus = 3
	)

/decl/closet_appearance/wall/medical/blood
	extra_decals = list(
		"stripe_outer" = COLOR_RED,
		"stripe_inner" = COLOR_OFF_WHITE,
		"cross" = COLOR_BLUE_GRAY
	)



/*
/obj/structure/closet/secure_closet/medical1
	name = "medical equipment closet"
	desc = "Filled with medical junk."
	closet_appearance = /decl/closet_appearance/secure_closet/medical
	req_access = list(access_medical_equip)

/obj/structure/closet/secure_closet/medical1/WillContain()
	return list(
		/obj/item/box/autoinjectors,
		/obj/item/box/syringes,
		/obj/item/chems/dropper = 2,
		/obj/item/chems/glass/beaker = 2,
		/obj/item/chems/glass/bottle/stabilizer = 2,
		/obj/item/chems/glass/bottle/antitoxin = 2,
		/obj/random/firstaid,
		/obj/item/box/masks,
		/obj/item/box/gloves
	)

/obj/structure/closet/secure_closet/medical3
	name = "medical doctor's locker"
	req_access = list(access_medical_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/medical/alt

/obj/structure/closet/secure_closet/medical3/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/backpack/medic, /obj/item/backpack/satchel/med)),
		new/datum/atom_creator/simple(/obj/item/backpack/dufflebag/med, 50),
		/obj/item/clothing/head/nursehat,
		/obj/item/clothing/jumpsuit/medical,
		/obj/item/clothing/dress/nurse = 2,
		/obj/item/clothing/pants/slacks/white/orderly,
		/obj/item/clothing/shirt/button/orderly,
		/obj/item/clothing/neck/tie/long/red,
		/obj/item/clothing/suit/toggle/labcoat,
		/obj/item/clothing/suit/jacket/first_responder,
		/obj/item/clothing/shoes/color/white,
		/obj/item/radio/headset/headset_med,
		/obj/item/stack/tape_roll/barricade_tape/medical,
		/obj/item/belt/medical/emt,
		RANDOM_SCRUBS,
		RANDOM_SCRUBS
	)

/obj/structure/closet/secure_closet/paramedic
	name = "paramedic locker"
	desc = "Supplies for a first responder."
	closet_appearance = /decl/closet_appearance/secure_closet/medical
	req_access = list(access_medical_equip)

/obj/structure/closet/secure_closet/paramedic/WillContain()
	return list(
		/obj/item/box/autoinjectors,
		/obj/item/box/syringes,
		/obj/item/chems/glass/bottle/stabilizer,
		/obj/item/chems/glass/bottle/antitoxin,
		/obj/item/belt/medical/emt,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/suit/jacket/first_responder,
		/obj/item/clothing/suit/toggle/labcoat,
		/obj/item/radio/headset/headset_med,
		/obj/item/flashlight,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/scanner/health,
		/obj/item/scanner/breath,
		/obj/item/radio/off,
		/obj/random/medical,
		/obj/item/crowbar,
		/obj/item/chems/spray/extinguisher/mini,
		/obj/item/box/freezer,
		/obj/item/clothing/webbing/vest
	)
*/