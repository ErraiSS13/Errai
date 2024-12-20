#define STATE_DEFAULT	1
#define STATE_MESSAGELIST	2
#define STATE_VIEWMESSAGE	3
#define STATE_STATUSDISPLAY	4
#define STATE_ALERT_LEVEL	5
/datum/computer_file/program/comm
	filename = "comm"
	filedesc = "Command and Communications Program"
	program_icon_state = "comm"
	program_key_state = "med_key"
	program_menu_icon = "flag"
	nanomodule_path = /datum/nano_module/program/comm
	extended_desc = "Used to command and control. Can relay long-range communications. This program can not be run on tablet computers."
	read_access = list(access_bridge)
	requires_network = 1
	requires_network_feature = NET_FEATURE_SYSTEMCONTROL
	size = 12
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	network_destination = "long-range communication array"
	category = PROG_COMMAND
	var/datum/comm_message_listener/message_core = new

/datum/computer_file/program/comm/PopulateClone(datum/computer_file/program/comm/clone)
	clone = ..()
	clone.message_core = message_core.Clone()
	return clone

/datum/nano_module/program/comm
	name = "Command and Communications Program"
	available_to_ai = TRUE
	var/current_status = STATE_DEFAULT
	var/msg_line1 = ""
	var/msg_line2 = ""
	var/centcomm_message_cooldown = 0
	var/announcment_cooldown = 0
	var/datum/announcement/priority/crew_announcement = new
	var/current_viewing_message_id = 0
	var/current_viewing_message = null

/datum/nano_module/program/comm/New()
	..()
	crew_announcement.newscast = 1

/datum/nano_module/program/comm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)

	var/list/data = host.initial_data()

	if(program)
		data["net_comms"] = !!program.get_signal(NET_FEATURE_COMMUNICATION) //Double !! is needed to get 1 or 0 answer
		data["net_syscont"] = !!program.get_signal(NET_FEATURE_SYSTEMCONTROL)
		if(program.computer)
			data["emagged"] = program.computer.emagged()
			data["have_printer"] =  program.computer.has_component(PART_PRINTER)
		else
			data["have_printer"] = 0
	else
		data["emagged"] = 0
		data["net_comms"] = 1
		data["net_syscont"] = 1
		data["have_printer"] = 0

	data["message_line1"] = msg_line1
	data["message_line2"] = msg_line2
	data["state"] = current_status
	data["isAI"] = issilicon(user)
	data["authenticated"] = is_authenticated(user)
	data["boss_short"] = global.using_map.boss_short

	var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
	data["current_security_level_ref"] = any2ref(security_state.current_security_level)
	data["current_security_level_title"] = security_state.current_security_level.name

	data["cannot_change_security_level"] = !security_state.can_change_security_level()
	data["current_security_level_is_high_security_level"] = security_state.current_security_level == security_state.high_security_level
	var/list/security_levels = list()
	for(var/decl/security_level/security_level in security_state.comm_console_security_levels)
		var/list/security_setup = list()
		security_setup["title"] = security_level.name
		security_setup["ref"] = any2ref(security_level)
		security_levels[++security_levels.len] = security_setup
	data["security_levels"] = security_levels

	var/datum/comm_message_listener/l = obtain_message_listener()
	data["messages"] = l.messages
	data["message_deletion_allowed"] = l != global_message_listener
	data["message_current_id"] = current_viewing_message_id
	if(current_viewing_message)
		data["message_current"] = current_viewing_message

	var/list/processed_evac_options = list()
	for (var/datum/evacuation_option/EO in SSevac.evacuation_controller?.available_evac_options())
		if(EO.abandon_ship)
			continue
		var/list/option = list()
		option["option_text"] = EO.option_text
		option["option_target"] = EO.option_target
		option["needs_syscontrol"] = EO.needs_syscontrol
		option["silicon_allowed"] = EO.silicon_allowed
		option["requires_shunt"] = EO.requires_shunt
		processed_evac_options[++processed_evac_options.len] = option
	data["evac_options"] = processed_evac_options

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "communication.tmpl", name, 550, 420, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/comm/proc/is_authenticated(var/mob/user)
	if(program)
		return program.get_file_perms(get_access(user), user) & OS_READ_ACCESS
	return 1

/datum/nano_module/program/comm/proc/get_shunt()
	if(isnull(program?.computer))
		return FALSE

	var/obj/comp = program.computer.get_physical_host()

	if(isnull(comp))
		return FALSE

	var/obj/effect/overmap/visitable/ship/sector = comp.get_owning_overmap_object()

	if(!istype(sector))
		return

	for(var/obj/machinery/ftl_shunt/core/C in SSmachines.machinery)
		if(C.z in sector.map_z)
			if(C.get_status() != 2) //magic number because defines are lower than this file.
				return TRUE

	return FALSE


/datum/nano_module/program/comm/proc/obtain_message_listener()
	if(program)
		var/datum/computer_file/program/comm/P = program
		return P.message_core
	return global_message_listener

/datum/nano_module/program/comm/Topic(href, href_list)
	if(..())
		return 1
	var/mob/user = usr
	var/ntn_comm = program ? !!program.get_signal(NET_FEATURE_COMMUNICATION) : 1
	var/ntn_cont = program ? !!program.get_signal(NET_FEATURE_SYSTEMCONTROL) : 1
	var/datum/comm_message_listener/l = obtain_message_listener()
	switch(href_list["action"])
		if("sw_menu")
			. = 1
			current_status = text2num(href_list["target"])
		if("announce")
			. = 1
			if(is_authenticated(user) && !issilicon(user) && ntn_comm)
				if(user)
					var/obj/item/card/id/id_card = user.GetIdCard()
					crew_announcement.announcer = GetNameAndAssignmentFromId(id_card)
				else
					crew_announcement.announcer = "Unknown"
				if(announcment_cooldown)
					to_chat(user, "Please allow at least one minute to pass between announcements.")
					return TRUE
				var/input = input(user, "Please write a message to announce to the [station_name()].", "Priority Announcement") as null|message
				if(!input || !can_still_topic() || filter_block_message(user, input))
					return 1
				var/affected_zlevels = SSmapping.get_connected_levels(get_host_z())
				crew_announcement.Announce(input, zlevels = affected_zlevels)
				announcment_cooldown = 1
				spawn(600)//One minute cooldown
					announcment_cooldown = 0
		if("message")
			. = 1
			if(href_list["target"] == "emagged")
				if(program)
					if(is_authenticated(user) && program.computer.emagged() && !issilicon(user) && ntn_comm)
						if(centcomm_message_cooldown)
							to_chat(user, "<span class='warning'>Arrays recycling. Please stand by.</span>")
							SSnano.update_uis(src)
							return
						var/input = sanitize(input(user, "Please choose a message to transmit to \[ABNORMAL ROUTING CORDINATES\] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination. Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", "") as null|text)
						if(!input || !can_still_topic() || filter_block_message(user, input))
							return 1
						Syndicate_announce(input, user)
						to_chat(user, "<span class='notice'>Message transmitted.</span>")
						log_say("[key_name(user)] has made an illegal announcement: [input]")
						centcomm_message_cooldown = 1
						spawn(300)//30 second cooldown
							centcomm_message_cooldown = 0
			else if(href_list["target"] == "regular")
				if(is_authenticated(user) && !issilicon(user) && ntn_comm)
					if(centcomm_message_cooldown)
						to_chat(user, "<span class='warning'>Arrays recycling. Please stand by.</span>")
						SSnano.update_uis(src)
						return
					if(!is_relay_online())//Contact Centcom has a check, Syndie doesn't to allow for Traitor funs.
						to_chat(user, "<span class='warning'>No emergency communication relay detected. Unable to transmit message.</span>")
						return 1
					var/input = sanitize(input("Please choose a message to transmit to [global.using_map.boss_short] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination.  Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", "") as null|text)
					if(!input || !can_still_topic() || filter_block_message(user, input))
						return 1
					Centcomm_announce(input, user)
					to_chat(user, "<span class='notice'>Message transmitted.</span>")
					log_say("[key_name(user)] has made an IA [global.using_map.boss_short] announcement: [input]")
					centcomm_message_cooldown = 1
					spawn(300) //30 second cooldown
						centcomm_message_cooldown = 0
		if("evac")
			. = 1
			if(SSevac.evacuation_controller && is_authenticated(user))
				var/datum/evacuation_option/selected_evac_option = SSevac.evacuation_controller.evacuation_options[href_list["target"]]
				if (isnull(selected_evac_option) || !istype(selected_evac_option))
					return
				if (!selected_evac_option.silicon_allowed && issilicon(user))
					return
				if (selected_evac_option.needs_syscontrol && !ntn_cont)
					return
				if (selected_evac_option.requires_shunt && !get_shunt())
					return
				var/confirm = alert("Are you sure you want to [selected_evac_option.option_desc]?", name, "No", "Yes")
				if (confirm == "Yes" && can_still_topic())
					SSevac.evacuation_controller.handle_evac_option(selected_evac_option.option_target, user)
		if("setstatus")
			. = 1
			if(is_authenticated(user) && ntn_cont)
				switch(href_list["target"])
					if("line1")
						var/linput = reject_bad_text(sanitize(input("Line 1", "Enter Message Text", msg_line1) as text|null, 40), 40)
						if(can_still_topic())
							msg_line1 = linput
					if("line2")
						var/linput = reject_bad_text(sanitize(input("Line 2", "Enter Message Text", msg_line2) as text|null, 40), 40)
						if(can_still_topic())
							msg_line2 = linput
					if("message")
						post_status("message", msg_line1, msg_line2)
					if("image")
						post_status("image", href_list["image"])
					else
						post_status(href_list["target"])
		if("setalert")
			. = 1
			if(is_authenticated(user) && !issilicon(user) && ntn_cont && ntn_comm)
				var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
				var/decl/security_level/target_level = locate(href_list["target"]) in security_state.comm_console_security_levels
				if(target_level && security_state.can_switch_to(target_level))
					var/confirm = alert("Are you sure you want to change the alert level to [target_level.name]?", name, "No", "Yes")
					if(confirm == "Yes" && can_still_topic())
						if(security_state.set_security_level(target_level))
							SSstatistics.add_field(target_level.type,1)
			else
				to_chat(user, "You press the button, but a red light flashes and nothing happens.") //This should never happen

			current_status = STATE_DEFAULT
		if("viewmessage")
			. = 1
			if(is_authenticated(user) && ntn_comm)
				current_viewing_message_id = text2num(href_list["target"])
				for(var/list/m in l.messages)
					if(m["id"] == current_viewing_message_id)
						current_viewing_message = m
				current_status = STATE_VIEWMESSAGE
		if("delmessage")
			. = 1
			if(is_authenticated(user) && ntn_comm && l != global_message_listener)
				l.Remove(current_viewing_message)
			current_status = STATE_MESSAGELIST
		if("printmessage")
			. = 1
			if(is_authenticated(user) && ntn_comm)
				if(!program.computer.print_paper(current_viewing_message["contents"],current_viewing_message["title"]))
					to_chat(user, "<span class='notice'>Hardware Error: Printer was unable to print the selected file.</span>")
		if("unbolt_doors")
			global.using_map.unbolt_saferooms()
			to_chat(user, "<span class='notice'>The console beeps, confirming the signal was sent to have the saferooms unbolted.</span>")
		if("bolt_doors")
			global.using_map.bolt_saferooms()
			to_chat(user, "<span class='notice'>The console beeps, confirming the signal was sent to have the saferooms bolted.</span>")

#undef STATE_DEFAULT
#undef STATE_MESSAGELIST
#undef STATE_VIEWMESSAGE
#undef STATE_STATUSDISPLAY
#undef STATE_ALERT_LEVEL

/*
General message handling stuff
*/
var/global/list/comm_message_listeners = list() //We first have to initialize list then we can use it.
var/global/datum/comm_message_listener/global_message_listener = new //May be used by admins
var/global/last_message_id = 0

/proc/get_comm_message_id()
	last_message_id = last_message_id + 1
	return last_message_id

/proc/post_comm_message(var/message_title, var/message_text)
	var/list/message = list()
	message["id"] = get_comm_message_id()
	message["title"] = message_title
	message["contents"] = message_text

	for (var/datum/comm_message_listener/l in comm_message_listeners)
		l.Add(message)

/datum/comm_message_listener
	var/list/messages

/datum/comm_message_listener/New()
	..()
	messages = list()
	comm_message_listeners.Add(src)

/datum/comm_message_listener/proc/Add(var/list/message)
	messages[++messages.len] = message

/datum/comm_message_listener/proc/Remove(var/list/message)
	messages -= list(message)

/datum/comm_message_listener/PopulateClone(datum/comm_message_listener/clone)
	clone = ..()
	clone.messages = listDeepClone(messages)
	return clone

/proc/post_status(var/command, var/data1, var/data2)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			log_admin("STATUS: [key_name(usr)] set status screen message with: [data1] [data2]")
		if("image")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(signal = status_signal)

/proc/cancel_call_proc(var/mob/user)
	if (!SSevac.evacuation_controller)
		return

	if(SSevac.evacuation_controller.cancel_evacuation())
		log_and_message_admins("has cancelled the evacuation.", user)

	return


/proc/is_relay_online()
	for(var/obj/machinery/commsrelay/M in SSmachines.machinery)
		if(M.stat == 0)
			return 1
	return 0

/proc/call_shuttle_proc(var/mob/user, var/emergency)
	if (!SSevac.evacuation_controller)
		return

	if(isnull(emergency))
		emergency = 1

	if(!global.universe.OnShuttleCall(user))
		to_chat(user, "<span class='notice'>Cannot establish a connection.</span>")
		return

	if(SSevac.evacuation_controller.deny)
		to_chat(user, "An evacuation cannot be called at this time. Please try again later.")
		return

	if(SSevac.evacuation_controller.is_on_cooldown()) // Ten minute grace period to let the game get going without lolmetagaming. -- TLE
		to_chat(user, SSevac.evacuation_controller.get_cooldown_message())

	if(SSevac.evacuation_controller.is_evacuating())
		to_chat(user, "An evacuation is already underway.")
		return

	if(SSevac.evacuation_controller.call_evacuation(user, _emergency_evac = emergency))
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has called the shuttle.")

/proc/init_autotransfer()

	if (!SSevac.evacuation_controller)
		return

	. = SSevac.evacuation_controller.call_evacuation(null, _emergency_evac = FALSE, autotransfer = TRUE)
	if(.)
		//delay events in case of an autotransfer
		var/delay = SSevac.evacuation_controller.evac_arrival_time - world.time + (2 MINUTES)
		SSevent.delay_events(EVENT_LEVEL_MODERATE, delay)
		SSevent.delay_events(EVENT_LEVEL_MAJOR, delay)
