//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/prisoner
	name = "prisoner management console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "security_key"
	icon_screen = "explosive"
	light_color = "#a91515"
	initial_access = list(access_armory)
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed

/obj/machinery/computer/prisoner/interface_interact(user)
	interact(user)
	return TRUE

/obj/machinery/computer/prisoner/interact(var/mob/user)
	var/dat
	dat += "<B>Prisoner Implant Manager System</B><BR>"
	if(screen == 0)
		dat += "<HR><A href='byond://?src=\ref[src];lock=1'>Unlock Console</A>"
	else if(screen == 1)
		dat += "<HR>Chemical Implants<BR>"
		var/turf/Tr = null
		for(var/obj/item/implant/chem/C in global.chem_implants)
			Tr = get_turf(C)
			if((Tr) && !LEVELS_ARE_Z_CONNECTED(Tr.z, src.z))	continue // Out of range
			if(!C.implanted) continue
			dat += "[C.imp_in.name] | Remaining Units: [C.reagents.total_volume] | Inject: "
			dat += "<A href='byond://?src=\ref[src];inject1=\ref[C]'>(<font color=red>(1)</font>)</A>"
			dat += "<A href='byond://?src=\ref[src];inject5=\ref[C]'>(<font color=red>(5)</font>)</A>"
			dat += "<A href='byond://?src=\ref[src];inject10=\ref[C]'>(<font color=red>(10)</font>)</A><BR>"
			dat += "********************************<BR>"
		dat += "<HR>Tracking Implants<BR>"
		for(var/obj/item/implant/tracking/T in global.tracking_implants)
			Tr = get_turf(T)
			if((Tr) && !LEVELS_ARE_Z_CONNECTED(Tr.z, src.z))	continue // Out of range
			if(!T.implanted) continue
			var/loc_display = "Space"
			var/mob/living/M = T.imp_in
			if(!isspaceturf(M.loc))
				var/turf/mob_loc = get_turf(M)
				loc_display = mob_loc.loc
			if(T.malfunction)
				loc_display = pick(teleportlocs)
			dat += "ID: [T.id] | Location: [loc_display]<BR>"
			dat += "<A href='byond://?src=\ref[src];warn=\ref[T]'>(<font color=red><i>Message Holder</i></font>)</A> |<BR>"
			dat += "********************************<BR>"
		dat += "<HR><A href='byond://?src=\ref[src];lock=1'>Lock Console</A>"

	show_browser(user, dat, "window=computer;size=400x500")
	onclose(user, "computer")

/obj/machinery/computer/prisoner/OnTopic(mob/user, href_list)
	if((. = ..()))
		return
	. = TOPIC_REFRESH

	if(href_list["inject1"])
		var/obj/item/implant/I = locate(href_list["inject1"])
		if(I)	I.activate(1)

	else if(href_list["inject5"])
		var/obj/item/implant/I = locate(href_list["inject5"])
		if(I)	I.activate(5)

	else if(href_list["inject10"])
		var/obj/item/implant/I = locate(href_list["inject10"])
		if(I)	I.activate(10)

	else if(href_list["lock"])
		if(allowed(user))
			screen = !screen
		else
			to_chat(user, "Unauthorized Access.")

	else if(href_list["warn"])
		var/warning = sanitize(input(user,"Message:","Enter your message here!",""))
		if(!warning) return TOPIC_HANDLED
		var/obj/item/implant/I = locate(href_list["warn"])
		if(I?.imp_in)
			var/mob/living/victim = I.imp_in
			to_chat(victim, "<span class='notice'>You hear a voice in your head saying: '[warning]'</span>")
