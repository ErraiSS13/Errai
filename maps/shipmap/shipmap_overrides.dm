// NT lawset is from a modpack, while the map define is always ticked, thus these overrides have to go here.
/datum/map/shipmap
	default_law_type = /datum/ai_laws/nanotrasen

/*
/datum/extension/ship_engine/gas
	volume_per_burn = 150
*/

/datum/computer_file/program
	requires_access_to_run = FALSE
/*
/datum/computer_file/program/comm
//	read_access = list()
	requires_access_to_run = FALSE

/datum/computer_file/program/atmos_control
	read_access = list()

/datum/computer_file/program/network_monitor
	read_access = list()

/datum/computer_file/program/power_monitor
	read_access = list()

/datum/computer_file/program/rcon_console
	read_access = list()

/datum/computer_file/program/shutoff_valve
	read_access = list()

/datum/computer_file/program/docking
	read_access = list()

/datum/computer_file/program/suit_sensors
	read_access = list()

/datum/computer_file/program/aidiag
	read_access = list()

/datum/computer_file/program/email_administration
	read_access = list()

/datum/computer_file/program/digitalwarrant
	read_access = list()

/datum/computer_file/program/forceauthorization
	read_access = list()
*/
/datum/computer_file/program/merchant/cargo
	read_access = list(access_cargo)

/obj/machinery/computer/modular/preset/merchant/cargo
	default_software = list(
		/datum/computer_file/program/merchant/cargo,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor
	)

/obj/machinery/computer/modular/preset/cargo
	default_software = list(
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/deck_management
	)

// Greenbay is back.
/decl/closet_appearance/secure_closet/medical
	extra_decals = list(
		"circle" = COLOR_DARK_GREEN_GRAY,
		"stripes_horizontal" = COLOR_DARK_GREEN_GRAY
	)

/decl/closet_appearance/secure_closet/medical/alt
	extra_decals = list(
		"medcircle" = COLOR_DARK_GREEN_GRAY,
		"stripe_vertical_right_partial" = COLOR_DARK_GREEN_GRAY,
		"stripe_vertical_mid_partial" = COLOR_DARK_GREEN_GRAY
	)

/decl/closet_appearance/wall/medical
	extra_decals = list(
		"stripe_outer" = COLOR_DARK_GREEN_GRAY,
		"stripe_inner" = COLOR_OFF_WHITE,
		"cross" = COLOR_DARK_GREEN_GRAY
	)


/obj/machinery/door/airlock/medical
	stripe_color = COLOR_PALE_GREEN_GRAY

/obj/machinery/door/airlock/glass/medical
	stripe_color = COLOR_PALE_GREEN_GRAY

/obj/machinery/door/airlock/double/medical
	stripe_color = COLOR_PALE_GREEN_GRAY

/obj/machinery/door/airlock/double/glass/medical
	stripe_color = COLOR_PALE_GREEN_GRAY

/decl/curtain_kind/plastic/medical
	color = COLOR_PALE_GREEN_GRAY

// Upstream these.
/obj/item/clothing/head/beret/corp
	color = null

/obj/machinery/computer/ship/navigation/telescreen
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "WEST":{"x":34}, "EAST":{"x":-34}}'