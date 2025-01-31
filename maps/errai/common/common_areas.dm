// Specific maps can override these as needed, since their definitions will be later in the load order.
/area/ship/errai
	abstract_type = /area/ship/errai
	icon = 'maps/errai/common/generic_areas.dmi'
	holomap_color = HOLOMAP_AREACOLOR_CREW
	ambience = list(
		'sound/ambience/ambigen3.ogg',
		'sound/ambience/ambigen4.ogg',
		'sound/ambience/ambigen5.ogg',
		'sound/ambience/ambigen6.ogg',
	)

/*
	Command
*/
/area/ship/errai/command
	abstract_type = /area/ship/errai/command
	icon_state = "cerulean3"
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	req_access = list(access_heads)

/*
	Engineering
*/
/area/ship/errai/engineering
	abstract_type = /area/ship/errai/engineering
	icon_state = "yellow3"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
	req_access = list(access_engine)
	ambience = list(
		'sound/ambience/ambigen7.ogg',
		'sound/ambience/ambigen8.ogg',
		'sound/ambience/ambigen9.ogg',
		'sound/ambience/ambigen10.ogg',
		'sound/ambience/ambigen11.ogg',
		'sound/ambience/ambigen12.ogg',
	)

/*
	Maintenance
*/
/area/ship/errai/maintenance
	abstract_type = /area/ship/errai/maintenance
	holomap_color = HOLOMAP_AREACOLOR_MAINTENANCE
	icon_state = "yellow1"
	sound_env = TUNNEL_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED
	req_access = list(access_maint_tunnels)
	turf_initializer = /decl/turf_initializer/maintenance
	forced_ambience = list('sound/ambience/maintambience.ogg')
	ambience = list(
		'sound/ambience/ambigen7.ogg',
		'sound/ambience/ambigen8.ogg',
		'sound/ambience/ambigen9.ogg',
		'sound/ambience/ambigen10.ogg',
		'sound/ambience/ambigen11.ogg',
		'sound/ambience/ambigen12.ogg',
	)

/*
	Security
*/
/area/ship/errai/security
	abstract_type = /area/ship/errai/security
	icon_state = "red3"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY
	req_access = list(access_sec_doors)

/*
	Medical
*/
/area/ship/errai/medical
	abstract_type = /area/ship/errai/medical
	icon_state = "lime3"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL
	req_access = list(access_medical)

/*
	Research
*/
/area/ship/errai/research
	abstract_type = /area/ship/errai/research
	icon_state = "purple3"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	req_access = list(access_research)

/*
	Supply
*/
/area/ship/errai/supply
	abstract_type = /area/ship/errai/supply
	icon_state = "orange3"
	holomap_color = HOLOMAP_AREACOLOR_CARGO
	req_access = list(access_cargo)
	ambience = list(
		'sound/ambience/ambigen7.ogg',
		'sound/ambience/ambigen8.ogg',
		'sound/ambience/ambigen9.ogg',
		'sound/ambience/ambigen10.ogg',
		'sound/ambience/ambigen11.ogg',
		'sound/ambience/ambigen12.ogg',
	)

/*
	Service
*/
/area/ship/errai/service
	abstract_type = /area/ship/errai/service
	icon_state = "green3"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/*
	Commons
*/
/area/ship/errai/commons
	abstract_type = /area/ship/errai/commons
	icon_state = "aquamarine3"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/*
	Hallways
*/
/area/ship/errai/hallway
	abstract_type = /area/ship/errai/hallway
	icon_state = "green2"
	holomap_color = HOLOMAP_AREACOLOR_CREW // ..._HALLWAYS makes the hallways look completely transparent on the holomap.
	area_flags = AREA_FLAG_HALLWAY
	secure = FALSE

/*
	Shuttles
*/
/area/ship/errai/shuttle
	abstract_type = /area/ship/errai/shuttle
	icon_state = "pink3"
	holomap_color = HOLOMAP_AREACOLOR_EXPLORATION
	area_flags = AREA_FLAG_RAD_SHIELDED

/*
	Elevators
*/
/area/turbolift/errai
	abstract_type = /area/turbolift/errai
	icon_state = "green5"
