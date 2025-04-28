/turf/floor/tiled/old_tile/dark
	_flooring = /decl/flooring/tiling/new_tile/dark

/turf/floor/tiled/old_cargo/dark
	_flooring = /decl/flooring/tiling/new_tile/cargo_one/dark

/decl/flooring/tiling/new_tile/dark
	color = COLOR_DARK_GUNMETAL

/decl/flooring/tiling/new_tile/cargo_one/dark
	color = COLOR_DARK_GUNMETAL

// Makes the lights less intense.
/decl/flooring/reinforced/circuit
	turf_light_range = 2
	turf_light_power = 1


// A combined food and drink smartfridge that is access locked.
/obj/machinery/smartfridge/secure/bar
	name = "\improper Food and Drink Display"
	desc = "A storage unit for freshly made food and beverages."
	icon = 'icons/obj/machines/smartfridges/food.dmi'
	overlay_contents_icon = 'icons/obj/machines/smartfridges/contents_food.dmi'
	req_access = list(list(access_bar, access_kitchen))
	opacity = TRUE

/obj/machinery/smartfridge/secure/bar/accept_check(var/obj/item/O)
	var/static/list/_allowed_types = list(
		/obj/item/food,
		/obj/item/utensil,
		/obj/item/chems/glass,
		/obj/item/chems/drinks,
		/obj/item/chems/condiment
	)
	return istype(O) && O.reagents?.total_volume && is_type_in_list(O, _allowed_types)


/obj/machinery/computer/modular/preset/pilot
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/reports
	)

// Turrets.
/obj/machinery/turret/network
	turning_rate = 90

/obj/machinery/turret/network/prebuilt
	installed_gun = /obj/item/gun/energy/laser
	check_access = TRUE
	check_records = TRUE
	check_lifeforms = TRUE
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/scanning_module
	)

/datum/fabricator_recipe/imprinter/circuit/sentry_turret
	path = /obj/item/stock_parts/circuitboard/sentry_turret

// These seem kind of buggy so might just remove them from the map.
/datum/fabricator_recipe/imprinter/circuit/comms
	path = /obj/item/stock_parts/circuitboard/comms

/datum/fabricator_recipe/imprinter/circuit/comms_maser
	path = /obj/item/stock_parts/circuitboard/comms_maser

/datum/fabricator_recipe/imprinter/circuit/comms_antenna
	path = /obj/item/stock_parts/circuitboard/comms_antenna

/datum/fabricator_recipe/imprinter/circuit/mining_extractor
	path = /obj/item/stock_parts/circuitboard/mining_extractor