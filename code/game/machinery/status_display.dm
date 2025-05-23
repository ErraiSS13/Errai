#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Small Fonts"
#define SCROLL_SPEED 2

// Status display
// (formerly Countdown timer display)

// Use to show shuttle ETA/ETD times
// Alert status
// And arbitrary messages set by comms computer
/obj/machinery/status_display
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	name = "status display"
	layer = ABOVE_WINDOW_LAYER
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	anchored = TRUE
	density = FALSE
	idle_power_usage = 10
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":32}, "WEST":{"x":-32}}'
	var/mode = 1	// 0 = Blank
					// 1 = Shuttle timer
					// 2 = Arbitrary message(s)
					// 3 = alert picture
					// 4 = Supply shuttle timer

	var/picture_state = "greenalert" // icon_state of alert picture
	var/message1 = ""                // message line 1
	var/message2 = ""                // message line 2
	var/index1                       // display index for scrolling messages or 0 if non-scrolling
	var/index2
	var/picture = null

	var/frequency = 1435		// radio frequency

	var/friendc = 0      // track if Friend Computer mode
	var/ignore_friendc = 0

	maptext_height = 26
	maptext_width = 32
	maptext_y = -1

	var/const/CHARS_PER_LINE = 5
	var/const/STATUS_DISPLAY_BLANK = 0
	var/const/STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME = 1
	var/const/STATUS_DISPLAY_MESSAGE = 2
	var/const/STATUS_DISPLAY_ALERT = 3
	var/const/STATUS_DISPLAY_TIME = 4
	var/const/STATUS_DISPLAY_IMAGE = 5
	var/const/STATUS_DISPLAY_CUSTOM = 99

/obj/machinery/status_display/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	return ..()

// register for radio system
/obj/machinery/status_display/Initialize()
	. = ..()
	if(radio_controller)
		radio_controller.add_object(src, frequency)

// timed process
/obj/machinery/status_display/Process()
	if(stat & NOPOWER)
		remove_display()
		return
	update()

/obj/machinery/status_display/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	set_picture("ai_bsod")
	..(severity)

// set what is displayed
/obj/machinery/status_display/proc/update()
	remove_display()
	if(friendc && !ignore_friendc)
		set_picture("ai_friend")
		return 1

	switch(mode)
		if(STATUS_DISPLAY_BLANK)	//blank
			return 1
		if(STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME)				//emergency shuttle timer
			if(SSevac.evacuation_controller)
				if(SSevac.evacuation_controller.is_prepared())
					message1 = "-ETD-"
					if (SSevac.evacuation_controller.waiting_to_leave())
						message2 = "Launch"
					else
						message2 = get_shuttle_timer()
						if(length(message2) > CHARS_PER_LINE)
							message2 = "Error"
					update_display(message1, message2)
				else if(SSevac.evacuation_controller.has_eta())
					message1 = "-ETA-"
					message2 = get_shuttle_timer()
					if(length(message2) > CHARS_PER_LINE)
						message2 = "Error"
					update_display(message1, message2)
			else
				update_display("ERROR", "ERROR")
			return 1
		if(STATUS_DISPLAY_MESSAGE)	//custom messages
			var/line1
			var/line2

			if(!index1)
				line1 = message1
			else
				line1 = copytext(message1+"|"+message1, index1, index1+CHARS_PER_LINE)
				var/message1_len = length(message1)
				index1 += SCROLL_SPEED
				if(index1 > message1_len)
					index1 -= message1_len

			if(!index2)
				line2 = message2
			else
				line2 = copytext(message2+"|"+message2, index2, index2+CHARS_PER_LINE)
				var/message2_len = length(message2)
				index2 += SCROLL_SPEED
				if(index2 > message2_len)
					index2 -= message2_len
			update_display(line1, line2)
			return 1
		if(STATUS_DISPLAY_ALERT)
			display_alert()
			return 1
		if(STATUS_DISPLAY_TIME)
			message1 = "TIME"
			message2 = stationtime2text()
			update_display(message1, message2)
			return 1
		if(STATUS_DISPLAY_IMAGE)
			set_picture(picture_state)
			return 1
	return 0

/obj/machinery/status_display/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(mode != STATUS_DISPLAY_BLANK && mode != STATUS_DISPLAY_ALERT)
		. += "The display says:<br>\t[sanitize(message1)]<br>\t[sanitize(message2)]"
	if(mode == STATUS_DISPLAY_ALERT)
		var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
		. += "The current alert level is [security_state.current_security_level.name]."

/obj/machinery/status_display/proc/set_message(m1, m2)
	if(m1)
		index1 = (length(m1) > CHARS_PER_LINE)
		message1 = m1
	else
		message1 = ""
		index1 = 0

	if(m2)
		index2 = (length(m2) > CHARS_PER_LINE)
		message2 = m2
	else
		message2 = ""
		index2 = 0

/obj/machinery/status_display/proc/display_alert()
	remove_display()

	var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
	var/decl/security_level/sec_level = security_state.current_security_level

	set_light(sec_level.light_range, sec_level.light_power, sec_level.light_color_status_display)

	if(sec_level.alarm_appearance.display_icon)
		var/image/alert1 = image(sec_level.icon, sec_level.alarm_appearance.display_icon)
		alert1.color = sec_level.alarm_appearance.display_icon_color
		overlays |= alert1

	if(sec_level.alarm_appearance.display_icon_twotone)
		var/image/alert2 = image(sec_level.icon, sec_level.alarm_appearance.display_icon_twotone)
		alert2.color = sec_level.alarm_appearance.display_icon_twotone_color
		overlays |= alert2

	if(sec_level.alarm_appearance.display_emblem)
		var/image/alert3 = image(sec_level.icon, sec_level.alarm_appearance.display_emblem)
		alert3.color = sec_level.alarm_appearance.display_emblem_color
		overlays |= alert3

/obj/machinery/status_display/proc/set_picture(state)
	remove_display()
	if(!picture || picture_state != state)
		picture_state = state
		picture = image('icons/obj/status_display.dmi', icon_state=picture_state)
	overlays |= picture
	set_light(2, 0.5, COLOR_WHITE)

/obj/machinery/status_display/proc/update_display(line1, line2)
	line1 = uppertext(line1)
	line2 = uppertext(line2)
	var/new_text = {"<div style="font-size:[FONT_SIZE];color:[FONT_COLOR];font:'[FONT_STYLE]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
	if(maptext != new_text)
		maptext = new_text
	set_light(2, 0.5, COLOR_WHITE)

/obj/machinery/status_display/proc/get_shuttle_timer()
	var/timeleft = SSevac.evacuation_controller ? SSevac.evacuation_controller.get_eta() : 0
	if(timeleft < 0)
		return ""
	return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"

/obj/machinery/status_display/proc/get_supply_shuttle_timer()
	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
	if (!shuttle)
		return "Error"

	if(shuttle.has_arrive_time())
		var/timeleft = round((shuttle.arrive_time - world.time) / 10,1)
		if(timeleft < 0)
			return "Late"
		return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
	return ""

/obj/machinery/status_display/proc/remove_display()
	if(overlays.len)
		overlays.Cut()
	if(maptext)
		maptext = ""
	set_light(0)

/obj/machinery/status_display/receive_signal(datum/signal/signal)
	switch(signal.data["command"])
		if("blank")
			mode = STATUS_DISPLAY_BLANK

		if("shuttle")
			mode = STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME

		if("message")
			mode = STATUS_DISPLAY_MESSAGE
			set_message(signal.data["msg1"], signal.data["msg2"])

		if("alert")
			mode = STATUS_DISPLAY_ALERT

		if("time")
			mode = STATUS_DISPLAY_TIME

		if("image")
			mode = STATUS_DISPLAY_IMAGE
			set_picture(signal.data["picture_state"])
	update()

#undef FONT_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef SCROLL_SPEED