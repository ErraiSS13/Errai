#define DEFAULT_PRESSURE_DELTA 10000

#define EXTERNAL_PRESSURE_BOUND ONE_ATMOSPHERE
#define INTERNAL_PRESSURE_BOUND 0
#define PRESSURE_CHECKS 1

#define PRESSURE_CHECK_EXTERNAL 1
#define PRESSURE_CHECK_INTERNAL 2

/obj/machinery/atmospherics/unary/vent_pump
	icon = 'icons/atmos/vent_pump.dmi'
	icon_state = "map_vent"

	name = "air vent"
	desc = "A vent that moves air into or out of the attached pipe system, and uses a valve and pump to prevent backflow."
	use_power = POWER_USE_OFF
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 30000			// 30000 W ~ 40 HP

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_FUEL //connects to regular, supply pipes, and fuel pipes
	level = LEVEL_BELOW_PLATING
	identifier = "AVP"

	var/hibernate = 0 //Do we even process?
	var/pump_direction = 1 //0 = siphoning, 1 = releasing

	var/external_pressure_bound = EXTERNAL_PRESSURE_BOUND
	var/internal_pressure_bound = INTERNAL_PRESSURE_BOUND

	var/pressure_checks = PRESSURE_CHECKS
	//1: Do not pass external_pressure_bound
	//2: Do not pass internal_pressure_bound
	//3: Do not pass either

	// Used when handling incoming radio signals requesting default settings
	var/external_pressure_bound_default = EXTERNAL_PRESSURE_BOUND
	var/internal_pressure_bound_default = INTERNAL_PRESSURE_BOUND
	var/pressure_checks_default = PRESSURE_CHECKS

	var/welded = 0 // Added for aliens -- TLE

	build_icon_state = "uvent"
	var/sound_id
	var/datum/sound_token/sound_token

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
		/decl/public_access/public_variable/pump_dir,
		/decl/public_access/public_variable/pump_checks,
		/decl/public_access/public_variable/pressure_bound,
		/decl/public_access/public_variable/pressure_bound/external,
		/decl/public_access/public_variable/power_draw,
		/decl/public_access/public_variable/flow_rate,
		/decl/public_access/public_variable/name
	)
	public_methods = list(
		/decl/public_access/public_method/toggle_power,
		/decl/public_access/public_method/toggle_pump_dir,
		/decl/public_access/public_method/purge_pump,
		/decl/public_access/public_method/refresh
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump = 1
	)

	frame_type = /obj/item/pipe
	construct_state = /decl/machine_construction/default/panel_closed/item_chassis
	base_type = /obj/machinery/atmospherics/unary/vent_pump/buildable

/obj/machinery/atmospherics/unary/vent_pump/Initialize()
	if (!id_tag)
		id_tag = "[sequential_id("obj/machinery")]"
	if(controlled)
		var/area/A = get_area(src)
		if(A && !A.air_vent_names[id_tag])
			update_name()
			events_repository.register(/decl/observ/name_set, A, src, PROC_REF(change_area_name))
	. = ..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP
	update_sound()

/obj/machinery/atmospherics/unary/vent_pump/proc/change_area_name(var/area/A, var/old_area_name, var/new_area_name)
	if(get_area(src) != A)
		return
	update_name()

/obj/machinery/atmospherics/unary/vent_pump/area_changed(area/old_area, area/new_area)
	if(old_area)
		old_area.air_vent_names -= id_tag
	. = ..()
	update_name()

/obj/machinery/atmospherics/unary/vent_pump/proc/update_name()
	var/area/A = get_area(src)
	if(!A || A == global.space_area || !controlled)
		SetName("vent pump")
		return
	var/index
	if(A.air_vent_names[id_tag])
		index = A.air_vent_names.Find(id_tag)
	else
		A.air_vent_names[id_tag] = TRUE
		index = length(A.air_vent_names)
	var/new_name = "[A.proper_name] vent pump #[index]"
	A.air_vent_names[id_tag] = new_name
	SetName(new_name)

/obj/machinery/atmospherics/unary/vent_pump/buildable
	uncreated_component_parts = null

/obj/machinery/atmospherics/unary/vent_pump/on
	use_power = POWER_USE_IDLE
	icon_state = "map_vent_out"

/obj/machinery/atmospherics/unary/vent_pump/siphon
	pump_direction = 0

/obj/machinery/atmospherics/unary/vent_pump/siphon/on
	use_power = POWER_USE_IDLE
	icon_state = "map_vent_in"

/obj/machinery/atmospherics/unary/vent_pump/siphon/on/atmos
	use_power = POWER_USE_IDLE
	icon_state = "map_vent_in"
	external_pressure_bound = 0
	external_pressure_bound_default = 0
	internal_pressure_bound = MAX_PUMP_PRESSURE
	internal_pressure_bound_default = MAX_PUMP_PRESSURE
	pressure_checks = 2
	pressure_checks_default = 2

/obj/machinery/atmospherics/unary/vent_pump/Destroy()
	QDEL_NULL(sound_token)
	. = ..()

/obj/machinery/atmospherics/unary/vent_pump/reset_area(area/old_area, area/new_area)
	if(!controlled)
		return
	if(old_area == new_area)
		return
	if(old_area)
		events_repository.unregister(/decl/observ/name_set, old_area, src, PROC_REF(change_area_name))
		old_area.air_vent_info -= id_tag
		old_area.air_vent_names -= id_tag
	if(new_area && new_area == get_area(src))
		events_repository.register(/decl/observ/name_set, new_area, src, PROC_REF(change_area_name))
		if(!new_area.air_vent_names[id_tag])
			var/new_name = "[new_area.proper_name] Vent Pump #[new_area.air_vent_names.len+1]"
			new_area.air_vent_names[id_tag] = new_name
			SetName(new_name)

/obj/machinery/atmospherics/unary/vent_pump/high_volume
	name = "large air vent"
	desc = "A high-volume vent that moves lots of air into or out of the attached pipe system, and uses a valve and pump to prevent backflow."
	power_channel = EQUIP
	power_rating = 45000
	base_type = /obj/machinery/atmospherics/unary/vent_pump/high_volume/buildable

/obj/machinery/atmospherics/unary/vent_pump/high_volume/buildable
	uncreated_component_parts = null

/obj/machinery/atmospherics/unary/vent_pump/high_volume/Initialize()
	. = ..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 800

/obj/machinery/atmospherics/unary/vent_pump/on_update_icon()
	var/visible_directions = build_device_underlays()
	var/vent_prefix = visible_directions ? "" : "h" // h prefix for hidden == no visible directions
	var/vent_icon

	if(welded)
		vent_icon = "weld"
	else if((stat & NOPOWER) || !use_power)
		vent_icon = "off"
	else
		vent_icon += "[pump_direction ? "out" : "in"]"

	icon_state = "[vent_prefix][vent_icon]"

/obj/machinery/atmospherics/unary/vent_pump/hide()
	update_icon()

/obj/machinery/atmospherics/unary/vent_pump/proc/can_pump()
	if(stat & (NOPOWER|BROKEN))
		return 0
	if(!use_power)
		return 0
	if(welded)
		return 0
	return 1

/obj/machinery/atmospherics/unary/vent_pump/Process()
	..()

	if (hibernate > world.time)
		return 1

	if (!LAZYLEN(nodes_to_networks))
		update_use_power(POWER_USE_OFF)
	if(!can_pump())
		return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/power_draw = -1

	//Figure out the target pressure difference
	var/pressure_delta = get_pressure_delta(environment)
	var/transfer_moles

	if((environment.temperature || air_contents.temperature) && pressure_delta > 0.5)
		if(pump_direction) //internal -> external
			transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			power_draw = pump_gas(src, air_contents, environment, transfer_moles, power_rating)
		else //external -> internal
			var/datum/pipe_network/network = network_in_dir(dir)
			transfer_moles = calculate_transfer_moles(environment, air_contents, pressure_delta, network?.volume) / environment.group_multiplier // limit it to just one turf's worth of gas per tick
			power_draw = pump_gas(src, environment, air_contents, transfer_moles, power_rating)

	else
		//If we're in an area that is fucking ideal, and we don't have to do anything, chances are we won't next tick either so why redo these calculations?
		//JESUS FUCK.  THERE ARE LITERALLY 250 OF YOU MOTHERFUCKERS ON ZLEVEL ONE AND YOU DO THIS SHIT EVERY TICK WHEN VERY OFTEN THERE IS NO REASON TO
		if(pump_direction && pressure_checks == PRESSURE_CHECK_EXTERNAL) //99% of all vents
			hibernate = world.time + (rand(100,200))

	if(transfer_moles > 0)
		update_networks()
	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

	return 1

/obj/machinery/atmospherics/unary/vent_pump/proc/get_pressure_delta(datum/gas_mixture/environment)
	var/pressure_delta = DEFAULT_PRESSURE_DELTA
	var/environment_pressure = environment.return_pressure()

	if(pump_direction) //internal -> external
		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta = min(pressure_delta, external_pressure_bound - environment_pressure) //increasing the pressure here
		if(pressure_checks & PRESSURE_CHECK_INTERNAL)
			pressure_delta = min(pressure_delta, air_contents.return_pressure() - internal_pressure_bound) //decreasing the pressure here
	else //external -> internal
		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta = min(pressure_delta, environment_pressure - external_pressure_bound) //decreasing the pressure here
		if(pressure_checks & PRESSURE_CHECK_INTERNAL)
			pressure_delta = min(pressure_delta, internal_pressure_bound - air_contents.return_pressure()) //increasing the pressure here

	return pressure_delta

/obj/machinery/atmospherics/unary/vent_pump/area_uid()
	return controlled ? ..() : "NONE"

/obj/machinery/atmospherics/unary/vent_pump/proc/purge()
	pressure_checks &= ~PRESSURE_CHECK_EXTERNAL
	pump_direction = 0
	queue_icon_update()

/obj/machinery/atmospherics/unary/vent_pump/proc/toggle_pump_dir()
	pump_direction = !pump_direction
	queue_icon_update()

/obj/machinery/atmospherics/unary/vent_pump/refresh()
	..()
	hibernate = FALSE
	toggle_input_toggle()

/obj/machinery/atmospherics/unary/vent_pump/RefreshParts()
	. = ..()
	toggle_input_toggle()

/obj/machinery/atmospherics/unary/vent_pump/attackby(obj/item/used_item, mob/user)
	if(IS_WELDER(used_item))

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
	if(IS_MULTITOOL(used_item))
		var/datum/browser/written_digital/popup = new(user, "Vent Configuration Utility", "[src] Configuration Panel", 600, 200)
		popup.set_content(jointext(get_console_data(),"<br>"))
		popup.open()
		return TRUE

	return ..()

/obj/machinery/atmospherics/unary/vent_pump/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "A small gauge in the corner reads [round(last_flow_rate, 0.1)] L/s; [round(last_power_draw)] W."
	else
		. += "You are too far away to read the gauge."
	if(welded)
		. += "It seems welded shut."

/obj/machinery/atmospherics/unary/vent_pump/cannot_transition_to(state_path, mob/user)
	if(state_path == /decl/machine_construction/default/deconstructed)
		if(!(stat & NOPOWER) && use_power)
			return SPAN_WARNING("You cannot unwrench \the [src], turn it off first.")
		var/turf/T = src.loc
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
			return SPAN_WARNING("You cannot unwrench \the [src], it is too exerted due to internal pressure.")
	return ..()

/obj/machinery/atmospherics/unary/vent_pump/proc/get_console_data()
	. = list()
	. += "<table>"
	. += "<tr><td><b>Name:</b></td><td>[name]</td>"
	. += "<tr><td><b>Pump Status:</b></td><td>[pump_direction?("<font color = 'green'>Releasing</font>"):("<font color = 'red'>Siphoning</font>")]</td><td><a href='byond://?src=\ref[src];switchMode=\ref[src]'>Toggle</a></td></tr>"
	. = JOINTEXT(.)

/obj/machinery/atmospherics/unary/vent_pump/OnTopic(mob/user, href_list, datum/topic_state/state)
	if((. = ..()))
		return
	if(href_list["switchMode"]) // todo: this could easily be refhacked if you don't have a multitool
		toggle_pump_dir()
		to_chat(user, "<span class='notice'>The multitool emits a short beep confirming the change.</span>")
		return TOPIC_REFRESH

/decl/public_access/public_variable/pump_dir
	expected_type = /obj/machinery/atmospherics/unary/vent_pump
	name = "pump direction"
	desc = "The pump mode of the vent. Expected values are \"siphon\" or \"release\"."
	can_write = TRUE
	has_updates = TRUE
	var_type = IC_FORMAT_STRING

/decl/public_access/public_variable/pump_dir/access_var(obj/machinery/atmospherics/unary/vent_pump/machine)
	return machine.pump_direction ? "release" : "siphon"

/decl/public_access/public_variable/pump_dir/write_var(obj/machinery/atmospherics/unary/vent_pump/machine, new_value)
	if(!(new_value in list("release", "siphon")))
		return FALSE
	. = ..()
	if(.)
		machine.pump_direction = (new_value == "release")

/decl/public_access/public_variable/pump_checks
	expected_type = /obj/machinery/atmospherics/unary/vent_pump
	name = "pump checks"
	desc = "Numerical codes for whether the pump checks internal or internal pressure (or both) prior to operating. Can also be supplied the string keyword \"default\"."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_ANY

/decl/public_access/public_variable/pump_checks/access_var(obj/machinery/atmospherics/unary/vent_pump/machine)
	return machine.pressure_checks

/decl/public_access/public_variable/pump_checks/write_var(obj/machinery/atmospherics/unary/vent_pump/machine, new_value)
	if(new_value == "default")
		new_value = machine.pressure_checks_default
	new_value = sanitize_integer(text2num(new_value), 0, 3, machine.pressure_checks)
	. = ..()
	if(.)
		machine.pressure_checks = new_value

/decl/public_access/public_variable/pressure_bound
	expected_type = /obj/machinery/atmospherics/unary/vent_pump
	name = "internal pressure bound"
	desc = "The bound on internal pressure used in checks (a number). When writing, can be supplied the string keyword \"default\" instead."
	can_write = TRUE
	has_updates = FALSE
	var_type = IC_FORMAT_ANY

/decl/public_access/public_variable/pressure_bound/access_var(obj/machinery/atmospherics/unary/vent_pump/machine)
	return machine.internal_pressure_bound

/decl/public_access/public_variable/pressure_bound/write_var(obj/machinery/atmospherics/unary/vent_pump/machine, new_value)
	if(new_value == "default")
		new_value = machine.internal_pressure_bound_default
	new_value = text2num(new_value)
	if(!isnum(new_value))
		return FALSE
	new_value = clamp(new_value, 0, MAX_PUMP_PRESSURE)
	. = ..()
	if(.)
		machine.internal_pressure_bound = new_value

/decl/public_access/public_variable/pressure_bound/external
	expected_type = /obj/machinery/atmospherics/unary/vent_pump
	name = "external pressure bound"
	desc = "The bound on external pressure used in checks (a number). When writing, can be supplied the string keyword \"default\" instead."

/decl/public_access/public_variable/pressure_bound/external/access_var(obj/machinery/atmospherics/unary/vent_pump/machine)
	return machine.external_pressure_bound

/decl/public_access/public_variable/pressure_bound/external/write_var(obj/machinery/atmospherics/unary/vent_pump/machine, new_value)
	if(new_value == "default")
		new_value = machine.external_pressure_bound_default
	new_value = clamp(new_value, 0, MAX_PUMP_PRESSURE)
	. = ..()
	if(.)
		machine.external_pressure_bound = new_value

/decl/public_access/public_method/purge_pump
	name = "activate purge mode"
	desc = "Activates purge mode, overriding pressure checks and removing air."
	call_proc = TYPE_PROC_REF(/obj/machinery/atmospherics/unary/vent_pump, purge)

/decl/public_access/public_method/toggle_pump_dir
	name = "toggle pump direction"
	desc = "Toggles the pump's direction, from release to siphon or vice versa."
	call_proc = TYPE_PROC_REF(/obj/machinery/atmospherics/unary/vent_pump, toggle_pump_dir)

/decl/stock_part_preset/radio/event_transmitter/vent_pump
	frequency = PUMP_FREQ
	filter = RADIO_TO_AIRALARM
	event = /decl/public_access/public_variable/input_toggle
	transmit_on_event = list(
		"area" = /decl/public_access/public_variable/area_uid,
		"device" = /decl/public_access/public_variable/identifier,
		"power" = /decl/public_access/public_variable/use_power,
		"direction" = /decl/public_access/public_variable/pump_dir,
		"checks" = /decl/public_access/public_variable/pump_checks,
		"internal" = /decl/public_access/public_variable/pressure_bound,
		"external" = /decl/public_access/public_variable/pressure_bound/external,
		"power_draw" = /decl/public_access/public_variable/power_draw,
		"flow_rate" = /decl/public_access/public_variable/flow_rate
	)

/decl/stock_part_preset/radio/receiver/vent_pump
	frequency = PUMP_FREQ
	filter = RADIO_FROM_AIRALARM
	receive_and_call = list(
		"power_toggle" = /decl/public_access/public_method/toggle_power,
		"purge" = /decl/public_access/public_method/purge_pump,
		"status" = /decl/public_access/public_method/refresh
	)
	receive_and_write = list(
		"set_power" = /decl/public_access/public_variable/use_power,
		"set_direction" = /decl/public_access/public_variable/pump_dir,
		"set_checks" = /decl/public_access/public_variable/pump_checks,
		"set_internal_pressure" = /decl/public_access/public_variable/pressure_bound,
		"set_external_pressure" = /decl/public_access/public_variable/pressure_bound/external,
		"init" = /decl/public_access/public_variable/name
	)

/decl/stock_part_preset/radio/receiver/vent_pump/tank
	frequency = ATMOS_TANK_FREQ
	filter = null

/decl/stock_part_preset/radio/event_transmitter/vent_pump/tank
	frequency = ATMOS_TANK_FREQ
	filter = null

/obj/machinery/atmospherics/unary/vent_pump/tank
	controlled = FALSE
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/tank = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/tank = 1
	)

/obj/machinery/atmospherics/unary/vent_pump/siphon/on/atmos/tank
	controlled = FALSE
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/tank = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/tank = 1
	)

/decl/stock_part_preset/radio/receiver/vent_pump/external_air
	frequency = EXTERNAL_AIR_FREQ
	filter = null

/decl/stock_part_preset/radio/event_transmitter/vent_pump/external_air
	frequency = EXTERNAL_AIR_FREQ
	filter = null

/obj/machinery/atmospherics/unary/vent_pump/high_volume/external_air
	controlled = FALSE
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/external_air = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/external_air = 1
	)

/decl/stock_part_preset/radio/receiver/vent_pump/shuttle
	frequency = SHUTTLE_AIR_FREQ
	filter = null

/decl/stock_part_preset/radio/event_transmitter/vent_pump/shuttle
	frequency = SHUTTLE_AIR_FREQ
	filter = null

/obj/machinery/atmospherics/unary/vent_pump/high_volume/shuttle
	controlled = FALSE
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/shuttle = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/shuttle = 1
	)

/decl/stock_part_preset/radio/event_transmitter/vent_pump/shuttle/aux
	filter = RADIO_TO_AIRALARM

// This is intended for hybrid airlock-room setups, where unlike the above, this one is controlled by the air alarm and attached to the internal atmos system.
/obj/machinery/atmospherics/unary/vent_pump/shuttle_auxiliary
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/shuttle = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/shuttle/aux = 1
	)

/decl/stock_part_preset/radio/receiver/vent_pump/engine
	frequency = ATMOS_ENGINE_FREQ
	filter = null

/decl/stock_part_preset/radio/event_transmitter/vent_pump/engine
	frequency = ATMOS_ENGINE_FREQ
	filter = null

/obj/machinery/atmospherics/unary/vent_pump/engine
	name = "Engine Core Vent"
	power_channel = ENVIRON
	power_rating = 30000
	controlled = FALSE
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/engine = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/engine = 1
	)

/obj/machinery/atmospherics/unary/vent_pump/engine/Initialize()
	. = ..()
	air_contents.volume = ATMOS_DEFAULT_VOLUME_PUMP + 500 //meant to match air injector

/obj/machinery/atmospherics/unary/vent_pump/power_change()
	. = ..()
	if(.)
		update_sound()

/obj/machinery/atmospherics/unary/vent_pump/proc/update_sound()
	if(!sound_id)
		sound_id = "[sequential_id("vent_z[z]")]"
	if(can_pump())
		sound_token = play_looping_sound(src, sound_id, 'sound/machines/vent_hum.ogg', 10, range = 7, falloff = 4)
	else
		QDEL_NULL(sound_token)

#undef DEFAULT_PRESSURE_DELTA

#undef EXTERNAL_PRESSURE_BOUND
#undef INTERNAL_PRESSURE_BOUND
#undef PRESSURE_CHECKS

#undef PRESSURE_CHECK_EXTERNAL
#undef PRESSURE_CHECK_INTERNAL