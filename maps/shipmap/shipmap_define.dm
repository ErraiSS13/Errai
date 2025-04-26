/datum/map/shipmap
	name = "Wayward Star"
	full_name = "EES Wayward Star"
	path = "shipmap" // Is this a typepath, UID, or an actual file path?

	station_name  = "EES Wayward Star"
	station_short = "Wayward Star"
	dock_name     = "the Errai System"
	boss_name     = "Errai Expeditions"
	boss_short    = "Errai"
	company_name  = "Errai Expeditions"
	company_short = "EE"

	system_name   = "Errai"
	ground_noun = "deck"

	overmap_ids = list(OVERMAP_ID_SPACE)

	lobby_screens = list(
		'maps/example/example_lobby.png'
	)

	allowed_latejoin_spawns = list(
		/decl/spawnpoint/cryo,
		/decl/spawnpoint/cyborg,
	)
	default_spawn = /decl/spawnpoint/cryo

	evac_controller_type = /datum/evacuation_controller/starship

	starting_money = 5000
	department_money = 0

	// Hopefully temporary.
	num_exoplanets = 2
	away_site_budget = 3


	default_telecomms_channels = list(
		COMMON_FREQUENCY_DATA,
		list("name" = "Entertainment", "key" = "z", "frequency" = 1461, "color" = COMMS_COLOR_ENTERTAIN, "span_class" = CSS_CLASS_RADIO, "receive_only" = TRUE),
		list("name" = "Command",       "key" = "c", "frequency" = 1353, "color" = COMMS_COLOR_COMMAND,   "span_class" = "comradio", "secured" = list(access_bridge)),
		list("name" = "Security",      "key" = "s", "frequency" = 1359, "color" = COMMS_COLOR_SECURITY,  "span_class" = "secradio", "secured" = list(access_security)),
		list("name" = "Engineering",   "key" = "e", "frequency" = 1357, "color" = COMMS_COLOR_ENGINEER,  "span_class" = "engradio", "secured" = list(access_engine)),
		list("name" = "Medical",       "key" = "m", "frequency" = 1355, "color" = COMMS_COLOR_MEDICAL,   "span_class" = "medradio", "secured" = list(access_medical)),
		list("name" = "Science",       "key" = "n", "frequency" = 1351, "color" = COMMS_COLOR_SCIENCE,   "span_class" = "sciradio", "secured" = list(access_research)),
		list("name" = "Service",       "key" = "v", "frequency" = 1349, "color" = COMMS_COLOR_SERVICE,   "span_class" = "srvradio", "secured" = list(access_bar)),
		list("name" = "Supply",        "key" = "u", "frequency" = 1347, "color" = COMMS_COLOR_SUPPLY,    "span_class" = "supradio", "secured" = list(access_cargo)),
		list("name" = "Hailing",       "key" = "x", "frequency" = 1361, "color" = COMMS_COLOR_EXPLORER , "span_class" = "EXPradio"),
		list("name" = "AI Private",    "key" = "p", "frequency" = 1343, "color" = COMMS_COLOR_AI,        "span_class" = "airadio",  "secured" = list(access_ai_upload))
	)


/datum/map/shipmap/get_map_info()
	return "You're aboard the <b>[station_name]</b>, an interstellar starship capable of deep space operations, owned and operated by <b>[company_name]</b>. \
	Today, the vessel is operating within <b>[system_name]</b>."
