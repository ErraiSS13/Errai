/obj/machinery/portable_atmospherics/powered/scrubber
	name = "portable air scrubber"

	icon = 'icons/obj/atmos.dmi'
	icon_state = "pscrubber:0"
	density = TRUE
	w_class = ITEM_SIZE_NORMAL
	base_type = /obj/machinery/portable_atmospherics/powered/scrubber
	atom_flags = ATOM_FLAG_CLIMBABLE
	movable_flags = MOVABLE_FLAG_WHEELED
	var/volume_rate = 800

	volume = 750

	power_rating = 7500 //7500 W ~ 10 HP
	power_losses = 150

	var/minrate = 0
	var/maxrate = 10 ATM

	var/list/scrubbing_gas

/obj/machinery/portable_atmospherics/powered/scrubber/Initialize()
	. = ..()
	if(!scrubbing_gas)
		scrubbing_gas = list()
		for(var/g in decls_repository.get_decl_paths_of_subtype(/decl/material/gas))
			if(g != /decl/material/gas/oxygen && g != /decl/material/gas/nitrogen)
				scrubbing_gas += g

/obj/machinery/portable_atmospherics/powered/scrubber/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(prob(50/severity))
		update_use_power(use_power == POWER_USE_ACTIVE ? POWER_USE_IDLE : POWER_USE_ACTIVE)

	..(severity)

/obj/machinery/portable_atmospherics/powered/scrubber/on_update_icon()
	overlays.Cut()

	if((use_power == POWER_USE_ACTIVE) && !(stat & (NOPOWER | BROKEN)))
		icon_state = "pscrubber:1"
	else
		icon_state = "pscrubber:0"

	if(holding)
		overlays += "scrubber-open"

	if(get_port())
		overlays += "scrubber-connector"

/obj/machinery/portable_atmospherics/powered/scrubber/Process()
	..()
	process_scrubber()

//Placeholder; will change once batteries are made generic.
/obj/machinery/portable_atmospherics/powered/scrubber/proc/process_scrubber()
	var/power_draw = -1

	if((use_power == POWER_USE_ACTIVE) && !(stat & NOPOWER))
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/transfer_moles = min(1, volume_rate/environment.volume)*environment.total_moles

		power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, power_rating)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		power_draw = max(power_draw, power_losses)
		if(abs(power_draw - last_power_draw) > 0.1 * last_power_draw)
			change_power_consumption(power_draw, POWER_USE_ACTIVE)
			last_power_draw = power_draw

		update_connected_network()

		if(holding)
			holding.queue_icon_update()

	//src.update_icon()
	src.updateDialog()

/obj/machinery/portable_atmospherics/powered/scrubber/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/portable_atmospherics/powered/scrubber/ui_interact(mob/user, ui_key = "rcon", datum/nanoui/ui=null, force_open=1)
	var/list/data[0]
	var/obj/item/cell/cell = get_cell()
	data["portConnected"] = get_port() ? 1 : 0
	data["tankPressure"] = round(air_contents.return_pressure() > 0 ? air_contents.return_pressure() : 0)
	data["rate"] = round(volume_rate)
	data["minrate"] = round(minrate)
	data["maxrate"] = round(maxrate)
	data["powerDraw"] = round(last_power_draw)
	data["cellCharge"] = cell ? cell.charge : 0
	data["cellMaxCharge"] = cell ? cell.maxcharge : 1
	data["on"] = (use_power == POWER_USE_ACTIVE) ? 1 : 0

	data["hasHoldingTank"] = holding ? 1 : 0
	if (holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure() > 0 ? holding.air_contents.return_pressure() : 0))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "portscrubber.tmpl", "Portable Scrubber", 480, 400, state = global.physical_topic_state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/portable_atmospherics/powered/scrubber/OnTopic(user, href_list)
	if(href_list["power"])
		update_use_power(use_power == POWER_USE_ACTIVE ? POWER_USE_IDLE : POWER_USE_ACTIVE)
		. = TOPIC_REFRESH
	if (href_list["remove_tank"])
		if(holding)
			holding.dropInto(loc)
			holding = null
		. = TOPIC_REFRESH
	if (href_list["volume_adj"])
		var/diff = text2num(href_list["volume_adj"])
		volume_rate = clamp(volume_rate+diff, minrate, maxrate)
		. = TOPIC_REFRESH

	if(.)
		update_icon()


//Broken scrubber Used in hanger atmoshperic storage
/obj/machinery/portable_atmospherics/powered/scrubber/broken
	construct_state = /decl/machine_construction/default/panel_open
	panel_open = 1

/obj/machinery/portable_atmospherics/powered/scrubber/broken/Initialize()
	. = ..()
	var/part = uninstall_component(/obj/item/stock_parts/power/battery/buildable/stock)
	if(part)
		qdel(part)

//Huge scrubber
/obj/machinery/portable_atmospherics/powered/scrubber/huge
	name = "huge air scrubber"
	icon_state = "scrubber:0"
	anchored = TRUE
	volume = 50000
	volume_rate = 5000
	base_type = /obj/machinery/portable_atmospherics/powered/scrubber/huge

	uncreated_component_parts = list(/obj/item/stock_parts/power/apc)
	maximum_component_parts = list(/obj/item/stock_parts = 15)
	idle_power_usage = 500		//internal circuitry, friction losses and stuff
	power_rating = 100000 //100 kW ~ 135 HP

	var/static/gid = 1
	var/id = 0

/obj/machinery/portable_atmospherics/powered/scrubber/huge/Initialize()
	. = ..()

	id = gid
	gid++

	name = "[name] (ID [id])"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attack_hand(mob/user)
	. = ..() // Buckling, climbers, grab interactions, component attack_hand; unlikely to return true.
	if(!.)
		to_chat(user, SPAN_WARNING("You can't directly interact with this machine. Use the scrubber control console."))
		return TRUE

/obj/machinery/portable_atmospherics/powered/scrubber/huge/on_update_icon()
	cut_overlays()
	icon_state = "scrubber:[!!((use_power == POWER_USE_ACTIVE) && !(stat & (NOPOWER|BROKEN)))]"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attackby(var/obj/item/used_item, var/mob/user)
	if(IS_WRENCH(used_item))
		if(use_power == POWER_USE_ACTIVE)
			to_chat(user, "<span class='warning'>Turn \the [src] off first!</span>")
			return TRUE

		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")

		return TRUE
	//doesn't hold tanks
	if(istype(used_item, /obj/item/tank))
		return FALSE

	return ..()


/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary
	name = "stationary air scrubber"
	base_type = /obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/attackby(var/obj/item/used_item, var/mob/user)
	if(IS_WRENCH(used_item))
		to_chat(user, "<span class='warning'>The bolts are too tight for you to unscrew!</span>")
		return TRUE

	return ..()