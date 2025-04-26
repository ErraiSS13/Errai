/datum/event/prison_break/medical
	areaType = list(/area/ship/errai/medical)

/datum/event/prison_break/science
	areaType = list(/area/ship/errai/research)

/datum/event/prison_break/station
	areaType = list(/area/ship/errai/security)


/area/ship/errai
	abstract_type = /area/ship/errai
	icon = 'mods/errai/mapping_aids/generic_areas.dmi'
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

/area/ship/errai/command/bridge
	name = "\improper Command - Bridge"
	icon_state = "cerulean4"
	req_access = list(access_bridge)

/area/ship/errai/command/meeting_room
	name = "\improper Command - Meeting Room"
	icon_state = "cerulean3"
	sound_env = MEDIUM_SOFTFLOOR

/area/ship/errai/command/teleporter
	name = "\improper Command - Teleporter"
	icon_state = "cerulean3"
	req_access = list(access_teleporter)

// Offices
/area/ship/errai/command/captains_office
	name = "\improper Command - Captain's Office"
	icon_state = "cerulean4"
	sound_env = MEDIUM_SOFTFLOOR
	req_access = list(access_captain)

/area/ship/errai/command/first_officers_office
	name = "\improper Command - First Officer's Office"
	icon_state = "cerulean4"
	sound_env = MEDIUM_SOFTFLOOR
	req_access = list(access_hop)

/area/ship/errai/engineering/ce_office
	name = "\improper Offices - Chief Engineer"
	icon_state = "yellow4"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_ce)

/area/ship/errai/supply/qm_office
	name = "\improper Offices - Quartermaster"
	icon_state = "orange4"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_qm)

/area/ship/errai/security/cos_office
	name = "\improper Offices - Chief of Security"
	icon_state = "red4"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_hos)

/area/ship/errai/medical/cmo_office
	name = "\improper Offices - Chief Medical Officer"
	icon_state = "lime4"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_cmo)

/area/ship/errai/research/rd_office
	name = "\improper Offices - Research Director"
	icon_state = "purple4"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_rd)

/area/ship/errai/command/bridge_office
	name = "\improper Offices - Bridge Crew"
	icon_state = "cerulean4"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_bridge)


// AI.
/area/ship/errai/command/ai
	icon_state = "blue3"
	ambience = list('sound/ambience/ambimalf.ogg')
	req_access = list(access_ai_upload)
	abstract_type = /area/ship/errai/command/ai

/area/ship/errai/command/ai/foyer
	name = "\improper Command - AI Foyer"
	sound_env = SMALL_ENCLOSED

/area/ship/errai/command/ai/upload
	name = "\improper Command - AI Upload"
	icon_state = "blue4"

/area/ship/errai/command/ai/core
	name = "\improper Command - AI Core"
	icon_state = "blue5"

/area/ship/errai/command/ai/self_destruct_foyer
	name = "\improper Command - Self Destruct Foyer" // Better name pls
	ambience = list('sound/ambience/ominous1.ogg', 'sound/ambience/ominous2.ogg', 'sound/ambience/ominous3.ogg')
	req_access = list(access_captain)

/area/ship/errai/command/ai/self_destruct
	name = "\improper Command - Self Destruct Chamber"
	icon_state = "blue4"
	ambience = list('sound/ambience/ominous1.ogg', 'sound/ambience/ominous2.ogg', 'sound/ambience/ominous3.ogg')
	req_access = list(access_captain)


// Telecomms.
/area/ship/errai/command/telecomms_foyer
	name = "\improper Command - Telecomms Foyer"
	icon_state = "cerulean3"
	req_access = list(access_tech_storage)

/area/ship/errai/command/telecomms_storage
	name = "\improper Command - Telecomms Storage"
	icon_state = "cerulean4"
	req_access = list(access_tech_storage)

/area/ship/errai/command/telecomms_power
	name = "\improper Command - Telecomms Power"
	icon_state = "cerulean4"
	req_access = list(access_engine_equip)

/area/ship/errai/command/telecomms
	name = "\improper Command - Telecommunications"
	icon_state = "cerulean5"
	req_access = list(access_tcomsat)
	ambience = list(
		'sound/ambience/ambisin1.ogg',
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/ambisin3.ogg',
		'sound/ambience/ambisin4.ogg',
		'sound/ambience/signal.ogg'
	)

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

/area/ship/errai/engineering/foyer
	name = "\improper Engineering - Foyer"
	icon_state = "green2"
	secure = FALSE
	holomap_color = HOLOMAP_AREACOLOR_CREW
	req_access = null

/area/ship/errai/engineering/reception
	name = "\improper Engineering - Reception"
	icon_state = "yellow2"

/area/ship/errai/engineering/port_hallway
	name = "\improper Engineering - Port Hallway"
	icon_state = "green2"
	secure = FALSE
	holomap_color = HOLOMAP_AREACOLOR_CREW
	req_access = null

/area/ship/errai/engineering/starboard_hallway
	name = "\improper Engineering - Starboard Hallway"
	icon_state = "yellow2"

/area/ship/errai/engineering/locker_room
	name = "\improper Engineering - Locker Room"
	icon_state = "yellow3"

/area/ship/errai/engineering/restroom
	name = "\improper Engineering - Restroom"
	icon_state = "yellow2"
	sound_env = SMALL_ENCLOSED

/area/ship/errai/engineering/storage
	name = "\improper Engineering - Storage"
	icon_state = "yellow3"

/area/ship/errai/engineering/workshop
	name = "\improper Engineering - Workshop"
	icon_state = "yellow3"

/area/ship/errai/engineering/eva
	name = "\improper Engineering - EVA Equipment"
	icon_state = "yellow4"
	req_access = list(access_engine_equip, access_eva)

/area/ship/errai/engineering/drone_fabrication
	name = "\improper Engineering - Drone Fabrication"
	icon_state = "yellow1"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine_equip)

/area/ship/errai/engineering/reactor_monitoring
	name = "\improper Engineering - Reactor Monitoring"
	icon_state = "yellow4"
	req_access = list(access_engine_equip)

/area/ship/errai/engineering/reactor
	name = "\improper Engineering - Reactor"
	icon_state = "yellow5"
	sound_env = LARGE_ENCLOSED
	req_access = list(access_engine_equip)

/area/ship/errai/engineering/reactor_filtering
	name = "\improper Engineering - Reactor Filtering"
	icon_state = "yellow4"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine_equip)

/area/ship/errai/engineering/reactor_power
	name = "\improper Engineering - Reactor Power"
	icon_state = "yellow4"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine_equip)

/area/ship/errai/engineering/damage_control
	abstract_type = /area/ship/errai/engineering/damage_control
	icon_state = "yellow3"
	req_access = list(access_engine_equip)

/area/ship/errai/engineering/damage_control/deck_one
	name = "Damage Control - Deck One"

// Atmospherics.
/area/ship/errai/engineering/atmospherics
	icon_state = "yellow5"
	sound_env = LARGE_ENCLOSED
	abstract_type = /area/ship/errai/engineering/atmospherics
	req_access = list(access_atmospherics)
	forced_ambience = list('sound/ambience/ambiatm1.ogg')

/area/ship/errai/engineering/atmospherics/deck_three
	name = "\improper Atmospherics - Deck Three"

/area/ship/errai/engineering/atmospherics/deck_two
	name = "\improper Atmospherics - Deck Two"

// Thrusters.
/area/ship/errai/engineering/thruster
	icon_state = "yellow2"
	sound_env = SMALL_ENCLOSED
	abstract_type = /area/ship/errai/engineering/thruster
	req_access = list(access_atmospherics)


/area/ship/errai/engineering/thruster/main
	abstract_type = /area/ship/errai/engineering/thruster/main

/area/ship/errai/engineering/thruster/main/port
	name = "\improper Main Thruster - Port"

/area/ship/errai/engineering/thruster/main/starboard
	name = "\improper Main Thruster - Starboard"


/area/ship/errai/engineering/thruster/auxiliary
	abstract_type = /area/ship/errai/engineering/thruster/auxiliary

/area/ship/errai/engineering/thruster/auxiliary/deck_one_port
	name = "\improper Auxiliary Thruster - Deck One Port"

/area/ship/errai/engineering/thruster/auxiliary/deck_one_starboard
	name = "\improper Auxiliary Thruster - Deck One Starboard"

/area/ship/errai/engineering/thruster/auxiliary/deck_three_port
	name = "\improper Auxiliary Thruster - Deck Three Port"

/area/ship/errai/engineering/thruster/auxiliary/deck_three_starboard
	name = "\improper Auxiliary Thruster - Deck Three Starboard"

/area/ship/errai/engineering/fuel_storage
	name = "\improper Engineering - Fuel Storage"
	icon_state = "yellow4"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_atmospherics)

// Construction Sites.
/area/ship/errai/engineering/construction
	abstract_type = /area/ship/errai/engineering/construction
	icon_state = "white2"
	req_access = list(access_construction)

/area/ship/errai/engineering/construction/site_a
	name = "Engineering - Construction Site A"

/area/ship/errai/engineering/construction/site_b
	name = "Engineering - Construction Site B"

/area/ship/errai/engineering/construction/site_c
	name = "Engineering - Construction Site C"

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

/area/ship/errai/maintenance/telecomms_port
	name = "\improper Maintenance - Telecomms Port"

/area/ship/errai/maintenance/telecomms_starboard
	name = "\improper Maintenance - Telecomms Starboard"

/area/ship/errai/maintenance/engineering_port
	name = "\improper Maintenance - Engineering Port"

/area/ship/errai/maintenance/engineering_starboard
	name = "\improper Maintenance - Engineering Starboard"

/area/ship/errai/maintenance/research_port
	name = "\improper Maintenance - Research Port"

/area/ship/errai/maintenance/research_starboard
	name = "\improper Maintenance - Research Starboard"

/area/ship/errai/maintenance/hangar_port
	name = "\improper Maintenance - Hangar Port"

/area/ship/errai/maintenance/hangar_starboard
	name = "\improper Maintenance - Hangar Starboard"

/area/ship/errai/maintenance/hangar_one_storage
	name = "\improper Maintenance - Hangar One Storage"

/area/ship/errai/maintenance/hangar_two_storage
	name = "\improper Maintenance - Hangar Two Storage"

/area/ship/errai/maintenance/supply_port
	name = "\improper Maintenance - Supply Port"

/area/ship/errai/maintenance/supply_starboard
	name = "\improper Maintenance - Supply Starboard"

/area/ship/errai/maintenance/security
	name = "\improper Maintenance - Security"

/area/ship/errai/maintenance/service
	name = "\improper Maintenance - Service"

/area/ship/errai/maintenance/chapel
	name = "\improper Maintenance - Chapel"

/area/ship/errai/maintenance/atmospherics
	name = "\improper Maintenance - Atmospherics"

/area/ship/errai/maintenance/deck_one_port
	name = "\improper Maintenance - Deck One Port"

/area/ship/errai/maintenance/deck_one_starboard
	name = "\improper Maintenance - Deck One Starboard"

// Substations.
/area/ship/errai/maintenance/substation
	abstract_type = /area/ship/errai/maintenance/substation
	icon_state = "yellow2"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine_equip)

/area/ship/errai/maintenance/substation/engineering
	name = "\improper Substation - Engineering"

/area/ship/errai/maintenance/substation/atmospherics
	name = "\improper Substation - Atmospherics"

/area/ship/errai/maintenance/substation/research
	name = "\improper Substation - Research"

/area/ship/errai/maintenance/substation/medical
	name = "\improper Substation - Medical"

/area/ship/errai/maintenance/substation/civilian
	name = "\improper Substation - Civilian"

/area/ship/errai/maintenance/substation/security
	name = "\improper Substation - Security"

/area/ship/errai/maintenance/substation/command
	name = "\improper Substation - Command"

/area/ship/errai/maintenance/substation/supply
	name = "\improper Substation - Supply"

/area/ship/errai/maintenance/substation/deck_one
	name = "\improper Substation - Deck One"

/area/ship/errai/maintenance/substation/deck_two
	name = "\improper Substation - Deck Two"

/area/ship/errai/maintenance/substation/deck_three
	name = "\improper Substation - Deck Three"

// Solars.
/area/ship/errai/maintenance/solars
	abstract_type = /area/ship/errai/maintenance/solars
	icon_state = "yellow2"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine_equip)

/area/ship/errai/maintenance/solars/port
	name = "\improper Solars - Port"

/area/ship/errai/maintenance/solars/starboard
	name = "\improper Solars - Starboard"


/area/ship/errai/maintenance/incinerator
	name = "\improper Maintenance - Incinerator"
	icon_state = "orange2"


/area/ship/errai/maintenance/waste
	name = "\improper Maintenance - Waste Disposal"
	icon_state = "orange2"
	sound_env = SMALL_ENCLOSED

/*
	Security.
*/
/area/ship/errai/security
	abstract_type = /area/ship/errai/security
	icon_state = "red3"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY
	req_access = list(access_sec_doors)

/area/ship/errai/security/foyer
	name = "\improper Security - Foyer"
	icon_state = "green2"
	secure = FALSE
	holomap_color = HOLOMAP_AREACOLOR_CREW
	req_access = null

/area/ship/errai/security/reception
	name = "\improper Security - Reception"
	icon_state = "red3"

/area/ship/errai/security/hallway
	name = "\improper Security - Hallway"
	icon_state = "red3"

/area/ship/errai/security/interrogation
	name = "\improper Security - Interrogation"
	icon_state = "red2"
	req_access = list(access_security)

/area/ship/errai/security/locker_room
	name = "\improper Security - Locker Room"
	icon_state = "red2"

/area/ship/errai/security/equipment_room
	name = "\improper Security - Equipment Room"
	icon_state = "red4"
	req_access = list(access_security)

/area/ship/errai/security/armory
	name = "\improper Security - Armory"
	icon_state = "red5"
	req_access = list(access_armory)

/area/ship/errai/security/forensics
	name = "\improper Security - Forensics Office"
	icon_state = "red3"
	req_access = list(access_security)

/area/ship/errai/security/evidence_storage
	name = "\improper Security - Evidence Storage"
	icon_state = "red3"
	req_access = list(access_security)

/area/ship/errai/security/prison_riot_control
	name = "\improper Security - Prison Riot Control"
	icon_state = "red2"
	req_access = list(list(access_security, access_atmospherics))

/area/ship/errai/security/brig
	name = "\improper Security - Brig"
	icon_state = "red4"
	req_access = list(access_brig)


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

/area/ship/errai/supply/pilots_lounge
	name = "\improper Supply - Pilots' Lounge"
	icon_state = "orange2"
	req_access = list(access_shuttle_pilot)

/area/ship/errai/supply/tech_storage
	name = "\improper Supply - Technicial Storage"
	icon_state = "orange3"
	req_access = list(access_tech_storage)

/area/ship/errai/supply/general_eva
	name = "\improper Supply - General EVA"
	icon_state = "orange3"
	req_access = list(access_eva)

/area/ship/errai/supply/vault
	name = "\improper Supply - Vault"
	icon_state = "orange1"
	req_access = list(access_heads_vault)

/area/ship/errai/supply/hangar_storage
	abstract_type = /area/ship/errai/supply/hangar_storage
	holomap_color = HOLOMAP_AREACOLOR_CARGO
	icon_state = "orange2"

/area/ship/errai/supply/hangar_storage/gas
	name = "\improper Supply - Hangar Gas Storage"
	req_access = list(list(access_cargo, access_atmospherics))

/area/ship/errai/supply/hangar_storage/bulk
	name = "\improper Supply - Hangar Bulk Storage"
	req_access = list(list(access_cargo, access_mining, access_xenoarch))

/area/ship/errai/supply/foyer
	name = "\improper Supply - Foyer"
	icon_state = "green2"
	secure = FALSE
	holomap_color = HOLOMAP_AREACOLOR_CREW
	req_access = null

/area/ship/errai/supply/supply_office
	name = "\improper Supply - Supply office"
	icon_state = "orange4"

/area/ship/errai/supply/mining
	name = "\improper Supply - Mining"
	icon_state = "orange4"
	req_access = list(access_mining)

/area/ship/errai/supply/warehouse
	name = "\improper Supply - Cargo Hold"
	icon_state = "orange2"
	req_access = list(access_cargo_hold)
	sound_env = LARGE_ENCLOSED

/area/ship/errai/supply/locker_room
	name = "\improper Supply - Locker Room"
	icon_state = "orange3"
	sound_env = SMALL_ENCLOSED

/area/ship/errai/supply/restroom
	name = "\improper Supply - Restroom"
	icon_state = "orange2"
	sound_env = SMALL_ENCLOSED

/area/ship/errai/supply/common
	name = "\improper Supply - Common Area"
	icon_state = "orange3"
	sound_env = SMALL_ENCLOSED

/area/ship/errai/supply/hidden
	name = "\improper Unknown"
	icon_state = "white1"
	area_flags = AREA_FLAG_RAD_SHIELDED
	sound_env = SMALL_ENCLOSED

/*
	Medical
*/
/area/ship/errai/medical
	abstract_type = /area/ship/errai/medical
	icon_state = "lime3"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL
	req_access = list(access_medical)

/area/ship/errai/medical/foyer
	name = "\improper Medical - Foyer"
	icon_state = "green2"
	holomap_color = HOLOMAP_AREACOLOR_CREW
	req_access = null

/area/ship/errai/medical/reception
	name = "\improper Medical - Reception"
	icon_state = "lime2"
	req_access = list(access_medical_equip)

/area/ship/errai/medical/chemistry
	name = "\improper Medical - Chemistry"
	icon_state = "lime4"
	req_access = list(access_chemistry)

/area/ship/errai/medical/emt_hallway
	name = "\improper Medical - First Responser Equipment Room" // Better name needed, probably.
	icon_state = "lime3"
	req_access = list(access_medical_equip)

/area/ship/errai/medical/exam_room
	name = "\improper Medical - Exam Room"
	icon_state = "lime2"
	req_access = list(access_medical_equip)

/area/ship/errai/medical/treatment_center
	name = "\improper Medical - Treatment Center"
	icon_state = "lime3"

/area/ship/errai/medical/storage
	name = "\improper Medical - Storage"
	icon_state = "lime3"
	req_access = list(access_medical_equip)

/area/ship/errai/medical/morgue
	name = "\improper Medical - Morgue"
	icon_state = "lime2"
	req_access = list(access_morgue)

/area/ship/errai/medical/patient_ward
	name = "\improper Medical - Patient Ward"
	icon_state = "lime1"
	req_access = null

/area/ship/errai/medical/restroom
	name = "\improper Medical - Restroom"
	icon_state = "lime1"
	req_access = null

/area/ship/errai/medical/surgery_hallway
	name = "\improper Medical - Surgery Hallway"
	icon_state = "lime3"
	req_access = null

/area/ship/errai/medical/surgery_storage
	name = "\improper Medical - Surgery Storage"
	icon_state = "lime3"
	req_access = list(access_surgery)

/area/ship/errai/medical/operating_room
	name = "\improper Medical - Operating Room"
	icon_state = "lime4"
	req_access = list(access_surgery)

/area/ship/errai/medical/operation_observation
	name = "\improper Medical - Operating Observation Room"
	icon_state = "lime2"
	req_access = null


/*
	Research
*/
/area/ship/errai/research
	abstract_type = /area/ship/errai/research
	icon_state = "purple3"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	req_access = list(access_research)

/area/ship/errai/research/foyer
	name = "\improper Research - Foyer"
	icon_state = "green2"
	holomap_color = HOLOMAP_AREACOLOR_CREW
	req_access = null

/area/ship/errai/research/research_and_development
	name = "\improper Research - Research and Development"
	icon_state = "purple4"
	req_access = list(access_tox)

/area/ship/errai/research/robotics
	name = "\improper Research - Robotics"
	icon_state = "purple4"
	req_access = list(access_robotics)

/area/ship/errai/research/mech_bay
	name = "\improper Research - Mech Bay"
	icon_state = "purple3"
	req_access = list(access_robotics)

/area/ship/errai/research/corridor
	name = "\improper Research - Corridor"
	icon_state = "purple2"

/area/ship/errai/research/restroom
	name = "\improper Research - Restroom"
	icon_state = "purple2"

/area/ship/errai/research/gas_mixing
	name = "\improper Research - Gas Mixing"
	icon_state = "purple5"
	req_access = list(access_tox_storage)

/area/ship/errai/research/gas_storage
	name = "\improper Research - Gas Storage"
	icon_state = "purple4"
	req_access = list(list(access_tox_storage, access_atmospherics))

/area/ship/errai/research/xeno_studies
	name = "\improper Research - Xeno Studies"
	icon_state = "purple4"
	req_access = list(list(access_xenoarch, access_xenobiology))


/area/ship/errai/research/xeno_cell
	abstract_type = /area/ship/errai/research/xeno_cell
	icon_state = "purple3"
	req_access = list(list(access_xenoarch, access_xenobiology))

/area/ship/errai/research/xeno_cell/one
	name = "\improper Research - Xeno Cell One"

/area/ship/errai/research/xeno_cell/two
	name = "\improper Research - Xeno Cell Two"

/area/ship/errai/research/xeno_cell/three
	name = "\improper Research - Xeno Cell Three"


/area/ship/errai/research/aft_maintenance_access
	name = "\improper Research - Aft Maintenance Access"
	icon_state = "purple2"

/area/ship/errai/research/port_maintenance_access
	name = "\improper Research - Port Maintenance Access"
	icon_state = "purple2"



/*
	Service
*/
/area/ship/errai/service
	abstract_type = /area/ship/errai/service
	icon_state = "green3"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/ship/errai/service/bar
	name = "\improper Service - Bar"
	sound_env = LARGE_ENCLOSED
	icon_state = "green4"

/area/ship/errai/service/bar_backroom
	name = "\improper Service - Bar Backroom"
	sound_env = SMALL_ENCLOSED
	icon_state = "green2"
	req_access = list(access_bar)

/area/ship/errai/service/kitchen
	name = "\improper Service - Kitchen"
	icon_state = "green3"
	req_access = list(access_kitchen)

/area/ship/errai/service/hydroponics
	name = "\improper Service - Hydroponics"
	icon_state = "green3"
	req_access = list(access_hydroponics)

/area/ship/errai/service/janitor
	name = "\improper Service - Custodial Closet"
	sound_env = SMALL_ENCLOSED
	icon_state = "green2"
	req_access = list(access_janitor)

/area/ship/errai/service/chapel
	name = "\improper Service - Chapel"
	icon_state = "green3"
	sound_env = LARGE_ENCLOSED
	ambience = list(
		'sound/ambience/ambicha1.ogg',
		'sound/ambience/ambicha2.ogg',
		'sound/ambience/ambicha3.ogg',
		'sound/ambience/ambicha4.ogg'
	)

/area/ship/errai/service/chapel_office
	name = "\improper Service - Chapel Office"
	icon_state = "green4"
	req_access = list(access_chapel_office)


/*
	Commons
*//area/ship/errai/commons
	abstract_type = /area/ship/errai/commons
	icon_state = "aquamarine3"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/ship/errai/commons/tool_storage
	name = "\improper Commons - Tool Storage"
	icon_state = "aquamarine3"

/area/ship/errai/commons/vacant_office
	name = "\improper Commons - Vacant Office"
	icon_state = "aquamarine2"

/area/ship/errai/commons/dormitory
	name = "\improper Commons - Dormitory"
	sound_env = SMALL_ENCLOSED
	icon_state = "aquamarine2"

/area/ship/errai/commons/cryo
	name = "\improper Commons - Cyrogenic Storage"
	icon_state = "aquamarine4"

/area/ship/errai/commons/restroom
	name = "\improper Commons - Restroom"
	sound_env = SMALL_ENCLOSED
	icon_state = "aquamarine3"

/area/ship/errai/commons/exercise
	name = "\improper Commons - Exercise Room"
	icon_state = "aquamarine3"

/area/ship/errai/commons/pool
	name = "\improper Commons - Pool"
	icon_state = "aquamarine4"


/*
	Hallways
*/
/area/ship/errai/hallway
	abstract_type = /area/ship/errai/hallway
	icon_state = "green2"
	holomap_color = HOLOMAP_AREACOLOR_CREW // ..._HALLWAYS makes the hallways look completely transparent on the holomap.
	area_flags = AREA_FLAG_HALLWAY
	secure = FALSE


// Deck Three
/area/ship/errai/hallway/hangar_hallway
	name = "\improper Supply - Hangar Hallway"
	sound_env = LARGE_ENCLOSED

/area/ship/errai/hallway/deck_three_fore_hallway
	name = "\improper Hallway - Deck Three Fore"

/area/ship/errai/hallway/deck_three_fore_port_hallway
	name = "\improper Hallway - Deck Three Fore Port"

/area/ship/errai/hallway/deck_three_fore_starboard_hallway
	name = "\improper Hallway - Deck Three Fore Starboard"

/area/ship/errai/hallway/deck_three_aft_hallway
	name = "\improper Hallway - Deck Three Aft"

/area/ship/errai/hallway/deck_three_port_docking_hallway
	name = "\improper Hallway - Deck Three Port Docking Hallway"

/area/ship/errai/hallway/deck_three_starboard_docking_hallway
	name = "\improper Hallway - Deck Three Starboard Docking Hallway"

// Deck Two
/area/ship/errai/hallway/deck_two_fore_hallway
	name = "\improper Hallway - Deck Two Fore"

/area/ship/errai/hallway/deck_two_aft_hallway
	name = "\improper Hallway - Deck Two Aft"

/area/ship/errai/hallway/deck_two_center_hallway
	name = "\improper Hallway - Deck Two Center"

/area/ship/errai/hallway/deck_two_fore_port_hallway
	name = "\improper Hallway - Deck Two Fore Port"

/area/ship/errai/hallway/deck_two_aft_port_hallway
	name = "\improper Hallway - Deck Two Aft Port"

/area/ship/errai/hallway/deck_two_fore_starboard_hallway
	name = "\improper Hallway - Deck Two Fore Starboard"

/area/ship/errai/hallway/deck_two_aft_starboard_hallway
	name = "\improper Hallway - Deck Two Aft Starboard"

// Deck One
/area/ship/errai/hallway/command
	name = "\improper Hallway - Command"

/area/ship/errai/hallway/deck_one_fore_hallway
	name = "\improper Hallway - Deck One Fore"

/area/ship/errai/hallway/deck_one_aft_hallway
	name = "\improper Hallway - Deck One Aft"

/area/ship/errai/hallway/deck_one_port_hallway
	name = "\improper Hallway - Deck One Port"

/area/ship/errai/hallway/deck_one_starboard_hallway
	name = "\improper Hallway - Deck One Starboard"

/*
	Stairwells
*/
/area/ship/errai/hallway/stairwell
	abstract_type = /area/ship/errai/hallway/stairwell
	icon_state = "green3"

/area/ship/errai/hallway/stairwell/deck_three_fore
	name = "\improper Stairwell - Deck Three Fore"

/area/ship/errai/hallway/stairwell/deck_three_aft
	name = "\improper Stairwell - Deck Three Aft"

/area/ship/errai/hallway/stairwell/deck_two_fore
	name = "\improper Stairwell - Deck Two Fore"

/area/ship/errai/hallway/stairwell/deck_two_aft
	name = "\improper Stairwell - Deck Two Aft"

/area/ship/errai/hallway/stairwell/deck_one_fore
	name = "\improper Stairwell - Deck One Fore"

/area/ship/errai/hallway/stairwell/deck_one_aft
	name = "\improper Stairwell - Deck One Aft"

/*
	Hangars
*/
/area/ship/errai/hangar
	abstract_type = /area/ship/errai/hangar
	holomap_color = HOLOMAP_AREACOLOR_CARGO
	icon_state = "orange3"
	sound_env = LARGE_ENCLOSED

/area/ship/errai/hangar/one
	name = "\improper Supply - Hangar One"

/area/ship/errai/hangar/two
	name = "\improper Supply - Hangar Two"

/*
	Shuttles
*/
/area/ship/errai/shuttle
	abstract_type = /area/ship/errai/shuttle
	icon_state = "pink3"
	holomap_color = HOLOMAP_AREACOLOR_EXPLORATION
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/ship/errai/shuttle/one
	name = "\improper Shuttle One"
	icon_state = "orange5"

/area/ship/errai/shuttle/two
	name = "\improper Shuttle Two"
	icon_state = "orange5"

// Escape Pods.
/area/ship/errai/shuttle/escape_pod
	abstract_type = /area/ship/errai/shuttle/escape_pod
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE
	icon_state = "red4"
	ambience = list('sound/ambience/ominous1.ogg', 'sound/ambience/ominous2.ogg', 'sound/ambience/ominous3.ogg')
	requires_power = FALSE
	sound_env = SMALL_ENCLOSED

// See `shipmap_shuttles.dm` for the boilerplate generator which makes all of the subtypes used.


/*
	Elevators
*/
/area/turbolift/errai
	abstract_type = /area/turbolift/errai
	icon_state = "green5"

/area/turbolift/errai/deck_one_fore
	name = "\improper Elevator - Deck One Fore"
	lift_announce_str = "Arriving at Deck One, Fore: Bridge. First Officer's Office. Meeting Room. Heads of Staffs' Offices. AI Upload."

/area/turbolift/errai/deck_two_fore
	name = "\improper Elevator - Deck Two Fore"
	lift_announce_str = "Arriving at Deck Two, Fore: Medbay. Bar. Tool Storage. Janitorial Closet. Recreation. Dormitories. Cryosleep."

/area/turbolift/errai/deck_three_fore
	name = "\improper Elevator - Deck Three Fore"
	lift_announce_str = "Arriving at Deck Three, Fore: Cargo. Technical Storage. Vault. EVA. Pilots' Lounge. Hangars."
	base_turf = /turf/floor/plating

/area/turbolift/errai/deck_one_aft
	name = "\improper Elevator - Deck One Aft"
	lift_announce_str = "Arriving at Deck One, Aft: Telecomms. Solars. Teleporter."

/area/turbolift/errai/deck_two_aft
	name = "\improper Elevator - Deck Two Aft"
	lift_announce_str = "Arriving at Deck Two, Aft: Research. Chapel. Security."

/area/turbolift/errai/deck_three_aft
	name = "\improper Elevator - Deck Three Aft"
	lift_announce_str = "Arriving at Deck Three, Aft: Engineering. Hangar Storage. Docking Arms. Hangars."
	base_turf = /turf/floor/plating

/area/turbolift/errai/atmospherics_deck_three
	name = "\improper Elevator - Atmospherics Deck Three"
	base_turf = /turf/floor/plating

/area/turbolift/errai/atmospherics_deck_two
	name = "\improper Elevator - Atmospherics Deck Two"
