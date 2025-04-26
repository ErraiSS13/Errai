/datum/job/shipmap/head/chief_medical_officer
	title = "Chief Medical Officer"
	hud_icon_state = "hud_cmo"
	supervisors = "the First Officer and the Captain"
	description = "You manage the Medical department, ensuring that the crew remains alive and healthy. \
	The chemistry lab is also your responsibility, as well as making sure that the medical equipment is well stocked \
	and ready to be used at a moment's notice. In addition, you also provide guidence to Command for any medical situations that may arise."
	department_types = list(
		/decl/department/medical,
		/decl/department/command
	)
	outfit_type = /decl/outfit/job/shipmap/medical/chief_medical_officer
	selection_color = "#026865"
	access = list(
		// CMO
		access_cmo,

		// Heads of staff
		access_bridge,
		access_heads,
		access_RC_announce,
		access_keycard_auth,
		access_sec_doors,

		// Medical
		access_medical,
		access_medical_equip,
		access_morgue,
		access_chemistry,
		access_surgery,
		access_eva,
		access_maint_tunnels,
		access_external_airlocks
	)
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_DEVICES  = SKILL_ADEPT,
		SKILL_MEDICAL   = SKILL_EXPERT,
		SKILL_ANATOMY   = SKILL_EXPERT,
		SKILL_CHEMISTRY = SKILL_BASIC
	)
	software_on_spawn = list(
		/datum/computer_file/program/comm,
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/reports
	)
	event_categories = list(ASSIGNMENT_MEDICAL)

/obj/abstract/landmark/start/shipmap/chief_medical_officer
	name = "Chief Medical Officer"


/datum/job/shipmap/medical_doctor
	title = "Medical Doctor"
	hud_icon_state = "hud_doctor"
	supervisors = "the Chief Medical Officer"
	description = "You monitor the health of the crew, treat their injuries, and try to make sure nobody dies."
	department_types = list(/decl/department/medical)
	outfit_type = /decl/outfit/job/shipmap/medical/doctor
	selection_color = "#013d3b"
	economic_power = 8
	total_positions = 2
	spawn_positions = 2
	access = list(
		access_medical,
		access_medical_equip,
		access_surgery,
		access_morgue,
		access_maint_tunnels,
		access_eva,
		access_external_airlocks
	)
	alt_titles = list(
		"Surgeon" = /decl/outfit/job/shipmap/medical/surgeon,
		"Paramedic" = /decl/outfit/job/shipmap/medical/paramedic,
		"Nurse" = /decl/outfit/job/shipmap/medical/nurse
		)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_DEVICES  = SKILL_ADEPT,
		SKILL_EVA      = SKILL_BASIC,
		SKILL_MEDICAL  = SKILL_ADEPT,
		SKILL_ANATOMY  = SKILL_ADEPT
	)
	software_on_spawn = list(
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/reports
	)
	event_categories = list(ASSIGNMENT_MEDICAL)

/obj/abstract/landmark/start/shipmap/medical_doctor
	name = "Medical Doctor"

/*
/datum/job/shipmap/paramedic
	title = "Paramedic"
	supervisors = "the Chief Medical Officer"
	description = "You go to injured patients who may not be able to make it back on their own, \
	treating them, and possibly taking them back to medical if necessary. You may also be called \
	upon to assist in a rescue operation."
	department_types = list(/decl/department/medical)
	selection_color = "#013d3b"
	economic_power = 7
	total_positions = 2
	spawn_positions = 2
	access = list(
		access_medical,
		access_medical_equip,
		access_morgue,
		access_maint_tunnels,
		access_eva,
		access_external_airlocks
	)
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_DEVICES  = SKILL_ADEPT,
		SKILL_EVA      = SKILL_BASIC,
		SKILL_MEDICAL  = SKILL_BASIC,
		SKILL_ANATOMY  = SKILL_BASIC,
		SKILL_PILOT    = SKILL_BASIC
	)
	software_on_spawn = list(
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/camera_monitor
	)
	event_categories = list(ASSIGNMENT_MEDICAL)

/obj/abstract/landmark/start/shipmap/paramedic
	name = "Paramedic"
*/

/datum/job/shipmap/chemist
	title = "Chemist"
	hud_icon_state = "hud_chemist"
	supervisors = "the Chief Medical Officer"
	description = "You carefully mix various substances together in order to create useful chemicals inside the lab."
	department_types = list(/decl/department/medical)
	outfit_type = /decl/outfit/job/shipmap/medical/chemist
	selection_color = "#013d3b"
	economic_power = 8
	total_positions = 2
	spawn_positions = 2
	access = list(
		access_medical,
		access_medical_equip,
		access_chemistry
	)
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_MEDICAL   = SKILL_ADEPT,
		SKILL_CHEMISTRY = SKILL_ADEPT
	)
	software_on_spawn = list(
		/datum/computer_file/program/reports
	)
	event_categories = list(ASSIGNMENT_MEDICAL)

/obj/abstract/landmark/start/shipmap/chemist
	name = "Chemist"
