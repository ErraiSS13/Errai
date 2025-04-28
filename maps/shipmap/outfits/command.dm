/decl/outfit/job/shipmap/command
	abstract_type = /decl/outfit/job/shipmap/command
	id_type = /obj/item/card/id/silver

/decl/outfit/job/shipmap/command/captain
	name = "Shipmap - Job - Captain"
	head = /obj/item/clothing/head/caphat
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/jumpsuit/captain
	l_ear = /obj/item/radio/headset/heads/captain
	shoes = /obj/item/clothing/shoes/color/brown
	id_type = /obj/item/card/id/gold
	pda_type = /obj/item/modular_computer/pda/heads/captain
	backpack_contents = list(/obj/item/box/ids = 1)

/decl/outfit/job/shipmap/command/first_officer
	name = "Shipmap - Job - First Officer"
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/jumpsuit/head_of_personnel
	l_ear = /obj/item/radio/headset/heads/fo
	shoes = /obj/item/clothing/shoes/color/brown
	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/modular_computer/pda/heads/hop
	backpack_contents = list(/obj/item/box/ids = 1)

/decl/outfit/job/shipmap/command/ship_pilot
	name = "Shipmap - Job - Ship Pilot"
	uniform = /obj/item/clothing/jumpsuit/pilot/nanotrasen
	l_ear = /obj/item/radio/headset/ship_pilot
	shoes = /obj/item/clothing/shoes/color/brown
	id_type = /obj/item/card/id
	pda_type = /obj/item/modular_computer/pda


/obj/item/radio/headset/heads/captain
	name = "captain's headset"
	desc = "The headset of the boss."
	encryption_keys = list(/obj/item/encryptionkey/heads/captain)

/obj/item/encryptionkey/heads/captain
	name = "captain's encryption key"
	can_decrypt = list(
		access_bridge,
		access_security,
		access_engine,
		access_research,
		access_medical,
		access_cargo,
		access_bar
	)

/obj/item/radio/headset/heads/fo
	name = "first officer's headset"
	desc = "The headset of the ship's number two."
	encryption_keys = list(/obj/item/encryptionkey/heads/fo)

/obj/item/encryptionkey/heads/fo
	name = "first officer's encryption key"
	can_decrypt = list(
		access_bridge,
		access_security,
		access_engine,
		access_research,
		access_medical,
		access_cargo,
		access_bar
	)


/obj/item/radio/headset/ship_pilot
	name = "ship pilot's headset"
	desc = "The headset of the ship's pilot."
	encryption_keys = list(/obj/item/encryptionkey/ship_pilot)

/obj/item/encryptionkey/ship_pilot
	name = "ship pilot's encryption key"
	inlay_color = COLOR_CYAN_BLUE
	can_decrypt = list(
		access_bridge,
		access_engine
	)