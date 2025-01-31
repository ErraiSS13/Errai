/datum/job/shipmap/assistant
	title = "Assistant"
	hud_icon_state = "hud_assistant"
	supervisors = "literally everyone"
	total_positions = -1
	spawn_positions = -1
	department_types = list(/decl/department/civilian)
	outfit_type = /decl/outfit/job/shipmap/civilian/assistant
	economic_power = 1
	access = list()
	minimal_access = list()
	alt_titles = list(
		"Passenger" = /decl/outfit/job/shipmap/civilian/passenger,
		"Journalist" = /decl/outfit/job/shipmap/civilian/journalist
	)
//	event_categories = list(ASSIGNMENT_GARDENER, ASSIGNMENT_JANITOR)

/datum/job/shipmap/assistant/get_access()
	if(get_config_value(/decl/config/toggle/assistant_maint))
		return list(access_maint_tunnels)
	else
		return list()

/obj/abstract/landmark/start/shipmap/assistant
	name = "Assistant"
