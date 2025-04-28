/datum/overmap
	map_size_x = 50
	map_size_y = 50

/obj/machinery/shipcomms
	effective_range = 5

/obj/effect/overmap/visitable/ship/main_ship
	name = "EES Wayward Star"
	desc = "A starship designed for long distance interstellar travel."
	color = "#009900"
	start_x = 25
	start_y = 25
	vessel_mass = 50000
	max_speed = 1/(2 SECONDS)
	burn_delay = 2 SECONDS
	sector_flags = OVERMAP_SECTOR_KNOWN|OVERMAP_SECTOR_BASE|OVERMAP_SECTOR_IN_SPACE
	fore_dir = NORTH
	skill_needed = SKILL_ADEPT
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list(
		/obj/effect/shuttle_landmark/shipmap/docking_arm_port::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/docking_arm_starboard::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/port_engineering_airlock::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/port_supply_airlock::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/port_central_airlock::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/port_solar_airlock::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/starboard_engineering_airlock::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/starboard_supply_airlock::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/starboard_central_airlock::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/starboard_solar_airlock::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/fore_cargo::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/fore_medical::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/fore_bridge::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/aft_research::landmark_tag,
		/obj/effect/shuttle_landmark/shipmap/aft_telecomms::landmark_tag
	)
	initial_restricted_waypoints = list(
		/datum/shuttle/autodock/overmap/shuttle_one = list(/obj/effect/shuttle_landmark/shipmap/hangar_one_dock::landmark_tag),
		/datum/shuttle/autodock/overmap/shuttle_two = list(/obj/effect/shuttle_landmark/shipmap/hangar_two_dock::landmark_tag)
	)
	known_ships = list(
		/obj/effect/overmap/visitable/ship/landable/shuttle/one,
		/obj/effect/overmap/visitable/ship/landable/shuttle/two
	)


/obj/effect/overmap/visitable/ship/landable/shuttle
	name = "Generic Shuttle"
	desc = "A small, medium range shuttle designed for intra-system operations."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000
	fore_dir = NORTH
	skill_needed = SKILL_BASIC
	vessel_size = SHIP_SIZE_SMALL


/obj/effect/overmap/visitable/ship/landable/shuttle/one
	name = "Shuttle One"
	shuttle = "Shuttle One"
	color = "#668800"
	known_ships = list(
		/obj/effect/overmap/visitable/ship/main_ship,
		/obj/effect/overmap/visitable/ship/landable/shuttle/two
	)

/obj/machinery/computer/shuttle_control/explore/shuttle_one
	name = "shuttle one control console"
	shuttle_tag = "Shuttle One"


/obj/effect/overmap/visitable/ship/landable/shuttle/two
	name = "Shuttle Two"
	shuttle = "Shuttle Two"
	color = "#008866"
	known_ships = list(
		/obj/effect/overmap/visitable/ship/main_ship,
		/obj/effect/overmap/visitable/ship/landable/shuttle/one
	)

/obj/machinery/computer/shuttle_control/explore/shuttle_two
	name = "shuttle two control console"
	shuttle_tag = "Shuttle Two"
