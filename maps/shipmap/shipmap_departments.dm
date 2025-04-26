/decl/department/command
	name = "Command"
	colour = "#800080"
	display_priority = 10
	display_color = "#ccccff"

/obj/machinery/network/pager/command
	department = /decl/department/command


/decl/department/engineering
	name = "Engineering"
	announce_channel = "Engineering"
	colour = "#ffa500"
	display_priority = 6
	display_color = "#fff5cc"

/obj/item/robot_module/engineering
	associated_department = /decl/department/engineering

/obj/machinery/network/pager/engineering
	department = /decl/department/engineering


/decl/department/medical
	name = "Medical"
	goals = list(/datum/goal/department/medical_fatalities)
	announce_channel = "Medical"
	display_priority = 5
	colour = "#008000"
	display_color = "#ffeef0"

/obj/item/robot_module/medical
	associated_department = /decl/department/medical

/obj/machinery/network/pager/medical
	department = /decl/department/medical


/decl/department/supply
	name = "Supply"
	display_priority = 2
	colour = "#bb9040"
	display_color = "#f0e68c"

/obj/machinery/network/pager/cargo
	department = /decl/department/supply


/decl/department/research
	name = "Research"
//	goals = list(/datum/goal/department/extract_slime_cores)
	display_priority = 4
	colour = "#a65ba6"
	display_color = "#e79fff"

/obj/item/robot_module/research
	associated_department = /decl/department/research

/obj/machinery/network/pager/science
	department = /decl/department/research


/decl/department/security
	name = "Security"
	announce_channel = "Security"
	colour = "#dd0000"
	display_priority = 3
	display_color = "#ffddf0"

/obj/item/robot_module/security
	associated_department = /decl/department/security

/obj/machinery/network/pager/security
	department = /decl/department/security


/decl/department/service
	name = "Service"
	display_priority = 1
	colour = "#88b764"
	display_color = "#d0f0c0"


/decl/department/civilian
	name = "Civilian"
	display_priority = 0
	display_color = "#dddddd"


/decl/department/miscellaneous
	name = "Misc"
	display_priority = -1
	display_color = "#888888"


/decl/department/synthetics
	name = "Synthetics"
	display_priority = -2
	display_color = "#666666"