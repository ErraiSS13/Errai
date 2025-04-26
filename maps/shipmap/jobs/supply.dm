/datum/job/shipmap/head/quartermaster
	title = "Quartermaster"
	hud_icon_state = "hud_qm"
	supervisors = "the Captain and the First Officer"
	description = "You manage the Supply department, making sure that the ship is well stocked and that the ship's shuttles \
	are maintained. You are also in charge of the ship's finances, and oversee trades between the ship and everyone else."
	selection_color = "#9b633e"
	outfit_type = /decl/outfit/job/shipmap/supply/quartermaster
	department_types = list(
		/decl/department/supply,
		/decl/department/command
	)
	access = list(
		// QM
		access_qm,
		access_heads_vault,

		// Heads of Staff
		access_bridge,
		access_heads,
		access_RC_announce,
		access_keycard_auth,
		access_sec_doors,

		// Supply
		access_cargo,
		access_mining,
		access_cargo_hold,
		access_mailsorting,
		access_tech_storage,
		access_emergency_storage,
		access_maint_tunnels,
		access_external_airlocks,
		access_eva,
		access_shuttle_pilot
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
	    SKILL_FINANCE  = SKILL_ADEPT,
	    SKILL_HAULING  = SKILL_BASIC,
	    SKILL_EVA      = SKILL_BASIC,
	    SKILL_PILOT    = SKILL_BASIC,
		SKILL_ATMOS    = SKILL_BASIC
	)
	software_on_spawn = list(
		/datum/computer_file/program/supply,
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)

/obj/abstract/landmark/start/shipmap/quartermaster
	name = "Quartermaster"


/datum/job/shipmap/supply_technician
	title = "Supply Technician"
	hud_icon_state = "hud_supply_tech"
	supervisors = "the Quartermaster"
	description = "You move cargo to where it needs to go, whether that's to a particular department, loading it onto or unloading \
	it from a shuttle, or moving it into or out of storage. You also help maintain the shuttles inside of the Hangar Bay, by keeping \
	them clean, fueled up, and doing minor repairs. Finally, you may conduct trade between the ship and the outside world in order \
	to acquire more supplies or to fill the ship's account."
	selection_color = "#7a4f33"
	outfit_type = /decl/outfit/job/shipmap/supply/supply_tech
	department_types = list(/decl/department/supply)
	total_positions = 2
	spawn_positions = 2
	economic_power = 3
	access = list(
		access_cargo,
		access_cargo_hold,
		access_mailsorting,
		access_mining,
		access_maint_tunnels,
		access_tech_storage,
		access_emergency_storage,
		access_eva
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE = SKILL_BASIC,
		SKILL_HAULING = SKILL_BASIC,
		SKILL_ATMOS = SKILL_BASIC
	)
	software_on_spawn = list(
		/datum/computer_file/program/supply,
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)

/obj/abstract/landmark/start/shipmap/supply_technician
	name = "Supply Technician"


/datum/job/shipmap/miner
	title = "Miner"
	hud_icon_state = "hud_miner"
	supervisors = "the Quartermaster"
	description = "You extract valuable ore from remote locations, bring it back, and refine it into useful materials for everyone else."
	selection_color = "#7a4f33"
	outfit_type = /decl/outfit/job/shipmap/supply/miner
	department_types = list(/decl/department/supply)
	total_positions = 2
	spawn_positions = 2
	economic_power = 5
	access = list(
		access_cargo,
		access_cargo_hold,
		access_mining,
		access_maint_tunnels,
		access_eva,
		access_external_airlocks
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_HAULING  = SKILL_ADEPT,
	    SKILL_EVA      = SKILL_BASIC,
		SKILL_PILOT    = SKILL_BASIC
	)
	software_on_spawn = list(
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)

/obj/abstract/landmark/start/shipmap/miner
	name = "Miner"


/datum/job/shipmap/shuttle_pilot
	title = "Shuttle Pilot"
	hud_icon_state = "hud_shuttle_pilot"
	supervisors = "the Quartermaster"
	description = "You pilot one of the ship's shuttles, moving passengers and cargo to where they need to go, \
	and making sure that everyone and everything makes it back in one piece."
	selection_color = "#7a4f33"
	outfit_type = /decl/outfit/job/shipmap/supply/shuttle_pilot
	department_types = list(/decl/department/supply)
	total_positions = 2
	spawn_positions = 2
	economic_power = 6
	minimal_player_age = 7
	access = list(
		access_shuttle_pilot,
		access_eva,
		access_cargo,
		access_external_airlocks
	)
	min_skill = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_COMPUTER     = SKILL_BASIC,
		SKILL_EVA          = SKILL_BASIC,
		SKILL_PILOT        = SKILL_ADEPT,
		SKILL_ATMOS        = SKILL_BASIC
	)
	software_on_spawn = list(
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)

/obj/abstract/landmark/start/shipmap/shuttle_pilot
	name = "Shuttle Pilot"
