/datum/map/shipmap/send_welcome()
	var/obj/effect/overmap/visitable/ship/our_ship = SSshuttle.ship_by_type(/obj/effect/overmap/visitable/ship/main_ship)

	if(!our_ship)
		return

	var/list/lines = list()
	lines += "<center>"
	lines += "<h1>Automated Status Report:</h1>"
	lines += "Report generated on [stationdate2text()] at [stationtime2text()]"
	lines += "</center>"
	lines += "<hr>"


	lines += "<h2>System Information:</h2>"
	lines += "Current system:"
	lines += "<b>[global.using_map.system_name || "Unknown"]</b>"
	lines += ""

	// Sadly the unicode symbols don't seem to work.
//	lines += "System hierarchy:"
//	lines += "┓"
//	lines += "┣* Errai"
//	lines += "┃┗O Tadmor"
//	lines += "┗* Gamma Cephei B"
//	lines += ""

//	lines += "Distance from Sol:"
//	lines += "<b>44.98 ly</b>"
//	lines += ""

//	lines += "Distance from Errai:"
//	lines += "<b>0 ly</b>"
//	lines += ""

//	lines += "Governing authorities:"
//	lines += "<b>Todo</b>"
//	lines += ""


	lines += "<h2>Logistical Information:</h2>"
	lines += "Current mission duration:"
	lines += "<b>0 days</b>" // TODO
	lines += ""

	lines += "Funds available:"
	lines += "<b>[station_account.format_value_by_currency(station_account.money)]</b>"
	lines += ""

	lines += "<h2>Operational Information:</h2>"
	lines += "Current coordinates on system charts:"
	lines += "<b>[our_ship.x],[our_ship.y]</b>"
	lines += ""

	var/list/space_things = list()
	var/list/distress_calls = list()
	for(var/zlevel in global.overmap_sectors)
		var/obj/effect/overmap/visitable/O = global.overmap_sectors[zlevel]
		if(O.name == our_ship.name)
			continue
		if(istype(O, /obj/effect/overmap/visitable/ship/landable)) //Don't show shuttles
			continue
		if(O.hide_from_reports)
			continue
		space_things += O

	if(length(space_things))
		lines += "Potential points of interest detected:"
		for(var/obj/effect/overmap/visitable/O in space_things)
			var/location_desc = " at present co-ordinates."
			if(O.loc != our_ship.loc)
				var/bearing = round(90 - Atan2(O.x - our_ship.x, O.y - our_ship.y), 5)
				if(bearing < 0)
					bearing += 360
				location_desc = ", bearing [bearing]."
			if(O.has_distress_beacon)
				distress_calls += "[O.has_distress_beacon][location_desc]"
			lines += "<li>\A <b>[O.name]</b>[location_desc]</li>"
		lines += "<br>"

	else
		lines += "No potential points of interest detected."
		lines += ""

	if(length(distress_calls))
		lines += "<b>Distress calls logged:</b><br>[jointext(distress_calls, "<br>")]<br>"
		lines += jointext(distress_calls, "<br>")
	else
		lines += "No distress calls logged."

	post_comm_message("Automated Status Report", lines.Join("<br>"))
	minor_announcement.Announce(message = "New [global.using_map.station_short] Update available at all communication consoles.")

