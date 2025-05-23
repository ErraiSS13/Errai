/obj/machinery/computer/drone_control
	name = "Maintenance Drone Control"
	desc = "Used to monitor the drone population and the assembler that services them."
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "power_key"
	icon_screen = "power"
	req_access = list(access_engine_equip)

	//Used when pinging drones.
	var/drone_call_area = "Engineering"
	//Used to enable or disable drone fabrication.
	var/obj/machinery/drone_fabricator/dronefab

/obj/machinery/computer/drone_control/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/computer/drone_control/interact(mob/user)
	user.set_machine(src)
	var/dat
	dat += "<B>Maintenance Units</B><BR>"

	for(var/mob/living/silicon/robot/drone/D in global.silicon_mob_list)
		if(D.z != src.z)
			continue
		dat += "<BR>[D.real_name] ([D.stat == DEAD ? "<font color='red'>INACTIVE</FONT>" : "<font color='green'>ACTIVE</FONT>"])"
		dat += "<font dize = 9><BR>Cell charge: [D.cell.charge]/[D.cell.maxcharge]."
		dat += "<BR>Currently located in: [get_area_name(D)]."
		dat += "<BR><A href='byond://?src=\ref[src];resync=\ref[D]'>Resync</A> | <A href='byond://?src=\ref[src];shutdown=\ref[D]'>Shutdown</A></font>"

	dat += "<BR><BR><B>Request drone presence in area:</B> <A href='byond://?src=\ref[src];setarea=1'>[drone_call_area]</A> (<A href='byond://?src=\ref[src];ping=1'>Send ping</A>)"

	dat += "<BR><BR><B>Drone fabricator</B>: "
	dat += "[dronefab ? "<A href='byond://?src=\ref[src];toggle_fab=1'>[(dronefab.produce_drones && !(dronefab.stat & NOPOWER)) ? "ACTIVE" : "INACTIVE"]</A>" : "<font color='red'><b>FABRICATOR NOT DETECTED.</b></font> (<A href='byond://?src=\ref[src];search_fab=1'>search</a>)"]"
	show_browser(user, dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return


/obj/machinery/computer/drone_control/OnTopic(mob/user, href_list)
	if((. = ..()))
		return

	if(!allowed(user))
		to_chat(user, "<span class='danger'>Access denied.</span>")
		return TOPIC_HANDLED

	if (href_list["setarea"])
		//Probably should consider using another list, but this one will do.
		var/t_area = input("Select the area to ping.", "Set Target Area", null) as null|anything in global.tagger_locations
		if(!t_area)
			return TOPIC_HANDLED
		drone_call_area = t_area
		to_chat(user, "<span class='notice'>You set the area selector to [drone_call_area].</span>")
		. = TOPIC_REFRESH

	else if (href_list["ping"])
		to_chat(user, "<span class='notice'>You issue a maintenance request for all active drones, highlighting [drone_call_area].</span>")
		for(var/mob/living/silicon/robot/drone/D in global.silicon_mob_list)
			if(D.client && D.stat == CONSCIOUS)
				to_chat(D, "-- Maintenance drone presence requested in: [drone_call_area].")
		. = TOPIC_REFRESH

	else if (href_list["resync"])
		var/mob/living/silicon/robot/drone/D = locate(href_list["resync"])
		. = TOPIC_HANDLED
		if(D.stat != DEAD)
			to_chat(user, "<span class='danger'>You issue a law synchronization directive for the drone.</span>")
			D.law_resync()
			. = TOPIC_REFRESH

	else if (href_list["shutdown"])
		var/mob/living/silicon/robot/drone/D = locate(href_list["shutdown"])
		. = TOPIC_HANDLED
		if(D.stat != DEAD)
			to_chat(user, "<span class='danger'>You issue a kill command for the unfortunate drone.</span>")
			message_admins("[key_name_admin(user)] issued kill order for drone [key_name_admin(D)] from control console.")
			log_game("[key_name(user)] issued kill order for [key_name(src)] from control console.")
			D.shut_down()
			. = TOPIC_REFRESH

	else if (href_list["search_fab"])
		if(dronefab)
			return TOPIC_HANDLED

		for(var/obj/machinery/drone_fabricator/fab in oview(3,src))
			if(fab.stat & NOPOWER)
				continue
			dronefab = fab
			to_chat(user, "<span class='notice'>Drone fabricator located.</span>")
			return TOPIC_REFRESH

		to_chat(user, "<span class='danger'>Unable to locate drone fabricator.</span>")
		. = TOPIC_HANDLED

	else if (href_list["toggle_fab"])
		if(!dronefab)
			return TOPIC_HANDLED

		if(get_dist(src,dronefab) > 3)
			dronefab = null
			to_chat(user, "<span class='danger'>Unable to locate drone fabricator.</span>")
			return TOPIC_REFRESH

		dronefab.produce_drones = !dronefab.produce_drones
		to_chat(user, "<span class='notice'>You [dronefab.produce_drones ? "enable" : "disable"] drone production in the nearby fabricator.</span>")
		. = TOPIC_REFRESH
