/decl/outfit/job/shipmap/medical
	abstract_type = /decl/outfit/job/shipmap/medical
	id_type = /obj/item/card/id/medical
	pda_type = /obj/item/modular_computer/pda/medical
	l_ear = /obj/item/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/color/white


/decl/outfit/job/shipmap/medical/chief_medical_officer
	name = "Shipmap - Job - Chief Medical Officer"
	l_ear = /obj/item/radio/headset/heads/cmo
	uniform = /obj/item/clothing/jumpsuit/chief_medical_officer
	suit = /obj/item/clothing/suit/toggle/labcoat/cmo
	shoes = /obj/item/clothing/shoes/color/brown
	r_pocket = /obj/item/flashlight/pen
	pda_type = /obj/item/modular_computer/pda/heads


/decl/outfit/job/shipmap/medical/doctor
	name = "Shipmap - Job - Medical Doctor"
	uniform = /obj/item/clothing/jumpsuit/medical
	suit = /obj/item/clothing/suit/toggle/labcoat
	hands = list(/obj/item/firstaid/adv)
	r_pocket = /obj/item/flashlight/pen


/decl/outfit/job/shipmap/medical/surgeon
	name = "Shipmap - Job - Surgeon"
	head = /obj/item/clothing/head/surgery/blue
	uniform = /obj/item/clothing/pants/scrubs/blue/outfit
	suit = /obj/item/clothing/suit/surgicalapron
	hands = list(/obj/item/firstaid/adv)


/decl/outfit/job/shipmap/medical/nurse
	name = "Shipmap - Job - Nurse"
	uniform = /obj/item/clothing/jumpsuit/white
	head = /obj/item/clothing/head/nursehat
	r_pocket = /obj/item/flashlight/pen


/decl/outfit/job/shipmap/medical/paramedic
	name = "Shipmap - Job - Paramedic"
	uniform = /obj/item/clothing/jumpsuit/medical/paramedic
	suit = /obj/item/clothing/suit/jacket/first_responder/ems
	r_pocket = /obj/item/flashlight/pen


/decl/outfit/job/shipmap/medical/chemist
	name = "Shipmap - Job - Chemist"
	uniform = /obj/item/clothing/jumpsuit/chemist
	suit = /obj/item/clothing/suit/toggle/labcoat/chemist


/obj/item/card/id/medical
	name = "identification card"
	desc = "A card issued to medical staff."
	detail_color = COLOR_PALE_BLUE_GRAY

/obj/item/card/id/medical/head
	name = "identification card"
	desc = "A card which represents care and compassion."
	extra_details = list("goldstripe")