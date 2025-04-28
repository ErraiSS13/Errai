/obj/effect/shuttle_landmark/shipmap
	abstract_type = /obj/effect/shuttle_landmark/shipmap
	flags = SLANDMARK_FLAG_REORIENT

// Shuttle One.
/datum/shuttle/autodock/overmap/shuttle_one
	name = "Shuttle One"
	shuttle_area = /area/ship/errai/shuttle/one
	dock_target = "shuttle_one"
	current_location = /obj/effect/shuttle_landmark/shipmap/hangar_one_dock::landmark_tag
	force_ceiling_on_init = FALSE
	logging_home_tag = /obj/effect/shuttle_landmark/shipmap/hangar_one_dock::landmark_tag
	logging_access = access_eva

/obj/effect/shuttle_landmark/shipmap/hangar_one_dock
	name = "Hangar One"
	landmark_tag = "nav_hangar_one"
	docking_controller = "hangar_one_dock"
	base_area = /area/ship/errai/hangar/one
	base_turf = /turf/floor/reinforced

// Shuttle Two.
/datum/shuttle/autodock/overmap/shuttle_two
	name = "Shuttle Two"
	shuttle_area = /area/ship/errai/shuttle/two
	dock_target = "shuttle_two"
	current_location = /obj/effect/shuttle_landmark/shipmap/hangar_two_dock::landmark_tag
	force_ceiling_on_init = FALSE
	logging_home_tag = /obj/effect/shuttle_landmark/shipmap/hangar_two_dock::landmark_tag
	logging_access = access_eva

/obj/effect/shuttle_landmark/shipmap/hangar_two_dock
	name = "Hangar Two"
	landmark_tag = "nav_hangar_two"
	docking_controller = "hangar_two_dock"
	base_area = /area/ship/errai/hangar/two
	base_turf = /turf/floor/reinforced

// Docking Arms.
/obj/effect/shuttle_landmark/shipmap/docking_arm_port
	name = "Port-side Docking Arm"
	landmark_tag = "nav_port_docking_arm"
	docking_controller = "port_docking_arm"

/obj/effect/shuttle_landmark/shipmap/docking_arm_starboard
	name = "Starboard-side Docking Arm"
	landmark_tag = "nav_starboard_docking_arm"
	docking_controller = "starboard_docking_arm"

// Exterior landmarks.
/obj/effect/shuttle_landmark/shipmap/port_engineering_airlock
	name = "Port, near the Engineering airlock"
	landmark_tag = "nav_port_engineering"

/obj/effect/shuttle_landmark/shipmap/starboard_engineering_airlock
	name = "Starboard, near the Engineering airlock"
	landmark_tag = "nav_starboard_engineering"

/obj/effect/shuttle_landmark/shipmap/port_supply_airlock
	name = "Port, near the Supply airlock"
	landmark_tag = "nav_port_supply"

/obj/effect/shuttle_landmark/shipmap/starboard_supply_airlock
	name = "Starboard, near the Supply airlock"
	landmark_tag = "nav_starboard_supply"

/obj/effect/shuttle_landmark/shipmap/port_central_airlock
	name = "Port, near the Central airlock"
	landmark_tag = "nav_port_central"

/obj/effect/shuttle_landmark/shipmap/starboard_central_airlock
	name = "Starboard, near the Central airlock"
	landmark_tag = "nav_starboard_central"

/obj/effect/shuttle_landmark/shipmap/port_solar_airlock
	name = "Port, near the Solars airlock"
	landmark_tag = "nav_port_solars"

/obj/effect/shuttle_landmark/shipmap/starboard_solar_airlock
	name = "Starboard, near the Solars airlock"
	landmark_tag = "nav_starboard_solars"

/obj/effect/shuttle_landmark/shipmap/fore_cargo
	name = "Fore, near Supply"
	landmark_tag = "nav_fore_deck_three"

/obj/effect/shuttle_landmark/shipmap/fore_medical
	name = "Fore, near Medical"
	landmark_tag = "nav_fore_deck_two"

/obj/effect/shuttle_landmark/shipmap/fore_bridge
	name = "Fore, near the Bridge"
	landmark_tag = "nav_fore_deck_one"

/obj/effect/shuttle_landmark/shipmap/aft_research
	name = "Aft, near Research"
	landmark_tag = "nav_aft_deck_two"

/obj/effect/shuttle_landmark/shipmap/aft_telecomms
	name = "Aft, near Telecomms"
	landmark_tag = "nav_aft_deck_one"

// Escape pods
/datum/shuttle/autodock/ferry/escape_pod
	force_ceiling_on_init = FALSE
	warmup_time = 1 SECOND

/obj/effect/shuttle_landmark/shipmap/escape_pod
	abstract_type = /obj/effect/shuttle_landmark/shipmap/escape_pod
	base_turf = /turf/floor/reinforced/airless

#define ESCAPE_POD(TEXT, NUMBER) \
/datum/shuttle/autodock/ferry/escape_pod/pod_##NUMBER { \
	shuttle_area = /area/ship/errai/shuttle/escape_pod/pod_##NUMBER; \
	name = "Escape Pod " + #TEXT; \
	dock_target = "escape_pod_" + #NUMBER; \
	arming_controller = "escape_pod_"+ #NUMBER +"_berth"; \
	waypoint_station = "escape_pod_"+ #NUMBER +"_start"; \
	landmark_transition = "escape_pod_"+ #NUMBER +"_transit"; \
	waypoint_offsite = "escape_pod_"+ #NUMBER +"_out"; \
} \
/obj/effect/shuttle_landmark/shipmap/escape_pod/start/pod_##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_start"; \
	docking_controller = "escape_pod_"+ #NUMBER +"_berth"; \
} \
/obj/effect/shuttle_landmark/shipmap/escape_pod/transit/pod_##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_transit"; \
} \
/obj/effect/shuttle_landmark/shipmap/escape_pod/out/pod_##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_out"; \
} \
/area/ship/errai/shuttle/escape_pod/pod_##NUMBER { \
	name = "\improper Escape Pod - " + #TEXT; \
}

// Deck one.
ESCAPE_POD(One, 1)
ESCAPE_POD(Two, 2)
// Three and Four don't exist.

// Deck two.
ESCAPE_POD(Five, 5)
// Six doesn't exist.
ESCAPE_POD(Seven, 7)
// Eight doesn't exist.

// Deck three.
ESCAPE_POD(Nine, 9)
ESCAPE_POD(Ten, 10)
ESCAPE_POD(Eleven, 11)
ESCAPE_POD(Twelve, 12)


#undef ESCAPE_POD
