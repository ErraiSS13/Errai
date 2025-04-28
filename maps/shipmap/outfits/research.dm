/decl/outfit/job/shipmap/research
	abstract_type = /decl/outfit/job/shipmap/research
	id_type = /obj/item/card/id/research
	pda_type = /obj/item/modular_computer/pda/science
	l_ear = /obj/item/radio/headset/headset_sci
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/color/white


/decl/outfit/job/shipmap/research/research_director
	name = "Shipmap - Job - Research Director"
	id_type = /obj/item/card/id/research/head
	pda_type = /obj/item/modular_computer/pda/heads
	l_ear = /obj/item/radio/headset/heads/rd
	uniform = /obj/item/clothing/costume/research_director_suit
	suit = /obj/item/clothing/suit/toggle/labcoat/rd
	shoes = /obj/item/clothing/shoes/color/brown
	hands = list(/obj/item/clipboard)


/decl/outfit/job/shipmap/research/scientist
	name = "Shipmap - Job - Scientist"
	uniform = /obj/item/clothing/jumpsuit/white
	suit = /obj/item/clothing/suit/toggle/labcoat/science


/decl/outfit/job/shipmap/research/roboticist
	name = "Shipmap - Job - Roboticist"
	uniform = /obj/item/clothing/jumpsuit/roboticist
	shoes = /obj/item/clothing/shoes/color/black
	belt = /obj/item/belt/utility/full
	pda_slot = slot_r_store_str

/decl/outfit/job/shipmap/research/roboticist/Initialize()
	. = ..()
	backpack_overrides.Cut()


/obj/item/card/id/research
	name = "identification card"
	desc = "A card issued to research staff."
	detail_color = COLOR_PALE_PURPLE_GRAY

/obj/item/card/id/research/head
	name = "identification card"
	desc = "A card which represents knowledge and reasoning."
	extra_details = list("goldstripe")
