/obj/machinery/atmospherics/unary/vent_scrubber
	icon = 'icons/atmos/vent_scrubber.dmi'
	icon_state = "map_scrubber_off"

	name = "air scrubber"
	desc = "Has a valve and pump attached to it."
	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 30000			// 30000 W ~ 40 HP

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SCRUBBER //connects to regular and scrubber pipes
	identifier = "AScr"

	level = LEVEL_BELOW_PLATING

	var/hibernate = 0 //Do we even process?
	var/scrubbing = SCRUBBER_EXCHANGE
	var/list/scrubbing_gas

	var/panic = 0 //is this scrubber panicked?

	var/welded = 0
	build_icon_state = "scrubber"

	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
	)
	public_variables = list(
		/decl/public_access/public_variable/input_toggle,
		/decl/public_access/public_variable/area_uid,
		/decl/public_access/public_variable/identifier,
		/decl/public_access/public_variable/use_power,
		/decl/public_access/public_variable/name,
		/decl/public_access/public_variable/scrubbing,
		/decl/public_access/public_variable/panic,
		/decl/public_access/public_variable/scrubbing_gas
	)
	public_methods = list(
		/decl/public_access/public_method/toggle_power,
		/decl/public_access/public_method/refresh,
		/decl/public_access/public_method/toggle_panic_siphon,
		/decl/public_access/public_method/set_scrub_gas
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_scrubber = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_scrubber = 1
	)

	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/default/panel_closed/item_chassis
	base_type = /obj/machinery/atmospherics/unary/vent_scrubber/buildable

/obj/machinery/atmospherics/unary/vent_scrubber/buildable
	uncreated_component_parts = null

/obj/machinery/atmospherics/unary/vent_scrubber/on
	use_power = POWER_USE_IDLE
	icon_state = "map_scrubber_on"

/obj/machinery/atmospherics/unary/vent_scrubber/Initialize()
	if (!id_tag)
		id_tag = "[sequential_id("obj/machinery")]"
	if(!scrubbing_gas)
		scrubbing_gas = list()
		for(var/g in decls_repository.get_decl_paths_of_subtype(/decl/material/gas))
			if(g != /decl/material/gas/oxygen && g != /decl/material/gas/nitrogen)
				scrubbing_gas += g
	. = ..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_FILTER

/obj/machinery/atmospherics/unary/vent_scrubber/reset_area(area/old_area, area/new_area)
	if(!controlled)
		return
	if(old_area == new_area)
		return
	if(old_area)
		events_repository.unregister(/decl/observ/name_set, old_area, src, PROC_REF(change_area_name))
		old_area.air_scrub_info -= id_tag
		old_area.air_scrub_names -= id_tag
	if(new_area && new_area == get_area(src))
		events_repository.register(/decl/observ/name_set, new_area, src, PROC_REF(change_area_name))
		if(!new_area.air_scrub_names[id_tag])
			var/new_name = "[new_area.proper_name] Vent Scrubber #[new_area.air_scrub_names.len+1]"
			new_area.air_scrub_names[id_tag] = new_name
			SetName(new_name)


/obj/machinery/atmospherics/unary/vent_scrubber/on_update_icon()
	if(welded)
		icon_state = "weld"
	else if((stat & NOPOWER) || !use_power)
		icon_state = "off"
	else if(scrubbing == SCRUBBER_SIPHON)
		icon_state = "in"
	else
		icon_state = "on"

	build_device_underlays()

/obj/machinery/atmospherics/unary/vent_scrubber/proc/change_area_name(var/area/A, var/old_area_name, var/new_area_name)
	if(!controlled)
		return
	if(get_area(src) != A)
		return
	update_name()

/obj/machinery/atmospherics/unary/vent_scrubber/area_changed(area/old_area, area/new_area)
	if(old_area)
		old_area.air_scrub_names -= id_tag
	. = ..()
	update_name()

/obj/machinery/atmospherics/unary/vent_scrubber/proc/update_name()
	var/area/A = get_area(src)
	if(!A || A == global.space_area)
		SetName("vent scrubber")
		return
	var/index
	if(A.air_scrub_names[id_tag])
		index = A.air_scrub_names.Find(id_tag)
	else
		A.air_scrub_names[id_tag] = TRUE
		index = length(A.air_scrub_names)
	var/new_name = "[A.proper_name] vent scrubber #[index]"
	A.air_scrub_names[id_tag] = new_name
	SetName(new_name)

/obj/machinery/atmospherics/unary/vent_scrubber/RefreshParts()
	. = ..()
	toggle_input_toggle()

/obj/machinery/atmospherics/unary/vent_scrubber/Process()
	..()

	if (hibernate > world.time)
		return 1

	if (!LAZYLEN(nodes_to_networks))
		update_use_power(POWER_USE_OFF)
	//broadcast_status()
	if(!use_power || (stat & (NOPOWER|BROKEN)))
		return 0
	if(welded)
		return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/power_draw = -1
	var/transfer_moles = 0
	if(scrubbing == SCRUBBER_SIPHON) //Just siphon all air
		//limit flow rate from turfs
		transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SIPHON_FLOWRATE/environment.volume)	//group_multiplier gets divided out here
		power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)
	else //limit flow rate from turfs
		transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SCRUBBER_FLOWRATE/environment.volume)	//group_multiplier gets divided out here
		power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, power_rating)

	if(scrubbing != SCRUBBER_SIPHON && power_draw <= 0)	//99% of all scrubbers
		//Fucking hibernate because you ain't doing shit.
		hibernate = world.time + (rand(100,200))
	else if(scrubbing == SCRUBBER_EXCHANGE) // after sleep check so it only does an exchange if there are bad gasses that have been scrubbed
		transfer_moles = min(environment.total_moles, environment.total_moles*MAX_SCRUBBER_FLOWRATE/environment.volume)
		power_draw += pump_gas(src, environment, air_contents, transfer_moles / 4, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

	if(transfer_moles > 0)
		update_networks()

	return 1

/obj/machinery/atmospherics/unary/vent_scrubber/hide(var/i) //to make the little pipe section invisible, the icon changes.
	update_icon()

/obj/machinery/atmospherics/unary/vent_scrubber/proc/toggle_panic()
	var/decl/public_access/public_variable/panic/panic = GET_DECL(/decl/public_access/public_variable/panic)
	panic.write_var(src, !panic)

/obj/machinery/atmospherics/unary/vent_scrubber/proc/set_scrub_gas(var/list/gases)
	for(var/gas_id in gases)
		if((gas_id in scrubbing_gas) ^ gases[gas_id])
			scrubbing_gas ^= gas_id

/obj/machinery/atmospherics/unary/vent_scrubber/cannot_transition_to(state_path, mob/user)
	if(state_path == /decl/machine_construction/default/deconstructed)
		if (!(stat & NOPOWER) && use_power)
			return SPAN_WARNING("You cannot take this [src] apart, turn it off first.")
		var/turf/T = get_turf(src)
		var/hidden_pipe_check = FALSE
		for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
			if(node.level == LEVEL_BELOW_PLATING)
				hidden_pipe_check = TRUE
				break
		if (hidden_pipe_check && isturf(T) && !T.is_plating())
			return SPAN_WARNING("You must remove the plating first.")
		var/datum/gas_mixture/int_air = return_air()
		var/datum/gas_mixture/env_air = loc.return_air()
		if ((int_air.return_pressure()-env_air.return_pressure()) > (2 ATM))
			return SPAN_WARNING("You cannot take this [src] apart, it too exerted due to internal pressure.")
	return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/attackby(var/obj/item/used_item, var/mob/user)
	if(istype(used_item, /obj/item/weldingtool))

		var/obj/item/weldingtool/welder = used_item

		if(!welder.isOn())
			to_chat(user, "<span class='notice'>The welding tool needs to be on to start this task.</span>")
			return 1

		if(!welder.weld(0,user))
			to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
			return 1

		to_chat(user, "<span class='notice'>Now welding \the [src].</span>")
		playsound(src, 'sound/items/Welder.ogg', 50, 1)

		if(!do_after(user, 20, src))
			to_chat(user, "<span class='notice'>You must remain close to finish this task.</span>")
			return 1

		if(!src)
			return 1

		if(!welder.isOn())
			to_chat(user, "<span class='notice'>The welding tool needs to be on to finish this task.</span>")
			return 1

		welded = !welded
		update_icon()
		playsound(src, 'sound/items/Welder2.ogg', 50, 1)
		user.visible_message("<span class='notice'>\The [user] [welded ? "welds \the [src] shut" : "unwelds \the [src]"].</span>", \
			"<span class='notice'>You [welded ? "weld \the [src] shut" : "unweld \the [src]"].</span>", \
			"You hear welding.")
		return 1

	return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "A small gauge in the corner reads [round(last_flow_rate, 0.1)] L/s; [round(last_power_draw)] W."
	else
		. += "You are too far away to read the gauge."
	if(welded)
		. += "It seems welded shut."
	if(!(stat & NOPOWER) && use_power && user.skill_check(SKILL_ATMOS,SKILL_BASIC))
		. += "It's running in [scrubbing] mode."

/obj/machinery/atmospherics/unary/vent_scrubber/refresh()
	..()
	hibernate = FALSE
	toggle_input_toggle()

/obj/machinery/atmospherics/unary/vent_scrubber/on/sauna/Initialize()
	. = ..()
	scrubbing_gas -= /decl/material/liquid/water

/decl/public_access/public_variable/scrubbing
	expected_type = /obj/machinery/atmospherics/unary/vent_scrubber
	name = "scrubbing mode"
	desc = "The scrubbing mode code, which identifies what the scrubber is doing."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_STRING

/decl/public_access/public_variable/scrubbing/access_var(obj/machinery/atmospherics/unary/vent_scrubber/machine)
	return machine.scrubbing

/decl/public_access/public_variable/scrubbing/write_var(obj/machinery/atmospherics/unary/vent_scrubber/machine, new_value)
	if(!(new_value in list(SCRUBBER_EXCHANGE, SCRUBBER_SCRUB, SCRUBBER_SIPHON)))
		return FALSE
	. = ..()
	if(.)
		machine.scrubbing = new_value
		if(new_value != SCRUBBER_SIPHON)
			machine.panic = FALSE

/decl/public_access/public_variable/panic
	expected_type = /obj/machinery/atmospherics/unary/vent_scrubber
	name = "panic state"
	desc = "Whether or not the scrubber is in panic mode."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_BOOLEAN

/decl/public_access/public_variable/panic/access_var(obj/machinery/atmospherics/unary/vent_scrubber/machine)
	return machine.panic

/decl/public_access/public_variable/panic/write_var(obj/machinery/atmospherics/unary/vent_scrubber/machine, new_value)
	new_value = !!new_value
	. = ..()
	if(.)
		machine.panic = new_value
		if(machine.panic)
			machine.update_use_power(POWER_USE_IDLE)
			machine.scrubbing = SCRUBBER_SIPHON
		else
			machine.scrubbing = SCRUBBER_EXCHANGE

/decl/public_access/public_variable/scrubbing_gas
	expected_type = /obj/machinery/atmospherics/unary/vent_scrubber
	name = "gasses scrubbing"
	desc = "A list of gases that this scrubber is scrubbing."
	can_write = FALSE
	has_updates = FALSE
	var_type = IC_FORMAT_LIST

/decl/public_access/public_variable/scrubbing_gas/access_var(obj/machinery/atmospherics/unary/vent_scrubber/machine)
	return machine.scrubbing_gas.Copy()

/decl/public_access/public_method/toggle_panic_siphon
	name = "toggle panic siphon"
	desc = "Toggles the panic siphon function."
	call_proc = TYPE_PROC_REF(/obj/machinery/atmospherics/unary/vent_scrubber, toggle_panic)

/decl/public_access/public_method/set_scrub_gas
	name = "set filter gases"
	desc = "Given a list of gases, sets whether the gas is being scrubbed to the value of the gas in the list."
	forward_args = TRUE
	call_proc = TYPE_PROC_REF(/obj/machinery/atmospherics/unary/vent_scrubber, set_scrub_gas)

/decl/stock_part_preset/radio/event_transmitter/vent_scrubber
	frequency = PUMP_FREQ
	filter = RADIO_TO_AIRALARM
	event = /decl/public_access/public_variable/input_toggle
	transmit_on_event = list(
		"area" = /decl/public_access/public_variable/area_uid,
		"device" = /decl/public_access/public_variable/identifier,
		"power" = /decl/public_access/public_variable/use_power,
		"panic" = /decl/public_access/public_variable/panic,
		"scrubbing" = /decl/public_access/public_variable/scrubbing,
		"scrubbing_gas" = /decl/public_access/public_variable/scrubbing_gas
	)

/decl/stock_part_preset/radio/receiver/vent_scrubber
	frequency = PUMP_FREQ
	filter = RADIO_FROM_AIRALARM
	receive_and_call = list(
		"power_toggle" = /decl/public_access/public_method/toggle_power,
		"toggle_panic_siphon" = /decl/public_access/public_method/toggle_panic_siphon,
		"set_scrub_gas" = /decl/public_access/public_method/set_scrub_gas,
		"status" = /decl/public_access/public_method/refresh
	)
	receive_and_write = list(
		"set_power" = /decl/public_access/public_variable/use_power,
		"panic_siphon" = /decl/public_access/public_variable/panic,
		"set_scrubbing" = /decl/public_access/public_variable/scrubbing,
		"init" = /decl/public_access/public_variable/name
	)

/decl/stock_part_preset/radio/receiver/vent_scrubber/shuttle
	frequency = SHUTTLE_AIR_FREQ

/decl/stock_part_preset/radio/event_transmitter/vent_scrubber/shuttle
	frequency = SHUTTLE_AIR_FREQ

// Similar to the vent of the same name, for hybrid airlock-rooms
/obj/machinery/atmospherics/unary/vent_scrubber/on/shuttle_auxiliary
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_scrubber/shuttle = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_scrubber/shuttle = 1
	)