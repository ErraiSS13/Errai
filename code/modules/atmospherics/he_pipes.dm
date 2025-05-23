
/obj/machinery/atmospherics/pipe/simple/heat_exchanging
	icon             = 'icons/atmos/heat.dmi'
	icon_state       = "11"
	color            = "#404040"
	pipe_color       = "#404040"
	level            = LEVEL_ABOVE_PLATING
	connect_types    = CONNECT_TYPE_HE
	interact_offline = TRUE //Needs to be set so that pipes don't say they lack power in their description
	build_icon_state = "he"
	atom_flags       = 0 // no painting
	maximum_pressure = 360 ATM
	fatigue_pressure = 300 ATM
	can_buckle       = TRUE
	buckle_lying     = TRUE
	appearance_flags = KEEP_TOGETHER

	var/initialize_directions_he
	var/surface = 2	//surface area in m^2
	var/icon_temperature = T20C //stop small changes in temperature causing an icon refresh
	var/thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	var/minimum_temperature_difference = 20

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/Initialize()
	. = ..()
	add_filter("glow",1, list(type = "drop_shadow", x = 0, y = 0, offset = 0, size = 4))

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/pipe_color_check(var/color)
	if (color == initial(pipe_color))
		return TRUE
	return FALSE

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/set_dir(new_dir)
	. = ..()
	initialize_directions_he = get_initialize_directions()	// all directions are HE

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/atmos_init()
	atmos_initalized = TRUE
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		QDEL_NULL(nodes_to_networks[node])
	nodes_to_networks = null
	for(var/direction in global.cardinal)
		if(direction & initialize_directions_he) // connect to HE pipes with HE ends in the HE directions
			for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,direction))
				if((target.initialize_directions_he & get_dir(target, src)) && check_connect_types(target, src))
					LAZYDISTINCTADD(nodes_to_networks, target)
		else if(direction & initialize_directions) // and to normal pipes normally in the other directions
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if((target.initialize_directions & get_dir(target, src)) && check_connect_types(target, src))
					if(istype(target, /obj/machinery/atmospherics/pipe/simple/heat_exchanging))
						var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/heat = target
						if(heat.initialize_directions_he & get_dir(target, src)) // this means we are connecting a normal end to an HE end on an HE part; not OK
							continue
					LAZYDISTINCTADD(nodes_to_networks, target)
	update_icon()

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/Process()

	if(!parent)
		..()
		return

	// Handle pipe heat exchange.
	var/turf/turf = loc
	var/datum/gas_mixture/pipe_air = return_air()
	if(istype(loc, /turf/space))
		parent.radiate_heat_to_space(surface, 1)
	else if(istype(turf) && turf.simulated)
		var/environment_temperature = 0
		if(turf.blocks_air)
			environment_temperature = turf.temperature
		else
			var/datum/gas_mixture/environment = turf.return_air()
			environment_temperature = environment?.temperature || 0
		if(abs(environment_temperature-pipe_air.temperature) > minimum_temperature_difference)
			parent.temperature_interact(turf, volume, thermal_conductivity)

	// Burn mobs buckled to this pipe.
	if(buckled_mob)
		var/hc = pipe_air.heat_capacity()
		var/avg_temp = (pipe_air.temperature * hc + buckled_mob.bodytemperature * 3500) / (hc + 3500)
		pipe_air.temperature = avg_temp
		buckled_mob.bodytemperature = avg_temp
		var/heat_limit = buckled_mob.get_mob_temperature_threshold(HEAT_LEVEL_3)
		if(pipe_air.temperature > heat_limit + 1)
			buckled_mob.apply_damage(4 * log(pipe_air.temperature - heat_limit), BURN, BP_CHEST, used_weapon = "Excessive Heat")

	//fancy radiation glowing
	if(pipe_air.temperature && (icon_temperature > 500 || pipe_air.temperature > 500)) //start glowing at 500K
		if(abs(pipe_air.temperature - icon_temperature) > 10)
			icon_temperature = pipe_air.temperature
			var/scale = max((icon_temperature - 500) / 1500, 0)
			var/h_r = heat2color_r(icon_temperature)
			var/h_g = heat2color_g(icon_temperature)
			var/h_b = heat2color_b(icon_temperature)
			if(icon_temperature < 2000) //scale up overlay until 2000K
				h_r = 64 + (h_r - 64)*scale
				h_g = 64 + (h_g - 64)*scale
				h_b = 64 + (h_b - 64)*scale
			var/scale_color = rgb(h_r, h_g, h_b)
			var/list/animate_targets = get_above_oo() + src
			for (var/thing in animate_targets)
				var/atom/movable/AM = thing
				animate(AM, color = scale_color, time = 2 SECONDS, easing = SINE_EASING)
			animate_filter("glow", list(color = scale_color, time = 2 SECONDS, easing = LINEAR_EASING))
			set_light(min(3, scale*2.5), min(3, scale*2.5), scale_color)
	else
		set_light(0, 0)

		//fancy radiation glowing
		if(pipe_air.temperature && (icon_temperature > 500 || pipe_air.temperature > 500)) //start glowing at 500K
			if(abs(pipe_air.temperature - icon_temperature) > 10)
				animate_heat_glow(pipe_air.temperature)
		else
			set_light(0, 0)

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction
	icon = 'icons/atmos/junction.dmi'
	icon_state = "11"
	level = LEVEL_ABOVE_PLATING
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_HE|CONNECT_TYPE_FUEL
	build_icon_state = "junction"
	rotate_class = PIPE_ROTATE_STANDARD

// Doubling up on initialize_directions is necessary to allow HE pipes to connect
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/set_dir(new_dir)
	..()
	initialize_directions_he = dir