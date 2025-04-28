/datum/job/shipmap/steward
	title = "Steward"
	hud_icon_state = "hud_steward"
	supervisors = "the First Officer"
	description = "You prepare meals and drinks, and serve them to the crew, and any guests or passengers that happen to be onboard."
	selection_color = "#88b764"
	department_types = list(/decl/department/service)
	outfit_type = /decl/outfit/job/shipmap/service/steward
	total_positions = 3
	spawn_positions = 3
	economic_power = 3
	access = list(
		access_bar,
		access_kitchen,
		access_hydroponics
	)
	alt_titles = list(
		"Bartender" = /decl/outfit/job/shipmap/service/bartender,
		"Cook" = /decl/outfit/job/shipmap/service/cook,
		"Chef" = /decl/outfit/job/shipmap/service/chef
	)
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_COOKING = SKILL_BASIC,
		SKILL_BOTANY = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC
	)

/obj/abstract/landmark/start/shipmap/steward
	name = "Steward"


/datum/job/shipmap/janitor
	title = "Janitor"
	hud_icon_state = "hud_janitor"
	supervisors = "the First Officer"
	description = "You keep the ship clean and looking good, by mopping the floors, removing clutter, and changing lightbulbs."
	selection_color = "#88b764"
	department_types = list(/decl/department/service)
	outfit_type = /decl/outfit/job/shipmap/service/janitor
	total_positions = 2
	spawn_positions = 2
	economic_power = 2
	access = list(
		access_janitor,
		access_maint_tunnels,
		access_emergency_storage,

		// Basic access.
		access_engine,
		access_research,
		access_sec_doors,
		access_medical,
		access_cargo
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_HAULING = SKILL_BASIC
	)

/obj/abstract/landmark/start/shipmap/janitor
	name = "Janitor"


/datum/job/shipmap/counselor
	title = "Counselor"
	hud_icon_state = "hud_counselor"
	supervisors = "the First Officer"
	description = "You tend to the crew's mental, and possibly spiritual, well being."
	selection_color = "#88b764"
	department_types = list(/decl/department/service)
	outfit_type = /decl/outfit/job/shipmap/service/counselor
	total_positions = 1
	spawn_positions = 1
	economic_power = 3
	is_holy = TRUE
	access = list(access_chapel_office)
	alt_titles = list(
		"Psychologist" = /decl/outfit/job/shipmap/service/psychologist,
		"Chaplain" = /decl/outfit/job/shipmap/service/chaplain
	)

/obj/abstract/landmark/start/shipmap/counselor
	name = "Counselor"