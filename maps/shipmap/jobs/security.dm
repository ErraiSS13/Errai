/datum/job/shipmap/head/chief_of_security
	title = "Chief of Security"
	hud_icon_state = "hud_cos"
	supervisors = "the First Officer and the Captain"
	description = "You manage the Security department."
	selection_color = "#8e2929"
	department_types = list(
		/decl/department/security,
		/decl/department/command
	)
	outfit_type = /decl/outfit/job/shipmap/security/chief_of_security
	access = list(
		// CoS
		access_hos,
		access_armory,
		access_all_personal_lockers,

		// Heads of staff
		access_bridge,
		access_heads,
		access_RC_announce,
		access_keycard_auth,

		// Sec
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_forensics_lockers,
		access_maint_tunnels,
		access_emergency_storage,
		access_external_airlocks,

		// Basic access
		access_research,
		access_engine,
		access_medical,
		access_construction,
		access_cargo
	)
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_ADEPT,
		SKILL_FORENSICS = SKILL_BASIC
	)
	software_on_spawn = list(
		/datum/computer_file/program/comm,
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/reports
	)
	event_categories = list(ASSIGNMENT_SECURITY)

/obj/abstract/landmark/start/shipmap/chief_of_security
	name = "Chief of Security"

/*
/datum/job/shipmap/detective
	title = "Detective"
	supervisors = "the Chief of Security"
	selection_color = "#601c1c"
	department_types = list(/decl/department/security)
	total_positions = 1
	spawn_positions = 1
	economic_power = 6
	guestbanned = TRUE
	access = list(
		access_security,
		access_sec_doors,
		access_brig,
		access_maint_tunnels,
		access_morgue,
		access_emergency_storage,
		access_forensics_lockers
	)
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_COMPUTER  = SKILL_BASIC,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_BASIC,
		SKILL_FORENSICS = SKILL_ADEPT
	)
	software_on_spawn = list(
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor
	)

/obj/abstract/landmark/start/shipmap/detective
	name = "Detective"
*/

/datum/job/shipmap/security_officer
	title = "Security Officer"
	hud_icon_state = "hud_security"
	supervisors = "the Chief of Security"
	selection_color = "#601c1c"
	department_types = list(/decl/department/security)
	outfit_type = /decl/outfit/job/shipmap/security/security_officer
	total_positions = 2
	spawn_positions = 2
	economic_power = 4
	guestbanned = TRUE
	access = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_maint_tunnels,
		access_emergency_storage,
		access_external_airlocks,
		access_forensics_lockers
	)
	min_skill = list(
		SKILL_LITERACY  = SKILL_BASIC,
		SKILL_EVA       = SKILL_BASIC,
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_ADEPT,
		SKILL_FORENSICS = SKILL_BASIC
	)
	software_on_spawn = list(
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/camera_monitor
	)
	alt_titles = list("Detective" = /decl/outfit/job/shipmap/security/detective)
	event_categories = list(ASSIGNMENT_SECURITY)


/obj/abstract/landmark/start/shipmap/security_officer
	name = "Security Officer"