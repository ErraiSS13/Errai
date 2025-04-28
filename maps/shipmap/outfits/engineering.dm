/decl/outfit/job/shipmap/engineering
	abstract_type = /decl/outfit/job/shipmap/engineering
	outfit_flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL|OUTFIT_HAS_VITALS_SENSOR
	gloves = /obj/item/clothing/gloves/thick
	belt = /obj/item/belt/utility/full
	l_ear = /obj/item/radio/headset/headset_eng
	shoes = /obj/item/clothing/shoes/workboots
	r_pocket = /obj/item/t_scanner
	pda_slot = slot_l_store_str
	pda_type = /obj/item/modular_computer/pda/engineering

/decl/outfit/job/shipmap/engineering/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_ENGINEERING


/decl/outfit/job/shipmap/engineering/chief_engineer
	name = "Shipmap - Job - Chief Engineer"
//	head = /obj/item/clothing/head/hardhat/white
	uniform = /obj/item/clothing/jumpsuit/chief_engineer
	l_ear = /obj/item/radio/headset/heads/ce
	id_type = /obj/item/card/id/engineering/head
	pda_type = /obj/item/modular_computer/pda/heads/ce

/decl/outfit/job/shipmap/engineering/engineer
	name = "Shipmap - Job - Engineer"
//	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/jumpsuit/engineer
//	uniform = /obj/item/clothing/jumpsuit/hazard
	id_type = /obj/item/card/id/engineering
	suit = /obj/item/clothing/suit/hazardvest

/decl/outfit/job/shipmap/engineering/atmos_tech
	name = "Shipmap - Job - Atmos Tech"
	uniform = /obj/item/clothing/jumpsuit/atmospheric_technician
	belt = /obj/item/belt/utility/atmostech
	suit = /obj/item/clothing/suit/hazardvest


/obj/item/card/id/engineering
	name = "identification card"
	desc = "A card issued to engineering staff."
	detail_color = COLOR_SUN

/obj/item/card/id/engineering/head
	name = "identification card"
	desc = "A card which represents creativity and ingenuity."
	extra_details = list("goldstripe")
