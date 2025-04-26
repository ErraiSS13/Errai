/datum/job/shipmap/head/research_director
	title = "Research Director"
	hud_icon_state = "hud_rd"
	supervisors = "the First Officer and the Captain"
	description = "You manage the Research department, which supports the ship in technological matters. \
	Ensure that your subordinates stay productive and don't end up dooming themselves or the ship in the persuit of science. \
	You also offer your expertise to the Command staff in regards to unusual phenomena observed, or research in general. \
	You and the Chief Engineer also jointly manage the ship's artificial intelligence and the robots they control."
	department_types = list(
		/decl/department/research,
		/decl/department/command
	)
	outfit_type = /decl/outfit/job/shipmap/research/research_director
	selection_color = "#ad6bad"
	access = list(
		// RD
		access_rd,
		access_teleporter,
		access_ai_upload,
		access_network,
		access_tcomsat,

		// Heads of staff
		access_bridge,
		access_heads,
		access_RC_announce,
		access_keycard_auth,
		access_sec_doors,

		// Sci
		access_tox,
		access_tox_storage,
		access_research,
		access_robotics,
		access_xenobiology,
		access_xenoarch,
		access_tech_storage,
		access_hydroponics,
		access_eva
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_COMPUTER = SKILL_BASIC,
		SKILL_FINANCE  = SKILL_ADEPT,
		SKILL_BOTANY   = SKILL_BASIC,
		SKILL_ANATOMY  = SKILL_BASIC,
		SKILL_DEVICES  = SKILL_BASIC,
		SKILL_SCIENCE  = SKILL_ADEPT
	)
	event_categories = list(ASSIGNMENT_SCIENTIST)

/obj/abstract/landmark/start/shipmap/research_director
	name = "Research Director"


/datum/job/shipmap/scientist
	title = "Scientist"
	hud_icon_state = "hud_scientist"
	supervisors = "the Research Director"
	description = "You support the ship with the power of science." // Write something better later.
	selection_color = "#633d63"
	department_types = list(/decl/department/research)
	outfit_type = /decl/outfit/job/shipmap/research/scientist
	total_positions = 2
	spawn_positions = 2
	economic_power = 8
	access = list(
		access_robotics,
		access_tox,
		access_tox_storage,
		access_research,
		access_xenobiology,
		access_xenoarch,
		access_hydroponics,
		access_tech_storage,
		access_eva
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_COMPUTER = SKILL_BASIC,
		SKILL_DEVICES  = SKILL_BASIC,
		SKILL_SCIENCE  = SKILL_ADEPT
	)
	event_categories = list(ASSIGNMENT_SCIENTIST)

/obj/abstract/landmark/start/shipmap/scientist
	name = "Scientist"


/datum/job/shipmap/roboticist
	title = "Roboticist"
	hud_icon_state = "hud_roboticist"
	supervisors = "the Research Director"
	description = "You build and maintain the various kinds of robots that may be onboard the ship. \
	You may also manufacture prosthetics and exosuits."
	selection_color = "#633d63"
	department_types = list(/decl/department/research)
	outfit_type = /decl/outfit/job/shipmap/research/roboticist
	total_positions = 2
	spawn_positions = 2
	economic_power = 7
	access = list(
		access_robotics,
		access_tech_storage,
		access_research
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_COMPUTER = SKILL_ADEPT,
		SKILL_DEVICES  = SKILL_ADEPT,
		SKILL_EVA      = SKILL_ADEPT,
		SKILL_ANATOMY  = SKILL_ADEPT,
		SKILL_MECH     = HAS_PERK
	)

/obj/abstract/landmark/start/shipmap/roboticist
	name = "Roboticist"
