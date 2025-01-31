/datum/map/shipmap
	// Unit test exemptions
	apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/turbolift = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/errai/maintenance = NO_SCRUBBER|NO_VENT,
		/area/ship/errai/maintenance/waste = null,
		/area/ship/errai/engineering/thruster = NO_SCRUBBER|NO_VENT,
		/area/ship/errai/engineering/fuel_storage = NO_SCRUBBER|NO_VENT,
		/area/ship/errai/shuttle/escape_pod = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/errai/shuttle/escape_pod/pod_1 = NO_APC,
		/area/ship/errai/shuttle/escape_pod/pod_2 = NO_APC,
		/area/ship/errai/engineering/construction = NO_SCRUBBER|NO_VENT,
		/area/ship/errai/engineering/construction/site_c = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/errai/hallway/hangar_hallway = NO_SCRUBBER|NO_VENT,
		/area/ship/errai/supply/hidden = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/errai/research/xeno_cell/three = NO_VENT,
		/area/ship/errai/research/aft_maintenance_access = NO_SCRUBBER|NO_VENT,
		/area/ship/errai/engineering/atmospherics/deck_two = NO_SCRUBBER|NO_VENT,
		/area/ship/errai/security/prison_riot_control = NO_SCRUBBER|NO_VENT,
		/area/ship/errai/engineering/damage_control = NO_SCRUBBER|NO_VENT
	)

	area_coherency_test_exempt_areas = list(
		/area/space
	)

	area_coherency_test_subarea_count = list(

	)
