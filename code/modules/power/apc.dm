var/global/list/all_apcs = list()

// The Area Power Controller (APC)
// Controls and provides power to most electronics in an area
// Only one required per area
// Requires a wire connection to a power network through a terminal
// Generates a terminal based on the direction of the APC on spawn

// There are three different power channels, lighting, equipment, and environment
// Each may have one of the following states

// Power channels set to Auto change when power levels rise or drop below a threshold
// Power channel defines have been shifted to power.dm in __defines. 2/25/2021

#define AUTO_THRESHOLD_LIGHTING  50
#define AUTO_THRESHOLD_EQUIPMENT 25
// The ENVIRON channel stays on as long as possible, and doesn't have a threshold

#define CRITICAL_APC_EMP_PROTECTION 10	// EMP effect duration is divided by this number if the APC has "critical" flag
#define APC_UPDATE_ICON_COOLDOWN 100	// Time between automatically updating the icon (10 seconds)

// Used to check whether or not to update the icon_state
#define UPDATE_CELL_IN 1
#define UPDATE_OPENED1 2
#define UPDATE_OPENED2 4
#define UPDATE_MAINT 8
#define UPDATE_BROKE 16
#define UPDATE_BLUESCREEN 32
#define UPDATE_WIREEXP 64
#define UPDATE_ALLGOOD 128

// Used to check whether or not to update the overlay
#define APC_UPOVERLAY_CHARGEING0 1
#define APC_UPOVERLAY_CHARGEING1 2
#define APC_UPOVERLAY_CHARGEING2 4
#define APC_UPOVERLAY_LOCKED 8
#define APC_UPOVERLAY_OPERATING 16

// Various APC types
/obj/machinery/power/apc/inactive
	lighting = 0
	equipment = 0
	environ = 0
	locked = FALSE

/obj/machinery/power/apc/critical
	is_critical = 1

/obj/machinery/power/apc/high
	uncreated_component_parts = list(
		/obj/item/cell/high
	)

/obj/machinery/power/apc/high/inactive
	lighting = 0
	equipment = 0
	environ = 0
	locked = FALSE

/obj/machinery/power/apc/super
	uncreated_component_parts = list(
		/obj/item/cell/super
	)

/obj/machinery/power/apc/super/critical
	is_critical = 1

/obj/machinery/power/apc/hyper
	uncreated_component_parts = list(
		/obj/item/cell/hyper
	)

/obj/machinery/power/apc/derelict
	lighting = 0
	equipment = 0
	environ = 0
	locked = 0
	uncreated_component_parts = list(
		/obj/item/cell/crap/empty
	)

/obj/machinery/power/apc/derelict/full
	uncreated_component_parts = list(
		/obj/item/cell/crap
	)

// Main APC code
/obj/machinery/power/apc
	name = "area power controller"
	desc = "A control terminal for the area electrical systems."

	icon_state = "apc0"
	icon = 'icons/obj/apc.dmi'
	anchored = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	use_power = POWER_USE_IDLE // Has custom handling here.
	power_channel = LOCAL      // Do not manipulate this; you don't want to power the APC off itself.
	interact_offline = TRUE    // Can use UI even if unpowered

	initial_access = list(access_engine_equip)
	clicksound = "switch"
	layer = ABOVE_WINDOW_LAYER
	directional_offset = @'{"NORTH":{"y":22}, "SOUTH":{"y":-22}, "EAST":{"x":22}, "WEST":{"x":-22}}'

	var/powered_down = FALSE
	var/area/area
	var/areastring = null
	var/shorted = 0
	var/lighting = POWERCHAN_ON_AUTO
	var/equipment = POWERCHAN_ON_AUTO
	var/environ = POWERCHAN_ON_AUTO
	var/operating = 1       // Bool for main toggle.
	var/charging = 0        // Whether or not it's charging. 0 - not charging but not full, 1 - charging, 2 - full
	var/chargemode = 1      // Whether charging is toggled on or off.
	var/aidisabled = 0
	var/lastused_light = 0    // Internal stuff for UI and bookkeeping; can read off values but don't modify.
	var/lastused_equip = 0
	var/lastused_environ = 0
	var/lastused_charging = 0 // Not an actual channel, and not summed into total. How much battery was recharged, if any, last tick.
	var/lastused_total = 0
	var/main_status = 0     // UI var for whether we are getting external power. 0 = no external power at all, 1 = some, but not enough, 2 = getting enough.
	var/mob/living/silicon/ai/hacker = null // Malfunction var. If set AI hacked the APC and has full control.
	powernet = 0		 // set so that APCs aren't found as powernet nodes //Hackish, Horrible, was like this before I changed it :(
	var/autoflag= 0		 // 0 = off, 1= eqp and lights off, 2 = eqp off, 3 = all on.
	var/beenhit = 0 // used for counting how many times it has been hit, used for Aliens at the moment
	var/longtermpower = 10  // Counter to smooth out power state changes; do not modify.
	wires = /datum/wires/apc
	var/update_state = -1
	var/update_overlay = -1
	var/list/update_overlay_chan		// Used to determine if there is a change in channels
	var/is_critical = 0
	var/static/status_overlays = 0
	var/failure_timer = 0               // Cooldown thing for apc outage event
	var/force_update = 0
	var/emp_hardened = 0
	var/static/list/status_overlays_lock
	var/static/list/status_overlays_charging
	var/static/list/status_overlays_equipment
	var/static/list/status_overlays_lighting
	var/static/list/status_overlays_environ
	var/remote_control = FALSE //is remote control enabled?
	var/autoname = 1
	var/cover_removed = FALSE           // Cover is gone; can't close it anymore.
	var/locked = TRUE                   // This is the interface, not the hardware.

	base_type = /obj/machinery/power/apc/buildable
	stat_immune = 0
	frame_type = /obj/item/frame/apc
	construct_state = /decl/machine_construction/wall_frame/panel_closed/hackable
	uncreated_component_parts = list(
		/obj/item/cell/apc
	)
	stock_part_presets = list(/decl/stock_part_preset/terminal_setup)

/obj/machinery/power/apc/buildable
	uncreated_component_parts = null

/obj/machinery/power/apc/connect_to_network()
	//Override because the APC does not directly connect to the network; it goes through a terminal.
	//The terminal is what the power computer looks for anyway.
	var/obj/machinery/power/terminal/terminal = terminal()
	if(terminal)
		terminal.connect_to_network()

/obj/machinery/power/apc/drain_power(var/drain_check, var/surge, var/amount = 0)

	if(drain_check)
		return 1

	// Prevents APCs from being stuck on 0% cell charge while reporting "Fully Charged" status.
	charging = 0

	// If the APC's interface is locked, limit the charge rate to 25%.
	if(locked)
		amount /= 4

	return amount - use_power_oneoff(amount, LOCAL)

/obj/machinery/power/apc/Initialize(mapload, var/ndir, var/populate_parts = TRUE)
	global.all_apcs += src
	if(areastring)
		reset_area(null, get_area_by_name(strip_improper(areastring)))
	else if (mapload) //if area isn't specified during mapload use current
		reset_area(null, get_area(src))
	// otherwise, it'll be handled by Entered/area_changed
	if(!area)
		return ..() // Spawned in nullspace means it's a test entity or prototype.

	. = ..()

	if(!populate_parts)
		operating = 0

	queue_icon_update()

	if(operating)
		force_update_channels()
	power_change()

/obj/machinery/power/apc/Destroy()
	if(area)
		reset_area(area, null)
	global.all_apcs -= src

	// Malf AI, removes the APC from AI's hacked APCs list.
	if((hacker) && (hacker.hacked_apcs) && (src in hacker.hacked_apcs))
		hacker.hacked_apcs -= src

	return ..()

// Attempts to set the area and update all refs. Calling this outside of Initialize is experimental at best.
/obj/machinery/power/apc/proc/reset_area(area/old_area, area/new_area)
	if(new_area == old_area)
		return
	if(old_area && old_area == area)
		area = null
		old_area.apc = null
		old_area.power_light = 0
		old_area.power_equip = 0
		old_area.power_environ = 0
		power_alarm.clearAlarm(old_area, src)
		old_area.power_change()
		events_repository.unregister(/decl/observ/name_set, old_area, src, PROC_REF(change_area_name))
	if(new_area)
		ASSERT(isnull(new_area.apc))
		ASSERT(isnull(area))
		new_area.apc = src
		area = new_area
		change_area_name(new_area, null, new_area.name)
		events_repository.register(/decl/observ/name_set, new_area, src, PROC_REF(change_area_name))

/obj/machinery/power/apc/get_req_access()
	if(!locked)
		return list()
	return ..()

/obj/machinery/power/apc/proc/energy_fail(var/duration)
	if(emp_hardened)
		return
	if(!failure_timer && duration)
		playsound(src, 'sound/machines/apc_nopower.ogg', 75, 0)
	failure_timer = max(failure_timer, round(duration))

/obj/machinery/power/apc/proc/terminal(var/functional_only)
	var/obj/item/stock_parts/power/terminal/term = get_component_of_type(/obj/item/stock_parts/power/terminal)
	if(term && (!functional_only || term.is_functional()))
		return term.terminal

/obj/machinery/power/apc/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		if(stat & BROKEN)
			. += "Looks broken."
			return
		var/terminal = terminal()
		. += "\The [src] is [terminal ? "" : "not "]connected to external power."
		if(!panel_open)
			. += "The cover is closed."
		else
			. += "The cover is [cover_removed ? "removed" : "open"] and the power cell is [ get_cell(FALSE) ? "installed" : "missing"]."
//  Broken/missing board should be shown by parent.

// update the APC icon to show the three base states
// also add overlays for indicator lights
/obj/machinery/power/apc/on_update_icon()
	if (!status_overlays)
		status_overlays = 1
		status_overlays_lock = new
		status_overlays_charging = new
		status_overlays_equipment = new
		status_overlays_lighting = new
		status_overlays_environ = new

		status_overlays_lock.len = 2
		status_overlays_charging.len = 3
		status_overlays_equipment.len = 5
		status_overlays_lighting.len = 5
		status_overlays_environ.len = 5

		status_overlays_lock[1] = image(icon, "apcox-0")    // 0=blue 1=red
		status_overlays_lock[2] = image(icon, "apcox-1")

		status_overlays_charging[1] = image(icon, "apco3-0")
		status_overlays_charging[2] = image(icon, "apco3-1")
		status_overlays_charging[3] = image(icon, "apco3-2")

		var/list/channel_overlays = list(status_overlays_equipment, status_overlays_lighting, status_overlays_environ)
		var/channel = 0
		for(var/list/channel_leds in channel_overlays)
			channel_leds[POWERCHAN_OFF + 1] = overlay_image(icon,"apco[channel]",COLOR_RED)
			channel_leds[POWERCHAN_OFF_TEMP + 1] = overlay_image(icon,"apco[channel]",COLOR_ORANGE)
			channel_leds[POWERCHAN_OFF_AUTO + 1] = overlay_image(icon,"apco[channel]",COLOR_ORANGE)
			channel_leds[POWERCHAN_ON + 1] = overlay_image(icon,"apco[channel]",COLOR_LIME)
			channel_leds[POWERCHAN_ON_AUTO + 1] = overlay_image(icon,"apco[channel]",COLOR_BLUE)
			channel++

	var/update = check_updates() 		//returns 0 if no need to update icons.
						// 1 if we need to update the icon_state
						// 2 if we need to update the overlays

	if(!update)
		return

	if(update & 1) // Updating the icon state
		if(update_state & UPDATE_ALLGOOD)
			icon_state = "apc0"
		else if(update_state & (UPDATE_OPENED1|UPDATE_OPENED2))
			var/basestate = "apc[ get_cell(FALSE) ? "2" : "1" ]"
			if(update_state & UPDATE_OPENED1)
				if(update_state & (UPDATE_MAINT|UPDATE_BROKE))
					icon_state = "apcmaint" //disabled APC cannot hold cell
				else
					icon_state = basestate
			else if(update_state & UPDATE_OPENED2)
				icon_state = "[basestate]-nocover"
		else if(update_state & UPDATE_BROKE)
			icon_state = "apc-b"
		else if(update_state & UPDATE_BLUESCREEN)
			icon_state = "apcemag"
		else if(update_state & UPDATE_WIREEXP)
			icon_state = "apcewires"

	if(!(update_state & UPDATE_ALLGOOD))
		if(overlays.len)
			overlays.Cut()
			return

	if(update & 2)
		if(overlays.len)
			overlays.Cut()
		if(!(stat & (BROKEN|MAINT)) && update_state & UPDATE_ALLGOOD)
			overlays += status_overlays_lock[locked+1]
			if(!(stat & NOSCREEN))
				overlays += status_overlays_charging[charging+1]
			if(operating)
				overlays += status_overlays_equipment[equipment+1]
				overlays += status_overlays_lighting[lighting+1]
				overlays += status_overlays_environ[environ+1]

	if(update & 3)
		if((update_state & (UPDATE_OPENED1|UPDATE_OPENED2|UPDATE_BROKE)) || (stat & NOSCREEN))
			set_light(0)
		else if(update_state & UPDATE_BLUESCREEN)
			set_light(l_range = 2, l_power = 0.5, l_color = "#00ecff")
		else if(!(stat & (BROKEN|MAINT)) && update_state & UPDATE_ALLGOOD)
			var/color
			switch(charging)
				if(0)
					color = "#f86060"
				if(1)
					color = "#a8b0f8"
				if(2)
					color = "#82ff4c"
			set_light(l_range = 2, l_power = 0.5, l_color = color)
		else
			set_light(0)

/obj/machinery/power/apc/proc/check_updates()
	if(!update_overlay_chan)
		update_overlay_chan = new/list()
	var/last_update_state = update_state
	var/last_update_overlay = update_overlay
	var/list/last_update_overlay_chan = update_overlay_chan.Copy()
	update_state = 0
	update_overlay = 0
	if(get_cell(FALSE))
		update_state |= UPDATE_CELL_IN
	if(stat & BROKEN)
		update_state |= UPDATE_BROKE
	if(stat & MAINT)
		update_state |= UPDATE_MAINT
	if(panel_open)
		if(!cover_removed)
			update_state |= UPDATE_OPENED1
		else
			update_state |= UPDATE_OPENED2
	else if(emagged || (hacker && !hacker.hacked_apcs_hidden) || failure_timer)
		update_state |= UPDATE_BLUESCREEN
	else if(istype(construct_state, /decl/machine_construction/wall_frame/panel_closed/hackable/hacking))
		update_state |= UPDATE_WIREEXP
	if(update_state <= 1)
		update_state |= UPDATE_ALLGOOD

	if(operating)
		update_overlay |= APC_UPOVERLAY_OPERATING

	if(update_state & UPDATE_ALLGOOD)
		if(locked)
			update_overlay |= APC_UPOVERLAY_LOCKED

		if(!charging)
			update_overlay |= APC_UPOVERLAY_CHARGEING0
		else if(charging == 1)
			update_overlay |= APC_UPOVERLAY_CHARGEING1
		else if(charging == 2)
			update_overlay |= APC_UPOVERLAY_CHARGEING2


		update_overlay_chan["Equipment"] = equipment
		update_overlay_chan["Lighting"] = lighting
		update_overlay_chan["Enviroment"] = environ


	var/results = 0
	if(last_update_state == update_state && last_update_overlay == update_overlay && last_update_overlay_chan == update_overlay_chan)
		return 0
	if(last_update_state != update_state)
		results += 1
	if(last_update_overlay != update_overlay || last_update_overlay_chan != update_overlay_chan)
		results += 2
	return results

/obj/machinery/power/apc/set_broken(new_state, cause)
	. = ..()
	if(. && (stat & BROKEN))
		operating = 0
		update()

/obj/machinery/power/apc/cannot_transition_to(state_path, mob/user)
	if(ispath(state_path, /decl/machine_construction/wall_frame/panel_open))
		for(var/obj/item/stock_parts/access_lock/lock in get_all_components_of_type(/obj/item/stock_parts/access_lock))
			if(lock.locked)
				return SPAN_WARNING("You cannot open the cover: it is locked!")
	if(ispath(state_path, /decl/machine_construction/wall_frame/panel_closed) && cover_removed)
		return SPAN_WARNING("You cannot close the cover: it was completely removed!")
	. = ..()

/obj/machinery/power/apc/proc/force_open_panel(mob/user)
	var/decl/machine_construction/wall_frame/panel_closed/closed_state = construct_state
	if(!istype(closed_state))
		return MCS_CONTINUE
	var/list/locks = get_all_components_of_type(/obj/item/stock_parts/access_lock)
	for(var/obj/item/stock_parts/access_lock/lock in locks)
		lock.locked = FALSE
	. = closed_state.try_change_state(src, closed_state.open_state, user)
	if(. != MCS_CHANGE)
		return
	panel_open = TRUE
	queue_icon_update()

/obj/machinery/power/apc/attackby(obj/item/used_item, mob/user)
	if (istype(construct_state, /decl/machine_construction/wall_frame/panel_closed/hackable/hacking) && (IS_MULTITOOL(used_item) || IS_WIRECUTTER(used_item) || istype(used_item, /obj/item/assembly/signaler)))
		wires.Interact(user)
		return TRUE
	return ..()

/obj/machinery/power/apc/bash(obj/item/used_item, mob/user)
	if (!(user.check_intent(I_FLAG_HARM)) || (used_item.item_flags & ITEM_FLAG_NO_BLUDGEON))
		return FALSE

	if(!used_item.user_can_attack_with(user))
		return FALSE

	. = ..()
	if(. && !panel_open && used_item.w_class >= ITEM_SIZE_NORMAL)
		if (((stat & BROKEN) || (hacker && !hacker.hacked_apcs_hidden))	&& prob(20))
			playsound(get_turf(src), 'sound/weapons/smash.ogg', 75, TRUE)
			if(force_open_panel(user) == MCS_CHANGE)
				cover_removed = TRUE
				user.visible_message(
					SPAN_DANGER("\The [user] knocks open the APC cover with \the [used_item]!"),
					SPAN_DANGER("You knock down the APC cover with your [used_item.name]!"),
					"You hear a bang."
				)

// attack with hand - remove cell (if cover open) or interact with the APC

/obj/machinery/power/apc/emag_act(var/remaining_charges, var/mob/user)
	if (!(emagged || (hacker && !hacker.hacked_apcs_hidden)))		// trying to unlock with an emag card
		if(panel_open)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else if(stat & (BROKEN|MAINT))
			to_chat(user, "Nothing happens.")
		else
			flick("apc-spark", src)
			if (do_after(user,6,src))
				if(prob(50))
					emagged = 1
					req_access.Cut()
					locked = 0
					to_chat(user, "<span class='notice'>You emag the APC interface.</span>")
					update_icon()
				else if(prob(50))
					return max(..(), 1) // might unlock the panel lock instead.
				else
					to_chat(user, "<span class='warning'>You fail to [ locked ? "unlock" : "lock"] the APC interface.</span>")
				return 1

/obj/machinery/power/apc/CanUseTopicPhysical(var/mob/user)
	return global.physical_topic_state.can_use_topic(nano_host(), user)

/obj/machinery/power/apc/physical_attack_hand(mob/user)
	//Human mob special interaction goes here.
	if(user.can_shred())
		user.visible_message(
			SPAN_DANGER("\The [user] slashes at \the [src]!"),
			SPAN_DANGER("You slash at \the [src]!")
		)
		playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)
		var/allcut = wires.IsAllCut()
		if(beenhit >= pick(3, 4) && allcut == 0)
			wires.CutAll()
			update_icon()
			visible_message(SPAN_DANGER("\The [src]'s wires are shredded!"))
		else
			beenhit += 1
		return TRUE
	return FALSE

/obj/machinery/power/apc/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/power/apc/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!user)
		return
	var/obj/item/cell/cell = get_cell()
	var/coverlocked = FALSE
	for(var/obj/item/stock_parts/access_lock/lock in get_all_components_of_type(/obj/item/stock_parts/access_lock))
		if(lock.locked)
			coverlocked = TRUE
			break

	var/list/data = list(
		"pChan_Off" = POWERCHAN_OFF,
		"pChan_Off_T" = POWERCHAN_OFF_TEMP,
		"pChan_Off_A" = POWERCHAN_OFF_AUTO,
		"pChan_On" = POWERCHAN_ON,
		"pChan_On_A" = POWERCHAN_ON_AUTO,
		"locked" = locked,
		"isOperating" = operating,
		"externalPower" = main_status,
		"powerCellStatus" = cell ? cell.percent() : null,
		"chargeMode" = chargemode,
		"chargingStatus" = charging,
		"totalLoad" = round(lastused_total),
		"totalCharging" = round(lastused_charging),
		"coverLocked" = coverlocked,
		"failTime" = failure_timer * 2,
		"siliconUser" = issilicon(user),
		"remote_control" = remote_control,
		"powerChannels" = list(
			list(
				"title" = "Equipment",
				"powerLoad" = lastused_equip,
				"status" = equipment,
				"topicParams" = list(
					"auto" = list("eqp" = 2),
					"on"   = list("eqp" = 1),
					"off"  = list("eqp" = 0)
				)
			),
			list(
				"title" = "Lighting",
				"powerLoad" = round(lastused_light),
				"status" = lighting,
				"topicParams" = list(
					"auto" = list("lgt" = 2),
					"on"   = list("lgt" = 1),
					"off"  = list("lgt" = 0)
				)
			),
			list(
				"title" = "Environment",
				"powerLoad" = round(lastused_environ),
				"status" = environ,
				"topicParams" = list(
					"auto" = list("env" = 2),
					"on"   = list("env" = 1),
					"off"  = list("env" = 0)
				)
			)
		)
	)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "apc.tmpl", "[area? area.proper_name : "ERROR"] - APC", 520, data["siliconUser"] ? 465 : 440)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/apc/proc/update()
	var/old_power_light = area.power_light
	var/old_power_environ = area.power_environ
	var/old_power_equip = area.power_equip
	if(operating && !shorted && !failure_timer)

		area.power_light = (lighting >= POWERCHAN_ON)
		area.power_equip = (equipment >= POWERCHAN_ON)
		area.power_environ = (environ >= POWERCHAN_ON)

		//prevent unnecessary updates to emergency lighting
		if(area.power_light != old_power_light)
			area.set_emergency_lighting(lighting == POWERCHAN_OFF_AUTO) //if lights go auto-off, emergency lights go on
	else
		area.power_light = 0
		area.power_equip = 0
		area.power_environ = 0

	if(area.power_light != old_power_light || area.power_environ != old_power_environ || area.power_equip != old_power_equip)
		area.power_change()

	var/obj/item/cell/cell = get_cell()
	if(!powered_down)
		if(!cell || cell.charge <= 0)
			playsound(src, 'sound/machines/apc_nopower.ogg', 75, 0)
			powered_down  = TRUE

	else if(cell?.charge > 0)
		powered_down  = FALSE

/obj/machinery/power/apc/CanUseTopic(mob/user, datum/topic_state/state)
	if(user.current_posture.prone)
		to_chat(user, "<span class='warning'>You must stand to use [src]!</span>")
		return STATUS_CLOSE
	if(issilicon(user))
		var/permit = 0 // Malfunction variable. If AI hacks APC it can control it even without AI control wire.
		var/mob/living/silicon/ai/AI = user
		var/mob/living/silicon/robot/robot = user
		if(hacker && !hacker.hacked_apcs_hidden)
			if(hacker == AI)
				permit = 1
			else if(istype(robot) && robot.connected_ai && robot.connected_ai == hacker) // Cyborgs can use APCs hacked by their AI
				permit = 1

		if(aidisabled && !permit)
			return STATUS_CLOSE
	. = ..()
	if(user.restrained())
		to_chat(user, "<span class='warning'>You must have free hands to use [src].</span>")
		. = min(., STATUS_UPDATE)

/obj/machinery/power/apc/OnTopic(mob/user, list/href_list, state)
	if(href_list["reboot"] )
		failure_timer = 0
		update_icon()
		update()
		return TOPIC_REFRESH

	if(href_list["toggleaccess"])
		if(emagged || (stat & (BROKEN|MAINT)) || (hacker && !hacker.hacked_apcs_hidden))
			to_chat(user, "The APC does not respond to the command.")
		else
			locked = !locked
			update_icon()
		return TOPIC_REFRESH

	if(locked)
		return TOPIC_REFRESH

	if(href_list["lock"])
		var/coverlocked = FALSE
		var/list/locks = get_all_components_of_type(/obj/item/stock_parts/access_lock)
		for(var/obj/item/stock_parts/access_lock/lock in locks)
			if(lock.locked)
				coverlocked = TRUE
				break
		for(var/obj/item/stock_parts/access_lock/lock in locks)
			lock.locked = !coverlocked
		return TOPIC_REFRESH

	if(href_list["breaker"])
		toggle_breaker()
		return TOPIC_REFRESH

	if(href_list["cmode"])
		set_chargemode(!chargemode)
		if(!chargemode)
			charging = 0
			update_icon()
		return TOPIC_REFRESH

	if(href_list["eqp"])
		var/val = text2num(href_list["eqp"])
		equipment = setsubsystem(val)
		force_update_channels()
		return TOPIC_REFRESH

	if(href_list["lgt"])
		var/val = text2num(href_list["lgt"])
		lighting = setsubsystem(val)
		force_update_channels()
		return TOPIC_REFRESH

	if(href_list["env"])
		var/val = text2num(href_list["env"])
		environ = setsubsystem(val)
		force_update_channels()
		return TOPIC_REFRESH

	if(href_list["overload"])
		if(issilicon(user))
			overload_lighting()
		return TOPIC_REFRESH

	if(href_list["toggle_rc"])
		remote_control = !remote_control
		return TOPIC_REFRESH

/obj/machinery/power/apc/proc/force_update_channels()
	autoflag = -1 // This clears state, forcing a full recalculation
	update_channels(TRUE)
	update()
	queue_icon_update()

/obj/machinery/power/apc/proc/toggle_breaker()
	operating = !operating
	force_update_channels()

/obj/machinery/power/apc/get_power_usage()
	if(autoflag)
		return lastused_total // If not, we need to do something more sophisticated: compute how much power we would need in order to come back online.
	. = 0
	if(!area)
		return
	if(autoset(lighting, 2) >= POWERCHAN_ON)
		. += area.usage(LIGHT)
	if(autoset(equipment, 2) >= POWERCHAN_ON)
		. += area.usage(EQUIP)
	if(autoset(environ, 1) >= POWERCHAN_ON)
		. += area.usage(ENVIRON)

/obj/machinery/power/apc/Process()
	if(!area?.requires_power)
		return PROCESS_KILL

	if(stat & (BROKEN|MAINT))
		return

	if(failure_timer)
		update()
		queue_icon_update()
		failure_timer--
		force_update = 1
		return

	lastused_light = (lighting >= POWERCHAN_ON) ? area.usage(LIGHT) : 0
	lastused_equip = (equipment >= POWERCHAN_ON) ? area.usage(EQUIP) : 0
	lastused_environ = (environ >= POWERCHAN_ON) ? area.usage(ENVIRON) : 0
	area.clear_usage()

	lastused_total = lastused_light + lastused_equip + lastused_environ

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/obj/machinery/power/terminal/terminal = terminal(TRUE)
	var/avail = (terminal && terminal.avail()) || 0
	var/excess = (terminal && terminal.surplus()) || 0

	if(!avail)
		main_status = 0
	else if(excess < 0)
		main_status = 1
	else
		main_status = 2

	var/obj/item/cell/cell = get_cell()
	if(!cell || shorted) // We aren't going to be doing any power processing in this case.
		charging = 0
	else
		//update state
		var/obj/item/stock_parts/power/battery/power = get_component_of_type(/obj/item/stock_parts/power/battery)
		lastused_charging = max(power && power.cell && (power.cell.charge - power.last_cell_charge) * CELLRATE, 0)
		charging = lastused_charging ? 1 : 0
		if(cell.fully_charged())
			charging = 2

		if(stat & NOPOWER)
			power_change() // We are the ones responsible for triggering listeners once power returns, so we run this to detect possible changes.

	// Set channels depending on how much charge we have left
	update_channels()

	// update icon & area power if anything changed
	if(last_lt != lighting || last_eq != equipment || last_en != environ || force_update)
		force_update = 0
		queue_icon_update()
		update()
	else if (last_ch != charging)
		queue_icon_update()

/obj/machinery/power/apc/proc/update_channels(suppress_alarms = FALSE)
	// Allow the APC to operate as normal if the cell can charge
	if(charging && longtermpower < 10)
		longtermpower += 1
	else if(longtermpower > -10)
		longtermpower -= 2
	var/obj/item/cell/cell = get_cell()
	var/percent = cell && cell.percent()

	if(!cell || shorted || (stat & NOPOWER) || !operating)
		if(autoflag != 0)
			equipment = autoset(equipment, 0)
			lighting = autoset(lighting, 0)
			environ = autoset(environ, 0)
			if(!suppress_alarms)
				power_alarm.triggerAlarm(loc, src)
			autoflag = 0
	else if((percent > AUTO_THRESHOLD_LIGHTING) || longtermpower >= 0)              // Put most likely at the top so we don't check it last, effeciency 101
		if(autoflag != 3)
			equipment = autoset(equipment, 1)
			lighting = autoset(lighting, 1)
			environ = autoset(environ, 1)
			autoflag = 3
			power_alarm.clearAlarm(loc, src)
	else if((percent <= AUTO_THRESHOLD_LIGHTING) && (percent > AUTO_THRESHOLD_EQUIPMENT) && longtermpower < 0)                       // <50%, turn off lighting
		if(autoflag != 2)
			equipment = autoset(equipment, 1)
			lighting = autoset(lighting, 2)
			environ = autoset(environ, 1)
			if(!suppress_alarms)
				power_alarm.triggerAlarm(loc, src)
			autoflag = 2
	else if(percent <= AUTO_THRESHOLD_EQUIPMENT)        // <25%, turn off lighting & equipment
		if(autoflag != 1)
			equipment = autoset(equipment, 2)
			lighting = autoset(lighting, 2)
			environ = autoset(environ, 1)
			if(!suppress_alarms)
				power_alarm.triggerAlarm(loc, src)
			autoflag = 1

// val 0=off, 1=off(auto) 2=on 3=on(auto)
// on 0=off, 1=on, 2=autooff
// defines a state machine, returns the new state
/obj/machinery/power/apc/proc/autoset(var/cur_state, var/on)
	//autoset will never turn on a channel set to off
	switch(cur_state)
		if(POWERCHAN_OFF_TEMP)
			if(on == 1 || on == 2)
				return POWERCHAN_ON
		if(POWERCHAN_OFF_AUTO)
			if(on == 1)
				return POWERCHAN_ON_AUTO
		if(POWERCHAN_ON)
			if(on == 0)
				return POWERCHAN_OFF_TEMP
		if(POWERCHAN_ON_AUTO)
			if(on == 0 || on == 2)
				return POWERCHAN_OFF_AUTO

	return cur_state //leave unchanged


// damage and destruction acts
/obj/machinery/power/apc/emp_act(severity)
	if(emp_hardened)
		return
	// Fail for 8-12 minutes (divided by severity)
	// Division by 2 is required, because machinery ticks are every two seconds. Without it we would fail for 16-24 minutes.
	if(is_critical)
		// Critical APCs are considered EMP shielded and will be offline only for about half minute. Prevents AIs being one-shot disabled by EMP strike.
		// Critical APCs are also more resilient to cell corruption/power drain.
		energy_fail(rand(240, 360) / severity / CRITICAL_APC_EMP_PROTECTION)
	else
		// Regular APCs fail for normal time.
		energy_fail(rand(240, 360) / severity)
	queue_icon_update()
	..()

/obj/machinery/power/apc/on_component_failure(obj/item/stock_parts/component)
	var/was_broken = stat & BROKEN
	. = ..()
	if(!was_broken && (stat & BROKEN))
		visible_message("<span class='notice'>[src]'s screen flickers with warnings briefly!</span>")
		power_alarm.triggerAlarm(loc, src)
		spawn(rand(2,5))
			operating = 0
			update()

/obj/machinery/power/apc/proc/set_chargemode(new_mode)
	chargemode = new_mode
	var/obj/item/stock_parts/power/battery/power = get_component_of_type(/obj/item/stock_parts/power/battery)
	if(power)
		power.can_charge = chargemode
		power.charge_wait_counter = initial(power.charge_wait_counter)

/obj/machinery/power/apc/proc/change_area_name(var/area/A, var/old_area_name, var/new_area_name)
	if(A != area || !autoname)
		return
	SetName("[A.proper_name] APC")

// overload the lights in this APC area
/obj/machinery/power/apc/proc/overload_lighting(var/chance = 100)
	if(/* !get_connection() || */ !operating || shorted)
		return
	var/amount = use_power_oneoff(20, LOCAL)
	if(amount <= 0)
		spawn(0)
			for(var/obj/machinery/light/L in area)
				if(prob(chance))
					L.on = 1
					L.broken()
				sleep(1)

/obj/machinery/power/apc/proc/setsubsystem(val)
	switch(val)
		if(2)
			return POWERCHAN_OFF_AUTO
		if(1)
			return POWERCHAN_OFF_TEMP
		else
			return POWERCHAN_OFF
/obj/machinery/power/apc/proc/set_channel_state_manual(var/channel, var/state)
	switch(channel)
		if(APC_POWERCHAN_EQUIPMENT)
			equipment = state
		if(APC_POWERCHAN_LIGHTING)
			lighting = state
		if(APC_POWERCHAN_ENVIRONMENT)
			environ = state
	force_update_channels()

/obj/machinery/power/apc/area_changed(area/old_area, area/new_area)
	. = ..()
	if(QDELETED(src))
		return
	if(. && !areastring) // if areastring is there, we do not update our area as we are supposed to be operating in some kind of "remote" mode
		reset_area(old_area, new_area)
		// Attempting the most aggressive recalculation available here; unclear if this is "correct."
		force_update_channels()
		power_change()
	//Make sure to resume processing if our area changed to something else than null
	if(area && !(processing_flags & MACHINERY_PROCESS_SELF))
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

#undef APC_UPDATE_ICON_COOLDOWN
