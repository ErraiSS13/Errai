/decl/outfit/job/shipmap/security
	abstract_type = /decl/outfit/job/shipmap/security
	id_type = /obj/item/card/id/security
	pda_type = /obj/item/modular_computer/pda/security
	l_ear = /obj/item/radio/headset/headset_sec
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/flash
	r_pocket = /obj/item/handcuffs
	backpack_contents = list(/obj/item/handcuffs = 1)

/decl/outfit/job/shipmap/security/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_SECURITY

/decl/outfit/job/shipmap/security/chief_of_security
	name = "Shipmap - Job - Chief of Security"
	id_type = /obj/item/card/id/security/head
	pda_type = /obj/item/modular_computer/pda/heads
	l_ear = /obj/item/radio/headset/heads/hos
	head = /obj/item/clothing/head/beret/corp/sec/corporate/hos
	uniform = /obj/item/clothing/jumpsuit/head_of_security/corp

/decl/outfit/job/shipmap/security/security_officer
	name = "Shipmap - Job - Security Officer"
	uniform = /obj/item/clothing/jumpsuit/security/corp
	head = /obj/item/clothing/head/soft/sec/corp


/decl/outfit/job/shipmap/security/detective
	name = "Shipmap - Job - Detective"
	head = /obj/item/clothing/head/det
	uniform = /obj/item/clothing/pants/slacks/outfit/detective
	suit = /obj/item/clothing/suit/det_trench
	shoes = /obj/item/clothing/shoes/dress
	hands = list(/obj/item/briefcase/crimekit)
	backpack_contents = list(/obj/item/box/evidence = 1, /obj/item/handcuffs = 1, /obj/item/flame/fuelled/lighter/zippo)
	
	
/obj/item/modular_computer/pda/security
	color = COLOR_DARK_RED
	decals = list("stripe" = COLOR_RED_LIGHT)

/obj/item/card/id/security
	name = "identification card"
	desc = "A card issued to security staff."
	color = COLOR_OFF_WHITE
	detail_color = COLOR_MAROON

/obj/item/card/id/security/head
	name = "identification card"
	desc = "A card which represents honor and protection."
	extra_details = list("goldstripe")

/*
/decl/outfit/job/security
	abstract_type = /decl/outfit/job/security
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	l_ear = /obj/item/radio/headset/headset_sec
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/jackboots
	backpack_contents = list(/obj/item/handcuffs = 1)

/decl/outfit/job/security/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_SECURITY

/decl/outfit/job/security/hos
	name = "Job - Head of security"
	l_ear = /obj/item/radio/headset/heads/hos
	uniform = /obj/item/clothing/jumpsuit/head_of_security
	id_type = /obj/item/card/id/security/head
	pda_type = /obj/item/modular_computer/pda/heads
	backpack_contents = list(/obj/item/handcuffs = 1)

/decl/outfit/job/security/warden
	name = "Job - Warden"
	uniform = /obj/item/clothing/jumpsuit/warden
	l_pocket = /obj/item/flash
	id_type = /obj/item/card/id/security
	pda_type = /obj/item/modular_computer/pda

/decl/outfit/job/security/detective
	name = "Job - Detective"
	head = /obj/item/clothing/head/det
	uniform = /obj/item/clothing/pants/slacks/outfit/detective
	suit = /obj/item/clothing/suit/det_trench
	l_pocket = /obj/item/flame/fuelled/lighter/zippo
	shoes = /obj/item/clothing/shoes/dress
	hands = list(/obj/item/briefcase/crimekit)
	id_type = /obj/item/card/id/security
	pda_type = /obj/item/modular_computer/pda
	backpack_contents = list(/obj/item/box/evidence = 1)

/decl/outfit/job/security/detective/Initialize()
	. = ..()
	backpack_overrides.Cut()

/decl/outfit/job/security/detective/forensic
	name = "Job - Forensic technician"
	head = null
	suit = /obj/item/clothing/suit/forensics/blue

/decl/outfit/job/security/officer
	name = "Job - Security Officer"
	uniform = /obj/item/clothing/jumpsuit/security
	l_pocket = /obj/item/flash
	r_pocket = /obj/item/handcuffs
	id_type = /obj/item/card/id/security
	pda_type = /obj/item/modular_computer/pda

*/