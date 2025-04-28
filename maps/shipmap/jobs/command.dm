/datum/job/shipmap/head/captain
	title = "Captain"
	hud_icon_state = "hud_captain"
	supervisors = "the Company, and the local authority"
	description = "You have been granted command of the ship, and have been entrusted with the lives of the crew onboard it. \
	It is your job to focus on the 'big picture', giving directives for your Heads of Staff and the crew to execute \
	that will further the ship's mission. You do not hold absolute power, and are bound to both Company Policy, \
	and the laws imposed upon you by the local government, just like everyone else."
	selection_color = "#1d1d4f"
	department_types = list(/decl/department/command)
	outfit_type = /decl/outfit/job/shipmap/command/captain
	economic_power = 20
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_WEAPONS  = SKILL_ADEPT,
		SKILL_SCIENCE  = SKILL_ADEPT,
		SKILL_PILOT    = SKILL_ADEPT
	)
	access = list()
	minimal_access = list()
	minimal_player_age = 21
	ideal_character_age = 70

/datum/job/shipmap/head/captain/get_access()
	return get_all_station_access()

/obj/abstract/landmark/start/shipmap/captain
	name = "Captain"


/datum/job/shipmap/head/first_officer
	title = "First Officer"
	hud_icon_state = "hud_fo"
	supervisors = "the Captain"
	description = "You are the second-in-command onboard the ship, tasked with executing the Captain's will by delegating down \
	the chain as required, and managing any crewmembers who lack a direct superior. Modifying ID cards and crew records is \
	also your responsibility. You out-rank the other Heads of Staff, however you should defer to them on matters relating to their departments \
	Finally, you are first in line to assume command if the Captain is unavailable."
	selection_color = "#2f2f7f"
	department_types = list(/decl/department/command, /decl/department/service, /decl/department/civilian)
	outfit_type = /decl/outfit/job/shipmap/command/first_officer
	economic_power = 10
	ideal_character_age = 50
	access = list()
	minimal_access = list()
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_WEAPONS  = SKILL_BASIC,
		SKILL_FINANCE  = SKILL_ADEPT,
		SKILL_PILOT    = SKILL_ADEPT
	)

/datum/job/shipmap/head/first_officer/get_access()
	return get_all_station_access() - access_captain

/obj/abstract/landmark/start/shipmap/first_officer
	name = "First Officer"

/*
/datum/job/shipmap/deck_cadet
	title = "Deck Cadet"
	supervisors = "the First Mate and the Captain"
	description = "You assist the Heads of Staff and the Pilot with running the ship, typically from the ship's bridge. \
	You are not a Head of Staff, and have no real authority."
//	outfit_type = /decl/outfit/job/shipmap/first_officer
	department_types = list(/decl/department/command)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#2f2f7f"
	minimal_player_age = 7
	economic_power = 5
	access = list(
		access_bridge,
		access_RC_announce,
		access_keycard_auth
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_PILOT    = SKILL_ADEPT
	)
	software_on_spawn = list(
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)

/obj/abstract/landmark/start/shipmap/deck_cadet
	name = "Deck Cadet"
*/

/datum/job/shipmap/ship_pilot
	title = "Ship Pilot"
	hud_icon_state = "hud_ship_pilot"
	supervisors = "the First Officer and the Captain"
	description = "You fly the ship around the system, avoiding hazardous conditions that may damage the vessel, \
	and keeping an eye out for anything that looks interesting. You are not a Head of Staff, and have no real authority."
	department_types = list(/decl/department/command)
	outfit_type = /decl/outfit/job/shipmap/command/ship_pilot
	total_positions = 2
	spawn_positions = 2
	selection_color = "#2f2f7f"
	minimal_player_age = 7
	economic_power = 8
	access = list(
		access_bridge,
		access_RC_announce,
		access_heads,
		access_eva
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_PILOT = SKILL_EXPERT
	)
	software_on_spawn = list(
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)

/obj/abstract/landmark/start/shipmap/ship_pilot
	name = "Ship Pilot"