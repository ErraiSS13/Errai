var/global/list/rad_collectors = list()

// TODO: swap the hydrogen tanks out for lithium sheets or something like that.

/obj/machinery/rad_collector
	name = "radiation collector array"
	desc = "A device which uses radiation and hydrogen to produce power."
	icon = 'icons/obj/machines/rad_collector.dmi'
	icon_state = "ca"
	anchored = FALSE
	density = TRUE
	initial_access = list(access_engine_equip)
	max_health = 100
	var/obj/item/tank/hydrogen/loaded_tank = null

	var/max_safe_temp = 1000 + T0C
	var/melted

	var/last_power = 0
	var/last_power_new = 0
	var/active = 0
	var/locked = 0
	var/drainratio = 1

	var/last_rads
	var/max_rads = 250 // rad collector will reach max power output at this value, and break at twice this value
	var/max_power = 5e5
	var/pulse_coeff = 20
	var/end_time = 0
	var/alert_delay = 10 SECONDS

/obj/machinery/rad_collector/Initialize()
	. = ..()
	global.rad_collectors += src

/obj/machinery/rad_collector/Destroy()
	global.rad_collectors -= src
	. = ..()

/obj/machinery/rad_collector/Process()
	if((stat & BROKEN) || melted)
		return
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/our_turfs_air = T.return_air()
		if(our_turfs_air.temperature > max_safe_temp)
			current_health -= ((our_turfs_air.temperature - max_safe_temp) / 10)
			if(current_health <= 0)
				collector_break()

	//so that we don't zero out the meter if the SM is processed first.
	last_power = last_power_new
	last_power_new = 0
	last_rads = SSradiation.get_rads_at_turf(get_turf(src))
	if(loaded_tank && active)
		if(last_rads > max_rads*2)
			collector_break()
		if(last_rads)
			if(last_rads > max_rads)
				if(world.time > end_time)
					end_time = world.time + alert_delay
					visible_message("[html_icon(src)] \the [src] beeps loudly as the radiation reaches dangerous levels, indicating imminent damage.")
					playsound(src, 'sound/effects/screech.ogg', 100, 1, 1)
			receive_pulse(12.5*(last_rads/max_rads)/(0.3+(last_rads/max_rads)))

	if(loaded_tank)
		if(loaded_tank.air_contents.gas[/decl/material/gas/hydrogen] == 0)
			investigate_log("<font color='red'>out of fuel</font>.","singulo")
			eject()
		else
			loaded_tank.air_adjust_gas(/decl/material/gas/hydrogen, -0.01*drainratio*min(last_rads,max_rads)/max_rads) //fuel cost increases linearly with incoming radiation

/obj/machinery/rad_collector/CanUseTopic(mob/user)
	if(!anchored)
		return STATUS_CLOSE
	return ..()

/obj/machinery/rad_collector/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	. = TRUE
	if((stat & BROKEN) || melted)
		to_chat(user, "<span class='warning'>\The [src] is completely destroyed!</span>")
	if(!src.locked)
		toggle_power()
		user.visible_message("[user.name] turns \the [src] [active? "on":"off"].", \
		"You turn \the [src] [active? "on":"off"].")
		investigate_log("turned [active?"<font color='green'>on</font>":"<font color='red'>off</font>"] by [user.key]. [loaded_tank?"Fuel: [round(loaded_tank.air_contents.gas[/decl/material/gas/hydrogen]/0.29)]%":"<font color='red'>It is empty</font>"].","singulo")
	else
		to_chat(user, "<span class='warning'>The controls are locked!</span>")

/obj/machinery/rad_collector/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/tank/hydrogen))
		if(!src.anchored)
			to_chat(user, "<span class='warning'>\The [src] needs to be secured to the floor first.</span>")
			return TRUE
		if(src.loaded_tank)
			to_chat(user, "<span class='warning'>There's already a tank loaded.</span>")
			return TRUE
		if(!user.try_unequip(used_item, src))
			return TRUE
		src.loaded_tank = used_item
		update_icon()
		return TRUE
	else if(IS_CROWBAR(used_item))
		if(loaded_tank && !src.locked)
			eject()
			return TRUE
	else if(IS_WRENCH(used_item))
		if(loaded_tank)
			to_chat(user, "<span class='notice'>Remove the tank first.</span>")
			return TRUE
		for(var/obj/machinery/rad_collector/R in get_turf(src))
			if(R != src)
				to_chat(user, "<span class='warning'>You cannot install more than one collector on the same spot.</span>")
				return TRUE
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		src.anchored = !src.anchored
		user.visible_message("[user.name] [anchored? "secures":"unsecures"] \the [src].", \
			"You [anchored? "secure":"undo"] the external bolts.", \
			"You hear a ratchet.")
		return TRUE
	else if(istype(used_item, /obj/item/card/id)||istype(used_item, /obj/item/modular_computer))
		if (src.allowed(user))
			if(active)
				src.locked = !src.locked
				to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
			else
				src.locked = 0 //just in case it somehow gets locked
				to_chat(user, SPAN_WARNING("The controls can only be locked when \the [src] is active."))
		else
			to_chat(user, "<span class='warning'>Access denied!</span>")
		return TRUE
	return ..()

/obj/machinery/rad_collector/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if (distance <= 3 && !(stat & BROKEN))
		. += "The meter indicates that \the [src] is collecting [last_power] W."

/obj/machinery/rad_collector/explosion_act(severity)
	if(severity != 1)
		eject()
	. = ..()

/obj/machinery/rad_collector/proc/collector_break()
	if(loaded_tank?.air_contents)
		var/turf/T = get_turf(src)
		if(T)
			T.assume_air(loaded_tank.air_contents)
			audible_message(SPAN_DANGER("\The [loaded_tank] detonates, sending shrapnel flying!"))
			fragmentate(T, 2, 4, list(/obj/item/projectile/bullet/pellet/fragment/tank/small = 3, /obj/item/projectile/bullet/pellet/fragment/tank = 1))
			explosion(T, -1, -1, 0)
			QDEL_NULL(loaded_tank)
	stat |= BROKEN
	melted = TRUE
	anchored = FALSE
	active = FALSE
	desc += " This one is destroyed beyond repair."
	update_icon()

/obj/machinery/rad_collector/return_air()
	. =loaded_tank?.return_air()

/obj/machinery/rad_collector/proc/eject()
	locked = 0
	var/obj/item/tank/hydrogen/Z = src.loaded_tank
	if (!Z)
		return
	Z.dropInto(loc)
	Z.reset_plane_and_layer()
	src.loaded_tank = null
	if(active)
		toggle_power()
	else
		update_icon()

/obj/machinery/rad_collector/proc/receive_pulse(var/pulse_strength)
	if(loaded_tank && active)
		var/power_produced = 0
		power_produced = min(100*loaded_tank.air_contents.gas[/decl/material/gas/hydrogen]*pulse_strength*pulse_coeff,max_power)
		generate_power(power_produced)
		last_power_new = power_produced
		return
	return


/obj/machinery/rad_collector/on_update_icon()
	if(melted)
		icon_state = "ca_melt"
	else if(active)
		icon_state = "ca_on"
	else
		icon_state = "ca"

	overlays.Cut()
	underlays.Cut()

	if(loaded_tank)
		overlays += image(icon, "ptank")
		underlays += image(icon, "ca_filling")
	underlays += image(icon, "ca_inside")
	if(stat & (NOPOWER|BROKEN))
		return
	if(active)
		var/rad_power = round(min(100 * last_rads / max_rads, 100), 20)
		overlays += image(icon, "rads_[rad_power]")
		overlays += image(icon, "on")

/obj/machinery/rad_collector/toggle_power()
	active = !active
	if(active)
		flick("ca_active", src)
	else
		flick("ca_deactive", src)
	update_icon()
