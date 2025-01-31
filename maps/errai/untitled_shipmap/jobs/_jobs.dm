// Defaults for jobs on the ship.
/datum/job/shipmap
	abstract_type = /datum/job/shipmap
	hud_icon = 'maps/errai/untitled_shipmap/shipmap_hud.dmi'
	skill_points = 20
	min_skill = list(SKILL_LITERACY = SKILL_ADEPT)
	max_skill = list(
		SKILL_LITERACY = SKILL_MAX,
		SKILL_FINANCE = SKILL_MAX,
		SKILL_EVA = SKILL_MAX,
//		SKILL_MECH = HAS_PERK,
		SKILL_PILOT = SKILL_MAX,
		SKILL_HAULING = SKILL_MAX,
		SKILL_COMPUTER = SKILL_MAX,
		SKILL_BOTANY = SKILL_MAX,
		SKILL_COOKING = SKILL_MAX,
		SKILL_COMBAT = SKILL_MAX,
		SKILL_WEAPONS = SKILL_MAX,
		SKILL_FORENSICS = SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL = SKILL_MAX,
		SKILL_ATMOS = SKILL_MAX,
		SKILL_ENGINES = SKILL_MAX,
		SKILL_DEVICES = SKILL_MAX,
		SKILL_SCIENCE = SKILL_MAX,
		SKILL_MEDICAL = SKILL_MAX,
		SKILL_ANATOMY = SKILL_MAX,
		SKILL_CHEMISTRY = SKILL_MAX
	)

// Defaults for Heads of Staff.
/datum/job/shipmap/head
	abstract_type = /datum/job/shipmap/head
	total_positions = 1
	spawn_positions = 1
	skill_points = 30
	minimal_player_age = 14
	ideal_character_age = 40
	economic_power = 10
	head_position = TRUE
	req_admin_notify = TRUE
	guestbanned = TRUE
	not_random_selectable = TRUE
	must_fill = TRUE