/datum/job/shipmap/head/chief_engineer
	title = "Chief Engineer"
	hud_icon_state = "hud_ce"
	supervisors = "the Captain and the First Officer"
	description = "You manage the Engineering department, making sure that your subordinates do their jobs, \
	and that the ship remains powered, air-tight, and spaceworthy. You also advise the Captain and the First Officer \
	on engineering matters. Finally, you and the Research Director also jointly manage the ship's artificial intelligence \
	and the robots they control."
	selection_color = "#7f6e2c"
	department_types = list(
		/decl/department/engineering,
		/decl/department/command
	)
	access = list(
		// CE
		access_ce,
		access_tcomsat,
		access_ai_upload,
		access_teleporter,

		// Heads of staff
		access_bridge,
		access_heads,
		access_RC_announce,
		access_keycard_auth,
		access_sec_doors,

		// Engineering
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_external_airlocks,
		access_atmospherics,
		access_emergency_storage,
		access_eva,
		access_construction
	)
	outfit_type = /decl/outfit/job/shipmap/engineering/chief_engineer
	min_skill = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_COMPUTER     = SKILL_ADEPT,
		SKILL_EVA          = SKILL_ADEPT,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL   = SKILL_ADEPT,
		SKILL_ATMOS        = SKILL_ADEPT,
		SKILL_ENGINES      = SKILL_EXPERT
	)
	software_on_spawn = list(
		/datum/computer_file/program/comm,
		/datum/computer_file/program/network_monitor,
		/datum/computer_file/program/power_monitor,
		/datum/computer_file/program/supermatter_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmos_control,
		/datum/computer_file/program/rcon_console,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/shields_monitor,
		/datum/computer_file/program/reports
	)
	event_categories = list(ASSIGNMENT_ENGINEER)

/obj/abstract/landmark/start/shipmap/chief_engineer
	name = "Chief Engineer"


/datum/job/shipmap/engineer
	title = "Engineer"
	hud_icon_state = "hud_engineer"
	supervisors = "the Chief Engineer"
	outfit_type = /decl/outfit/job/shipmap/engineering/engineer
	department_types = list(/decl/department/engineering)
	total_positions = 2
	spawn_positions = 2
	selection_color = "#5b4d20"
	economic_power = 5
	minimal_player_age = 7
	access = list(
		access_eva,
		access_engine,
		access_engine_equip,
		access_tech_storage,
		access_maint_tunnels,
		access_external_airlocks,
		access_construction,
		access_atmospherics,
		access_emergency_storage
	)
	min_skill = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_COMPUTER     = SKILL_BASIC,
		SKILL_EVA          = SKILL_BASIC,
		SKILL_CONSTRUCTION = SKILL_ADEPT,
		SKILL_ELECTRICAL   = SKILL_BASIC,
		SKILL_ATMOS        = SKILL_BASIC,
		SKILL_ENGINES      = SKILL_BASIC
	)
	alt_titles = list("Atmospherics Technician" = /decl/outfit/job/shipmap/engineering/atmos_tech)
	event_categories = list(ASSIGNMENT_ENGINEER)

/obj/abstract/landmark/start/shipmap/engineer
	name = "Engineer"