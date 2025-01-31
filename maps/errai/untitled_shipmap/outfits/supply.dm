/decl/outfit/job/shipmap/supply
	abstract_type = /decl/outfit/job/shipmap/supply
	id_type = /obj/item/card/id/cargo
	pda_type = /obj/item/modular_computer/pda/cargo
	head = /obj/item/clothing/head/soft
	gloves = /obj/item/clothing/gloves/thick
	l_ear = /obj/item/radio/headset/headset_cargo


/decl/outfit/job/shipmap/supply/quartermaster
	name = "Shipmap - Job - Quartermaster"
	id_type = /obj/item/card/id/cargo/head
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/jumpsuit/cargo
	shoes = /obj/item/clothing/shoes/color/brown
	hands = list(/obj/item/clipboard)


/decl/outfit/job/shipmap/supply/supply_tech
	name = "Shipmap - Job - Supply Tech"
	uniform = /obj/item/clothing/jumpsuit/cargotech
	suit = /obj/item/clothing/suit/hazardvest


/decl/outfit/job/shipmap/supply/miner
	name = "Shipmap - Job - Miner"
	uniform = /obj/item/clothing/jumpsuit/miner
	pda_type = /obj/item/modular_computer/pda/science // wut?
	shoes = /obj/item/clothing/shoes/workboots
	backpack_contents = list(/obj/item/crowbar = 1)
	outfit_flags = OUTFIT_HAS_BACKPACK | OUTFIT_EXTENDED_SURVIVAL | OUTFIT_HAS_VITALS_SENSOR

/decl/outfit/job/shipmap/supply/miner/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_ENGINEERING


/decl/outfit/job/shipmap/supply/shuttle_pilot
	name = "Shipmap - Job - Shuttle Pilot"
	uniform = /obj/item/clothing/jumpsuit/pilot/nanotrasen
	suit = /obj/item/clothing/suit/jacket/bomber
	shoes = /obj/item/clothing/shoes/workboots
	glasses = /obj/item/clothing/glasses/sunglasses // Aviators someday.


/obj/item/card/id/cargo
	name = "identification card"
	desc = "A card issued to cargo staff."
	detail_color = COLOR_BROWN

/obj/item/card/id/cargo/head
	name = "identification card"
	desc = "A card which represents service and planning."
	extra_details = list("goldstripe")

