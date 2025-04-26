/datum/map/shipmap
	emergency_shuttle_called_message	= "Attention all hands: Emergency evacuation procedures are now in effect. Escape pods will open in %ETA%"
	emergency_shuttle_docked_message	= "Attention all hands: Emergency escape pods are now open. You have approximately %ETD% to board the escape pods."
	emergency_shuttle_leaving_dock		= "Attention all hands: The escape pods have been launched, maintaining burn for %ETA%."
	emergency_shuttle_recall_message	= "Attention all hands: Emergency evacuation sequence aborted. Return to normal operating conditions."

	emergency_shuttle_called_sound = 'sound/misc/bloblarm.ogg'



	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"

	command_report_sound = 'sound/AI/commandreport.ogg'
	grid_check_sound = 'sound/AI/poweroff.ogg'
	grid_restored_sound = 'sound/AI/poweron.ogg'
	meteor_detected_sound = 'sound/AI/meteors.ogg'
	radiation_detected_sound = 'sound/AI/radiation.ogg'
	space_time_anomaly_sound = 'sound/AI/spanomalies.ogg'
	unidentified_lifesigns_sound = 'sound/AI/aliens.ogg'

	electrical_storm_moderate_sound = null
	electrical_storm_major_sound = null

	security_state = /decl/security_state/expanded

// Bay / Polaris-styled alert levels.
/decl/security_state/expanded
	all_security_levels = list(
		/decl/security_level/default/code_green,
		/decl/security_level/default/code_orange,
		/decl/security_level/default/code_violet,
		/decl/security_level/default/code_yellow,
		/decl/security_level/default/code_blue,
		/decl/security_level/default/code_red,
		/decl/security_level/default/code_delta
	)
	severe_security_level = /decl/security_level/default/code_delta
	high_security_level = /decl/security_level/default/code_delta // This is kind of dumb but it lets us lower from red with the comms console.
	highest_standard_security_level = /decl/security_level/default/code_delta

// Code Green
/decl/security_level/default/code_green
	down_description = "All threats to the station have passed. Security may not have weapons \
	visible, privacy laws are once again fully enforced."

/datum/alarm_appearance/green
	display_emblem = null // No need to panic the crew with a big ALERT.


// Code Orange
/decl/security_level/default/code_orange
	name = "code orange"

	light_range = 2
	light_power = 1
	light_color_alarm = COLOR_ORANGE
	light_color_class = "font_orange"
	light_color_status_display = COLOR_ORANGE

	alarm_appearance = /datum/alarm_appearance/orange

	up_description = "A major engineering emergency has developed. Engineering personnel are \
	required to report to their supervisor for orders, and non-engineering personnel are \
	required to evacuate any affected areas and obey relevant instructions from \
	engineering staff."
	down_description = "Code orange procedures are now in effect; Engineering personnel are \
	required to report to their supervisor for orders, and non-engineering personnel are \
	required to evacuate any affected areas and obey relevant instructions from \
	engineering staff."

/datum/alarm_appearance/orange
	display_icon = "status_display_lines"
	display_icon_color = COLOR_ORANGE

	display_emblem = "wrench"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_normal"
	alarm_icon_color = COLOR_ORANGE


// Code Violet
/decl/security_level/default/code_violet
	name = "code violet"

	light_range = 2
	light_power = 1
	light_color_alarm = COLOR_VIOLET
	light_color_class = "font_violet"
	light_color_status_display = COLOR_VIOLET

	alarm_appearance = /datum/alarm_appearance/violet

	up_description = "A major medical emergency has developed. Medical personnel are required \
	to report to their supervisor for orders, and non-medical personnel are required to obey \
	all relevant instructions from medical staff."
	down_description = "Code violet procedures are now in effect; Medical personnel are required \
	to report to their supervisor for orders, and non-medical personnel are required to obey \
	relevant instructions from medical staff."

/datum/alarm_appearance/violet
	display_icon = "status_display_lines"
	display_icon_color = COLOR_VIOLET

	display_emblem = "medical"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_normal"
	alarm_icon_color = COLOR_VIOLET

// Code Yellow
/decl/security_level/default/code_yellow
	name = "code yellow"

	light_range = 2
	light_power = 1
	light_color_alarm = COLOR_YELLOW
	light_color_class = "font_yellow"
	light_color_status_display = COLOR_YELLOW

	alarm_appearance = /datum/alarm_appearance/yellow

	up_description = "A minor security emergency has developed. Security personnel are to \
	report to their supervisor for orders and may have weapons visible on their person. \
	Privacy laws are still enforced."
	down_description = "The immediate threat has passed. Security may no longer have weapons \
	drawn at all times, but may continue to have them visible. Random searches are still \
	allowed."

/datum/alarm_appearance/yellow
	display_icon = "status_display_lines"
	display_icon_color = COLOR_YELLOW

	display_emblem = "status_display_alert"
	display_emblem_color = COLOR_WHITE

	alarm_icon = "alarm_normal"
	alarm_icon_color = COLOR_YELLOW


// Code Blue
/decl/security_level/default/code_blue
	up_description = "A major security emergency has developed. Security personnel are to \
	report to their supervisor for orders, are permitted to search staff and facilities, \
	and may have weapons visible on their person."
	down_description = "Code blue procedures are now in effect. Security personnel are to \
	report to their supervisor for orders, are permitted to search staff and facilities, \
	and may have weapons visible on their person."


// Code Red
/decl/security_level/default/code_red
	up_description = "There is an immediate serious threat to the ship. Security may \
	have weapons unholstered at all times. Random searches are allowed and advised."
	down_description = "The self-destruct mechanism has been deactivated, there is still \
	however an immediate serious threat to the ship. Security may have weapons unholstered \
	at all times, random searches are allowed and advised."

	up_description = "A severe emergency has occurred. All staff are to report to their \
	supervisor for orders. All crew should obey orders from relevant emergency personnel. \
	Security personnel are permitted to search staff and facilities, and may have weapons \
	unholstered at any time. Saferooms have been unbolted."
	down_description = "Code Delta has been disengaged. All staff are to report to their \
	supervisor for orders. All crew should obey orders from relevant emergency personnel. \
	Security personnel are permitted to search staff and facilities, and may have weapons \
	unholstered at any time."

/datum/alarm_appearance/red
	display_emblem = "status_display_alert_blinking"


// Code Delta
/decl/security_level/default/code_delta
	// This doesn't actually do anything since delta is currently hardcoded upstream.
	up_description = "The self-destruct mechanism has been engaged. All crew are instructed to \
	obey all instructions given by heads of staff. This is not a drill."

