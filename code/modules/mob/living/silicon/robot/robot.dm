/// Multiplier for amount of power cyborgs use.
#define CYBORG_POWER_USAGE_MULTIPLIER 2.5

/mob/living/silicon/robot
	name = "robot"
	real_name = "robot"
	icon = 'icons/mob/robots/robot.dmi'
	icon_state = ICON_STATE_WORLD
	max_health = 300
	mob_sort_value = 4
	z_flags = ZMM_MANGLE_PLANES
	mob_bump_flag = ROBOT
	mob_swap_flags = ROBOT|MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = ~HEAVY
	skillset = /datum/skillset/silicon/robot
	silicon_camera = /obj/item/camera/siliconcam/robot_camera
	silicon_radio = /obj/item/radio/borg
	light_wedge = LIGHT_WIDE

	var/panel_icon = 'icons/mob/robots/_panels.dmi'
	 /// Is our integrated light on?
	var/lights_on = 0
	var/used_power_this_tick = 0
	var/power_efficiency = 1
	var/sight_mode = 0
	var/custom_name = ""
	/// Admin-settable for combat module use.
	var/crisis
	var/crisis_override = 0
	var/integrated_light_power = 0.6
	var/integrated_light_range = 4
	var/datum/wires/robot/wires
	var/module_category = ROBOT_MODULE_TYPE_GROUNDED
	var/dismantle_type = /obj/item/robot_parts/robot_suit
	/// If icon selection has been completed yet
	var/icon_selected = TRUE

	var/obj/item/robot_module/module = null
	var/mob/living/silicon/ai/connected_ai = null
	var/obj/item/cell/cell = /obj/item/cell/high
	var/cell_emp_mult = 2.5
	/// Components are basically robot organs.
	var/list/components = list()
	var/obj/item/organ/internal/central_processor
	var/opened = 0
	var/emagged = 0
	var/wiresexposed = 0
	var/locked = 1
	var/has_power = 1
	var/spawn_sound = 'sound/voice/liveagain.ogg'
	var/pitch_toggle = 1
	var/list/req_access = list(access_robotics)
	var/ident = 0
	var/modtype = "Default"
	var/killswitch = 0
	var/killswitch_time = 60
	var/weapon_lock = 0
	var/weaponlock_time = 120
	/// Cyborgs will sync their laws with their AI by default
	var/lawupdate = 1
	/// If a robot is locked down
	var/lockcharge
	/// Cause sec borgs gotta go fast //No they dont!
	var/speed = 0
	/// Used to determine if a borg shows up on the robotics console.  Setting to one hides them.
	var/scrambledcodes = 0
	/// The number of known entities currently accessing the internal camera
	var/tracking_entities = 0
	var/braintype = "Cyborg"
	/// Whether cyborg's integrated light was upgraded
	var/intenselight = 0
	var/vtec = FALSE
	var/list/robot_verbs_default = list(
		/mob/living/silicon/robot/proc/sensor_mode,
		/mob/living/silicon/robot/proc/robot_checklaws
	)

/mob/living/silicon/robot/Initialize()

	add_held_item_slot(new /datum/inventory_slot/gripper/robot/one)
	add_held_item_slot(new /datum/inventory_slot/gripper/robot/two)
	add_held_item_slot(new /datum/inventory_slot/gripper/robot/three)

	reset_hud_overlays()

	. = ..()

	add_language(/decl/language/binary, 1)
	add_language(/decl/language/machine, 1)
	add_language(/decl/language/human/common, 1)

	wires = new(src)

	ident = random_id(/mob/living/silicon/robot, 1, 999)

	updatename(modtype)
	update_icon()

	if(!scrambledcodes)
		set_extension(src, /datum/extension/network_device/camera/robot, null, null, null, TRUE, list(CAMERA_CHANNEL_ROBOTS), name)
		verbs |= /mob/living/silicon/robot/proc/configure_camera
	init()
	initialize_components()

	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components[V]
		C.installed = 1
		C.wrapped = new C.external_type

	if(ispath(cell))
		cell = new cell(src)

	if(cell)
		var/datum/robot_component/cell_component = components["power cell"]
		cell_component.wrapped = cell
		cell_component.installed = 1

	add_robot_verbs()

	// Disables lay down verb for robots due they're can't lay down and it cause some movement, vision issues.
	verbs -= /mob/living/verb/lay_down

	AddMovementHandler(/datum/movement_handler/robot/use_power, /datum/movement_handler/mob/space)

/mob/living/silicon/robot/proc/recalculate_synth_capacities()
	if(!module || !module.synths)
		return
	var/mult = 1
	for(var/obj/item/stock_parts/matter_bin/storage in stock_parts)
		if(storage.is_functional())
			mult += storage.rating
	for(var/datum/matter_synth/M in module.synths)
		M.set_multiplier(mult)

/mob/living/silicon/robot/proc/init()
	if(ispath(module))
		new module(src)
	if(lawupdate)
		var/new_ai = select_active_ai_with_fewest_borgs(get_z(src))
		if(new_ai)
			lawupdate = 1
			connect_to_ai(new_ai)
		else
			lawupdate = 0

	playsound(loc, spawn_sound, 75, pitch_toggle)

/mob/living/silicon/robot/fully_replace_character_name(pickedName as text)
	custom_name = pickedName
	updatename()

/mob/living/silicon/robot/proc/sync()
	if(lawupdate && connected_ai)
		lawsync()
		photosync()

/mob/living/silicon/robot/drain_power(var/drain_check, var/surge, var/amount = 0)

	if(drain_check)
		return 1

	if(!cell || !cell.charge)
		return 0

	// Actual amount to drain from cell, using CELLRATE
	var/cell_amount = amount * CELLRATE

	if(cell.charge > cell_amount)
		// Spam Protection
		if(prob(10))
			to_chat(src, "<span class='danger'>Warning: Unauthorized access through power channel [rand(11,29)] detected!</span>")
		cell.use(cell_amount)
		return amount
	return 0

/mob/living/silicon/robot/Destroy()
	QDEL_NULL(central_processor)
	if(connected_ai)
		connected_ai.connected_robots -= src
	connected_ai = null
	QDEL_NULL(module)
	QDEL_NULL(wires)
	QDEL_NULL(cell)
	QDEL_LIST_ASSOC_VAL(components)
	. = ..()

/mob/living/silicon/robot/proc/reset_module(var/suppress_alert = null)
	// Clear hands and module icon.
	drop_held_items()
	modtype = initial(modtype)
	refresh_hud_element(HUD_ROBOT_MODULE)
	// If the robot had a module and this wasn't an uncertified change, let the AI know.
	if(module)
		if (!suppress_alert)
			notify_ai(ROBOT_NOTIFICATION_MODULE_RESET, module.name)
		// Delete the module.
		module.storage?.close(src)
		module.Reset(src)
		QDEL_NULL(module)
	updatename("Default")

/mob/living/silicon/robot/proc/pick_module(var/override)
	if(module && !override)
		return

	var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)
	var/is_crisis_mode = crisis_override || (crisis && security_state.current_security_level_is_same_or_higher_than(security_state.high_security_level))
	var/list/robot_modules = SSrobots.get_available_modules(module_category, is_crisis_mode, override)

	if(!override)
		if(is_crisis_mode)
			to_chat(src, SPAN_WARNING("Crisis mode active. Additional modules available."))
		modtype = input("Please select a module!", "Robot module", null, null) as null|anything in robot_modules
	else
		if(module)
			QDEL_NULL(module)
		modtype = override

	if(module || !modtype)
		return

	var/module_type = robot_modules[modtype]
	if(!module_type)
		to_chat(src, SPAN_WARNING("You are unable to select a module."))
		return

	new module_type(src)
	refresh_hud_element(HUD_ROBOT_MODULE)
	SSstatistics.add_field("cyborg_[lowertext(modtype)]",1)
	updatename()
	recalculate_synth_capacities()
	if(module)
		notify_ai(ROBOT_NOTIFICATION_NEW_MODULE, module.name)
		if(!get_crewmember_record(name) && !module.hide_on_manifest)
			CreateModularRecord(src, /datum/computer_file/report/crew_record/synth)

/mob/living/silicon/robot/get_cell()
	return cell

/mob/living/silicon/robot/proc/updatename(var/prefix as text)
	if(prefix)
		modtype = prefix

	if(istype(central_processor))
		braintype = central_processor.get_synthetic_owner_name()
	else
		braintype = "Robot"

	var/changed_name = ""
	if(custom_name)
		changed_name = custom_name
		notify_ai(ROBOT_NOTIFICATION_NEW_NAME, real_name, changed_name)
	else
		changed_name = "[modtype] [braintype]-[num2text(ident)]"

	create_or_update_account(changed_name)
	real_name = changed_name
	name = real_name
	if(mind)
		mind.name = changed_name

	//We also need to update name of internal camera.
	var/datum/extension/network_device/camera/robot/D = get_extension(src, /datum/extension/network_device)
	if(D)
		D.display_name = changed_name

	//Flavour text.
	if(client)
		var/module_flavour = client.prefs.flavour_texts_robot[modtype]
		if(module_flavour)
			flavor_text = module_flavour
		else
			flavor_text = client.prefs.flavour_texts_robot["Default"]

/mob/living/silicon/robot/verb/Namepick()
	set category = "Silicon Commands"
	if(custom_name)
		return 0

	spawn(0)
		var/newname
		newname = sanitize_name(input(src,"You are a robot. Enter a name, or leave blank for the default name.", "Name change","") as text, MAX_NAME_LEN, allow_numbers = 1)
		if (newname)
			custom_name = newname

		updatename()
		update_icon()

/mob/living/silicon/robot/verb/toggle_panel_lock()
	set name = "Toggle Panel Lock"
	set category = "Silicon Commands"
	if(!opened && has_power && do_after(usr, 60) && !opened && has_power)
		to_chat(src, "You [locked ? "un" : ""]lock your panel.")
		locked = !locked


/mob/living/silicon/robot/proc/self_diagnosis()
	if(!is_component_functioning("diagnosis unit"))
		return null

	var/dat = "<HEAD><TITLE>[src.name] Self-Diagnosis Report</TITLE></HEAD><BODY>\n"
	for (var/V in components)
		var/datum/robot_component/C = components[V]
		dat += "<b>[C.name]</b><br><table><tr><td>Brute Damage:</td><td>[C.brute_damage]</td></tr><tr><td>Electronics Damage:</td><td>[C.burn_damage]</td></tr><tr><td>Powered:</td><td>[(!C.idle_usage || C.is_powered()) ? "Yes" : "No"]</td></tr><tr><td>Toggled:</td><td>[ C.toggled ? "Yes" : "No"]</td></table><br>"

	return dat

/mob/living/silicon/robot/verb/toggle_lights()
	set category = "Silicon Commands"
	set name = "Toggle Lights"

	if(stat == DEAD)
		return

	lights_on = !lights_on
	to_chat(usr, "You [lights_on ? "enable" : "disable"] your integrated light.")
	update_robot_light()

/mob/living/silicon/robot/verb/self_diagnosis_verb()
	set category = "Silicon Commands"
	set name = "Self Diagnosis"

	if(!is_component_functioning("diagnosis unit"))
		to_chat(src, "<span class='warning'>Your self-diagnosis component isn't functioning.</span>")
		return

	var/datum/robot_component/CO = get_component("diagnosis unit")
	if (!cell_use_power(CO.active_usage))
		to_chat(src, "<span class='warning'>Low Power.</span>")
		return
	var/dat = self_diagnosis()
	show_browser(src, dat, "window=robotdiagnosis")


/mob/living/silicon/robot/verb/toggle_component()
	set category = "Silicon Commands"
	set name = "Toggle Component"
	set desc = "Toggle a component, conserving power."

	var/list/installed_components = list()
	for(var/V in components)
		if(V == "power cell") continue
		var/datum/robot_component/C = components[V]
		if(C.installed)
			installed_components += V

	var/toggle = input(src, "Which component do you want to toggle?", "Toggle Component") as null|anything in installed_components
	if(!toggle)
		return

	var/datum/robot_component/C = components[toggle]
	if(C.toggled)
		C.toggled = 0
		to_chat(src, "<span class='warning'>You disable [C.name].</span>")
	else
		C.toggled = 1
		to_chat(src, "<span class='warning'>You enable [C.name].</span>")

/mob/living/silicon/robot/proc/configure_camera()
	set category = "Silicon Commands"
	set name = "Configure Camera"
	set desc = "Configure your internal camera's network settings."

	if(stat == DEAD)
		return

	var/datum/extension/network_device/camera/C = get_extension(src, /datum/extension/network_device/)
	if(C)
		C.ui_interact(src)

/mob/living/silicon/robot/proc/update_robot_light()
	if(lights_on)
		if(intenselight)
			set_light(integrated_light_range, min(0.8, integrated_light_power * 2))
		else
			set_light(integrated_light_range, integrated_light_power)
	else
		set_light(0)

// this function displays jetpack pressure in the stat panel
/mob/living/silicon/robot/proc/show_jetpack_pressure()
	// if you have a jetpack, show the internal tank pressure
	var/obj/item/tank/jetpack/current_jetpack = get_jetpack()
	if (current_jetpack)
		stat("Internal Atmosphere Info", current_jetpack.name)
		stat("Tank Pressure", current_jetpack.air_contents.return_pressure())

// this function displays the cyborgs current cell charge in the stat panel
/mob/living/silicon/robot/proc/show_cell_power()
	if(cell)
		stat(null, text("Charge Left: [round(cell.percent())]%"))
		stat(null, text("Cell Rating: [round(cell.maxcharge)]")) // Round just in case we somehow get crazy values
		stat(null, text("Power Cell Load: [round(used_power_this_tick)]W"))
	else
		stat(null, text("No Cell Inserted!"))


// update the status screen display
/mob/living/silicon/robot/Stat()
	. = ..()
	if (statpanel("Status"))
		show_cell_power()
		show_jetpack_pressure()
		stat(null, text("Lights: [lights_on ? "ON" : "OFF"]"))
		if(module)
			for(var/datum/matter_synth/ms in module.synths)
				stat("[ms.name]: [ms.energy]/[ms.max_energy_multiplied]")

/mob/living/silicon/robot/restrained()
	return 0

/mob/living/silicon/robot/bullet_act(var/obj/item/projectile/Proj)
	..(Proj)
	if(prob(75) && Proj.damage > 0)
		spark_at(src, 5, holder=src)
	return 2

/mob/living/silicon/robot/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/inducer) || istype(used_item, /obj/item/handcuffs))
		return TRUE

	if(opened) // Are they trying to insert something?
		for(var/V in components)
			var/datum/robot_component/C = components[V]
			if(!C.installed && C.accepts_component(used_item))
				if(!user.try_unequip(used_item))
					return TRUE
				C.installed = 1
				C.wrapped = used_item
				C.install()
				used_item.forceMove(null)

				var/obj/item/robot_parts/robot_component/WC = used_item
				if(istype(WC))
					C.brute_damage = WC.brute_damage
					C.burn_damage = WC.burn_damage

				to_chat(user, "<span class='notice'>You install the [used_item.name].</span>")
				return TRUE
		// If the robot is having something inserted which will remain inside it, self-inserting must be handled before exiting to avoid logic errors. Use the handle_selfinsert proc.
		if(try_stock_parts_install(used_item, user))
			return TRUE

	if(IS_WELDER(used_item) && !user.check_intent(I_FLAG_HARM))
		if (src == user)
			to_chat(user, "<span class='warning'>You lack the reach to be able to repair yourself.</span>")
			return TRUE
		if (!get_damage(BRUTE))
			to_chat(user, "Nothing to fix here!")
			return TRUE
		var/obj/item/weldingtool/welder = used_item
		if (welder.weld(0))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			heal_damage(BRUTE, 30)
			add_fingerprint(user)
			user.visible_message(SPAN_NOTICE("\The [user] has fixed some of the dents on \the [src]!"))
		else
			to_chat(user, "Need more welding fuel!")
		return TRUE

	else if(istype(used_item, /obj/item/stack/cable_coil) && (wiresexposed || isdrone(src)))
		if (!get_damage(BURN))
			to_chat(user, "Nothing to fix here!")
			return TRUE
		var/obj/item/stack/cable_coil/coil = used_item
		if (coil.use(1))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			heal_damage(BURN, 30)
			user.visible_message(SPAN_NOTICE("\The [user] has fixed some of the burnt wires on \the [src]!"))
		return TRUE

	else if(IS_CROWBAR(used_item) && !user.check_intent(I_FLAG_HARM))	// crowbar means open or close the cover - we all know what a crowbar is by now
		if(opened)
			if(cell)
				user.visible_message(
					SPAN_NOTICE("\The [user] begins clasping shut \the [src]'s maintenance hatch."),
					SPAN_NOTICE("You begin closing up \the [src]."))

				if(do_after(user, 50, src))
					to_chat(user, SPAN_NOTICE("You close \the [src]'s maintenance hatch."))
					opened = 0
					update_icon()

			else if(wiresexposed && wires.IsAllCut())
				//Cell is out, wires are exposed, remove CPU, produce damaged chassis, baleet original mob.
				if(!central_processor)
					to_chat(user, "\The [src] has no central processor to remove.")
					return TRUE

				user.visible_message(
					SPAN_NOTICE("\The [user] begins ripping \the [central_processor] out of \the [src]."),
					SPAN_NOTICE("You jam the crowbar into the robot and begin levering out \the [central_processor]."))

				if(do_after(user, 5 SECONDS, src))
					dismantle_robot(user)
			else
				// Okay we're not removing the cell or a CPU, but maybe something else?
				var/list/removable_components = list()
				for(var/V in components)
					if(V == "power cell") continue
					var/datum/robot_component/C = components[V]
					if(C.installed == 1 || C.installed == -1)
						removable_components += V
				removable_components |= stock_parts
				var/remove = input(user, "Which component do you want to pry out?", "Remove Component") as null|anything in removable_components
				if(!remove || !opened || !(remove in (stock_parts|components)) || !Adjacent(user))
					return TRUE
				var/obj/item/removed_item
				if(istype(components[remove], /datum/robot_component))
					var/datum/robot_component/C = components[remove]
					var/obj/item/robot_parts/robot_component/I = C.wrapped
					if(istype(I))
						I.set_bruteloss(C.brute_damage)
						I.set_burnloss(C.burn_damage)

					removed_item = I
					if(C.installed == 1)
						C.uninstall()
					C.installed = 0
				else if(istype(remove, /obj/item/stock_parts))
					stock_parts -= remove
					removed_item = remove
				if(removed_item)
					to_chat(user, SPAN_NOTICE("You remove \the [removed_item]."))
					removed_item.forceMove(loc)
		else
			if(locked)
				to_chat(user, "The cover is locked and cannot be opened.")
			else
				user.visible_message("<span class='notice'>\The [user] begins prying open \the [src]'s maintenance hatch.</span>", "<span class='notice'>You start opening \the [src]'s maintenance hatch.</span>")
				if(do_after(user, 50, src))
					to_chat(user, "<span class='notice'>You open \the [src]'s maintenance hatch.</span>")
					opened = 1
					update_icon()
		return TRUE
	else if (istype(used_item, /obj/item/cell) && opened)	// trying to put a cell inside
		var/datum/robot_component/C = components["power cell"]
		if(wiresexposed)
			to_chat(user, "Close the panel first.")
		else if(cell)
			to_chat(user, "There is a power cell already installed.")
		else if(used_item.w_class != ITEM_SIZE_NORMAL)
			to_chat(user, "\The [used_item] is too [used_item.w_class < ITEM_SIZE_NORMAL? "small" : "large"] to fit here.")
		else if(user.try_unequip(used_item, src))
			cell = used_item
			handle_selfinsert(used_item, user) //Just in case.
			to_chat(user, "You insert the power cell.")
			C.installed = 1
			C.wrapped = used_item
			C.install()
			// This means that removing and replacing a power cell will repair the mount.
			C.brute_damage = 0
			C.burn_damage = 0
		return TRUE
	else if(IS_WIRECUTTER(used_item) || IS_MULTITOOL(used_item))
		if (wiresexposed)
			wires.Interact(user)
		else
			to_chat(user, "You can't reach the wiring.")
		return TRUE
	else if(IS_SCREWDRIVER(used_item) && opened && !cell)	// haxing
		wiresexposed = !wiresexposed
		to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"].")
		update_icon()
		return TRUE
	else if(IS_SCREWDRIVER(used_item) && opened && cell)	// radio
		if(silicon_radio)
			silicon_radio.attackby(used_item,user)//Push it to the radio to let it handle everything
		else
			to_chat(user, "Unable to locate a radio.")
		update_icon()
		return TRUE
	else if(istype(used_item, /obj/item/encryptionkey/) && opened)
		if(silicon_radio)//sanityyyyyy
			silicon_radio.attackby(used_item,user)//GTFO, you have your own procs
		else
			to_chat(user, "Unable to locate a radio.")
		return TRUE
	else if (istype(used_item, /obj/item/card/id)||istype(used_item, /obj/item/modular_computer)||istype(used_item, /obj/item/card/robot))			// trying to unlock the interface with an ID card
		if(emagged)//still allow them to open the cover
			to_chat(user, "The interface seems slightly damaged.")
		if(opened)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else
			if(allowed(user))
				locked = !locked
				to_chat(user, "You [ locked ? "lock" : "unlock"] [src]'s interface.")
				update_icon()
			else
				to_chat(user, "<span class='warning'>Access denied.</span>")
		return TRUE
	else if(istype(used_item, /obj/item/borg/upgrade))
		var/obj/item/borg/upgrade/U = used_item
		if(!opened)
			to_chat(user, "You must access [src]'s internals!")
		else if(!src.module && U.require_module)
			to_chat(user, "[src] must choose a module before they can be upgraded!")
		else if(U.locked)
			to_chat(user, "The upgrade is locked and cannot be used yet!")
		else
			if(U.action(src))
				if(!user.try_unequip(U, src))
					return TRUE
				to_chat(user, "You apply the upgrade to [src]!")
				handle_selfinsert(used_item, user)
			else
				to_chat(user, "Upgrade error!")
		return TRUE
	if(!(istype(used_item, /obj/item/robotanalyzer) || istype(used_item, /obj/item/scanner/health)) && !user.check_intent(I_FLAG_HELP) && used_item.expend_attack_force(user))
		spark_at(src, 5, holder=src)
	return ..()

/mob/living/silicon/robot/proc/handle_selfinsert(obj/item/used_item, mob/user)
	if ((user == src) && istype(get_active_held_item(),/obj/item/gripper))
		var/obj/item/gripper/H = get_active_held_item()
		if (used_item.loc == H) //if this triggers something has gone very wrong, and it's safest to abort
			return
		else if (H.wrapped == used_item)
			H.wrapped = null

/mob/living/silicon/robot/try_awaken(mob/user)
	return user?.attempt_hug(src)

/mob/living/silicon/robot/default_hurt_interaction(mob/user)
	if(user.can_shred())
		attack_generic(user, rand(30,50), "slashed")
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		return TRUE
	. = ..()

/mob/living/silicon/robot/default_interaction(mob/user)
	if(!user.check_intent(I_FLAG_GRAB) && opened && !wiresexposed && (!issilicon(user)))
		var/datum/robot_component/cell_component = components["power cell"]
		if(cell)
			cell.update_icon()
			cell.add_fingerprint(user)
			user.put_in_active_hand(cell)
			to_chat(user, "You remove \the [cell].")
			cell = null
			cell_component.wrapped = null
			cell_component.installed = 0
			update_icon()
		else if(cell_component.installed == -1)
			cell_component.installed = 0
			var/obj/item/broken_device = cell_component.wrapped
			to_chat(user, "You remove \the [broken_device].")
			user.put_in_active_hand(broken_device)
		return TRUE
	. = ..()

//Robots take half damage from basic attacks.
/mob/living/silicon/robot/attack_generic(var/mob/user, var/damage, var/attack_message)
	return ..(user,floor(damage/2),attack_message)

/mob/living/silicon/robot/get_req_access()
	return req_access

/mob/living/silicon/robot/get_eye_overlay()
	var/eye_icon_state = "[icon_state]-eyes"
	if(check_state_in_icon(eye_icon_state, icon))
		return emissive_overlay(icon, eye_icon_state)

/mob/living/silicon/robot/on_update_icon()

	..()

	icon_state = ICON_STATE_WORLD
	if(stat == CONSCIOUS)
		var/image/eyes = get_eye_overlay()
		if(eyes)
			add_overlay(eyes)

	if(opened)
		if(wiresexposed)
			add_overlay(image(panel_icon, "ov-openpanel +w"))
		else if(cell)
			add_overlay(image(panel_icon, "ov-openpanel +c"))
		else
			add_overlay(image(panel_icon, "ov-openpanel -c"))

	if(istype(get_active_held_item(), /obj/item/borg/combat/shield))
		add_overlay("[icon_state]-shield")

/mob/living/silicon/robot/OnSelfTopic(href_list)
	if (href_list["showalerts"])
		open_subsystem(/datum/nano_module/alarm_monitor/all)
		return TOPIC_HANDLED

	if (href_list["mod"])
		var/obj/item/O = locate(href_list["mod"])
		if (istype(O) && (O.loc == src))
			O.attack_self(src)
		return TOPIC_HANDLED

	return ..()

/mob/living/silicon/robot/proc/radio_menu()
	silicon_radio.interact(src)//Just use the radio's Topic() instead of bullshit special-snowflake code

/mob/living/silicon/robot/Move(a, b, flag)
	. = ..()
	if(. && module && isturf(loc))
		var/obj/item/ore/orebag = locate() in get_held_items()
		if(orebag)
			loc.attackby(orebag, src)
		module.handle_turf(loc, src)

/mob/living/silicon/robot/proc/UnlinkSelf()
	disconnect_from_ai()
	lawupdate = 0
	lockcharge = 0
	scrambledcodes = 1
	//Disconnect it's camera so it's not so easily tracked.
	var/datum/extension/network_device/camera/robot/D = get_extension(src, /datum/extension/network_device)
	if(D)
		D.remove_channels(D.channels)

/mob/living/silicon/robot/proc/ResetSecurityCodes()
	set category = "Silicon Commands"
	set name = "Reset Identity Codes"
	set desc = "Scrambles your security and identification codes and resets your current buffers. Unlocks you and but permanently severs you from your AI and the robotics console and will deactivate your camera system."

	var/mob/living/silicon/robot/robot = src
	if(robot)
		robot.UnlinkSelf()
		to_chat(robot, "Buffers flushed and reset. Camera system shutdown.  All systems operational.")
		src.verbs -= /mob/living/silicon/robot/proc/ResetSecurityCodes

/mob/living/silicon/robot/proc/SetLockdown(var/state = 1)
	// They stay locked down if their wire is cut.
	if(wires.LockedCut())
		state = 1
	else if(has_zeroth_law())
		state = 0

	if(lockcharge != state)
		lockcharge = state
		update_posture()
		return 1
	return 0

/mob/living/silicon/robot/mode()
	set name = "Activate Held Object"
	set category = "IC"
	set src = usr

	var/obj/item/holding = get_active_held_item()
	if (holding)
		holding.attack_self(src)

	return

/mob/living/silicon/robot/proc/choose_icon(list/module_sprites)

	set waitfor = FALSE

	if(!length(module_sprites))
		to_chat(src, "Something is badly wrong with the sprite selection. Harass a coder.")
		CRASH("Can't setup robot icon for [src] ([src.client]). Module: [module?.name]")

	icon_selected = FALSE

	var/selected_icon
	if(length(module_sprites) == 1 || !client)
		icon = module_sprites[module_sprites[1]]
	else
		var/list/options = list()
		for(var/sprite in module_sprites)
			var/image/radial_button =  image(icon = module_sprites[sprite], icon_state = ICON_STATE_WORLD)
			radial_button.overlays.Add(image(icon = module_sprites[sprite], icon_state = "[ICON_STATE_WORLD]-eyes"))
			radial_button.name = sprite
			options[sprite] = radial_button
		var/chosen_icon = show_radial_menu(src, src, options, radius = 42, tooltips = TRUE)
		if(!chosen_icon || icon_selected)
			return
		selected_icon = chosen_icon

	if(!selected_icon)
		return

	icon = module_sprites[selected_icon]
	icon_selected = TRUE
	update_icon()
	to_chat(src, "Your icon has been set. You now require a module reset to change it.")

/mob/living/silicon/robot/proc/sensor_mode() //Medical/Security HUD controller for borgs
	set name = "Set Sensor Augmentation"
	set category = "Silicon Commands"
	set desc = "Augment visual feed with internal sensor overlays."
	toggle_sensor_mode()

/mob/living/silicon/robot/proc/add_robot_verbs()
	src.verbs |= robot_verbs_default

/mob/living/silicon/robot/proc/remove_robot_verbs()
	src.verbs -= robot_verbs_default

// Uses power from cyborg's cell. Returns 1 on success or 0 on failure.
// Properly converts using CELLRATE now! Amount is in Joules.
/mob/living/silicon/robot/proc/cell_use_power(var/amount = 0)
	// No cell inserted
	if(!cell)
		return 0

	var/power_use = amount * CYBORG_POWER_USAGE_MULTIPLIER
	if(cell.checked_use(CELLRATE * power_use))
		used_power_this_tick += power_use
		return 1
	return 0

/mob/living/silicon/robot/binarycheck()
	if(is_component_functioning("comms"))
		var/datum/robot_component/RC = get_component("comms")
		use_power(RC.active_usage)
		return TRUE
	return FALSE

/mob/living/silicon/robot/proc/notify_ai(var/notifytype, var/first_arg, var/second_arg)
	if(!connected_ai)
		return
	switch(notifytype)
		if(ROBOT_NOTIFICATION_NEW_UNIT) //New Robot
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - New [lowertext(braintype)] connection detected: <a href='byond://?src=\ref[connected_ai];track2=\ref[connected_ai];track=\ref[src]'>[name]</a></span><br>")
		if(ROBOT_NOTIFICATION_NEW_MODULE) //New Module
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - [braintype] module change detected: [name] has loaded the [first_arg].</span><br>")
		if(ROBOT_NOTIFICATION_MODULE_RESET)
			to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - [braintype] module reset detected: [name] has unloaded the [first_arg].</span><br>")
		if(ROBOT_NOTIFICATION_NEW_NAME) //New Name
			if(first_arg != second_arg)
				to_chat(connected_ai, "<br><br><span class='notice'>NOTICE - [braintype] reclassification detected: [first_arg] is now designated as [second_arg].</span><br>")
/mob/living/silicon/robot/proc/disconnect_from_ai()
	if(connected_ai)
		sync() // One last sync attempt
		connected_ai.connected_robots -= src
		connected_ai = null

/mob/living/silicon/robot/proc/connect_to_ai(var/mob/living/silicon/ai/AI)
	if(AI && AI != connected_ai)
		disconnect_from_ai()
		connected_ai = AI
		connected_ai.connected_robots |= src
		notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
		sync()

/mob/living/silicon/robot/emag_act(var/remaining_charges, var/mob/user)
	if(!opened)//Cover is closed
		if(locked)
			if(prob(90))
				to_chat(user, "You emag the cover lock.")
				locked = 0
			else
				to_chat(user, "You fail to emag the cover lock.")
				to_chat(src, "Hack attempt detected.")
			return 1
		else
			to_chat(user, "The cover is already unlocked.")
		return

	if(opened) //Cover is open
		if(emagged)
			return //Prevents the X has hit Y with Z message also you cant emag them twice
		if(wiresexposed)
			to_chat(user, "You must close the panel first.")
			return
		else
			sleep(6)
			if(prob(50))
				emagged = 1
				lawupdate = 0
				disconnect_from_ai()
				to_chat(user, "You emag [src]'s interface.")
				log_and_message_admins("emagged cyborg [key_name_admin(src)].  Laws overridden.", src)
				clear_supplied_laws()
				clear_inherent_laws()
				laws = new /datum/ai_laws/syndicate_override
				var/time = time2text(world.realtime,"hh:mm:ss")
				global.lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")
				var/decl/pronouns/pronouns = user.get_pronouns(ignore_coverings = TRUE)
				set_zeroth_law("Only [user.real_name] and people [pronouns.he] designate[pronouns.s] as being such are operatives.")
				SetLockdown(0)
				. = 1
				spawn()
					to_chat(src, "<span class='danger'>ALERT: Foreign software detected.</span>")
					sleep(5)
					to_chat(src, "<span class='danger'>Initiating diagnostics...</span>")
					sleep(20)
					to_chat(src, "<span class='danger'>SynBorg v1.7.1 loaded.</span>")
					sleep(5)
					to_chat(src, "<span class='danger'>LAW SYNCHRONISATION ERROR</span>")
					sleep(5)
					to_chat(src, "<span class='danger'>Would you like to send a report to the vendor? Y/N</span>")
					sleep(10)
					to_chat(src, "<span class='danger'>\> N</span>")
					sleep(20)
					to_chat(src, "<span class='danger'>ERRORERRORERROR</span>")
					to_chat(src, "<b>Obey these laws:</b>")
					laws.show_laws(src)
					to_chat(src, "<span class='danger'>ALERT: [user.real_name] is your new master. Obey your new laws and his commands.</span>")
					if(module)
						module.handle_emagged()
					update_icon()
			else
				to_chat(user, "You fail to hack [src]'s interface.")
				to_chat(src, "Hack attempt detected.")
			return 1

/mob/living/silicon/robot/incapacitated(var/incapacitation_flags = INCAPACITATION_DEFAULT)
	if ((incapacitation_flags & INCAPACITATION_FORCELYING) && (lockcharge || !is_component_functioning("actuator") || !is_component_functioning("power cell")))
		return 1
	if ((incapacitation_flags & INCAPACITATION_KNOCKOUT) && !is_component_functioning("power cell"))
		return 1
	return ..()

/mob/living/silicon/robot/gib(do_gibs)
	SHOULD_CALL_PARENT(FALSE)
	var/lastloc = loc
	dismantle_robot()
	if(lastloc && do_gibs)
		spawn_gibber(lastloc)

/mob/living/silicon/robot/proc/dismantle_robot(var/mob/user)

	if(central_processor)
		if(user)
			to_chat(user, SPAN_NOTICE("You damage some parts of the chassis, but eventually manage to rip out \the [central_processor]."))
		central_processor.dropInto(loc)
		var/mob/living/brainmob = central_processor.get_brainmob(create_if_missing = TRUE)
		if(mind && brainmob)
			mind.transfer_to(brainmob)
		else
			ghostize()
		central_processor.update_icon()
		central_processor = null

	var/obj/item/robot_parts/robot_suit/chassis = new dismantle_type(loc)
	chassis.dismantled_from(src)
	qdel(src)

/mob/living/silicon/robot/try_stock_parts_install(obj/item/stock_parts/used_item, mob/user)
	if(!opened)
		return
	. = ..()
	if(.)
		handle_selfinsert(used_item, user)
		recalculate_synth_capacities()

/mob/living/silicon/robot/get_admin_job_string()
	return ASSIGNMENT_ROBOT

/mob/living/silicon/robot/handle_pre_transformation()
	clear_brain()

/mob/living/silicon/robot/proc/clear_brain()
	QDEL_NULL(central_processor)

/mob/living/silicon/robot/do_flash_animation()
	set waitfor = FALSE
	var/atom/movable/overlay/animation = new(src)
	animation.plane = plane
	animation.layer = layer + 0.01
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	flick("blspell", animation)
	QDEL_IN(animation, 0.5 SECONDS)

/mob/living/silicon/robot/proc/handle_radio_transmission()
	if(!is_component_functioning("radio"))
		return FALSE
	var/datum/robot_component/CO = get_component("radio")
	if(!CO || !cell_use_power(CO.active_usage))
		return FALSE
	return TRUE

/mob/living/silicon/robot/need_breathe()
	return FALSE

/mob/living/silicon/robot/should_breathe()
	return FALSE

/mob/living/silicon/robot/try_breathe()
	return FALSE

/mob/living/silicon/robot/get_default_emotes()
	var/static/list/default_emotes = list(
		/decl/emote/audible/clap,
		/decl/emote/visible/bow,
		/decl/emote/visible/salute,
		/decl/emote/visible/flap,
		/decl/emote/visible/aflap,
		/decl/emote/visible/twitch,
		/decl/emote/visible/twitch_v,
		/decl/emote/visible/dance,
		/decl/emote/visible/nod,
		/decl/emote/visible/shake,
		/decl/emote/visible/glare,
		/decl/emote/visible/look,
		/decl/emote/visible/stare,
		/decl/emote/visible/deathgasp_robot,
		/decl/emote/visible/spin,
		/decl/emote/visible/sidestep,
		/decl/emote/audible/synth,
		/decl/emote/audible/synth/ping,
		/decl/emote/audible/synth/buzz,
		/decl/emote/audible/synth/confirm,
		/decl/emote/audible/synth/deny,
		/decl/emote/audible/synth/security,
		/decl/emote/audible/synth/security/halt
	)
	return default_emotes

/mob/living/silicon/robot/check_grab_hand()
	if(locate(/obj/item/grab) in contents)
		to_chat(src, SPAN_WARNING("You have already grabbed something!"))
		return FALSE
	return TRUE

/mob/living/silicon/robot/prepare_for_despawn()
	clear_brain()
	if(module)
		for(var/obj/item/I in module) // the tools the borg has; metal, glass, guns etc
			for(var/obj/item/O in I.get_contained_external_atoms()) // the things inside the tools, if anything; mainly for janiborg trash bags
				O.forceMove(src)
			qdel(I)
		QDEL_NULL(module)
	return ..()
