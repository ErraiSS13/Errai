// Uncomment this define to check for possible lengthy processing of emp_act()s.
// If emp_act() takes more than defined deciseconds (1/10 seconds) an admin message and log is created.
// I do not recommend having this uncommented on main server, it probably causes a bit more lag, espicially with larger EMPs.

// #define EMPDEBUG 10

/proc/empulse(turf/epicenter, heavy_range, light_range, log=0)
	if(!epicenter) return

	if(!isturf(epicenter))
		epicenter = get_turf(epicenter.loc)

	if(log)
		log_and_message_admins("EMP with size ([heavy_range], [light_range]) in area [epicenter.loc.name] ")

	if(heavy_range > 1)
		new /obj/effect/temp_visual/emppulse(epicenter)

	if(heavy_range > light_range)
		light_range = heavy_range

	for(var/mob/M in range(heavy_range, epicenter))
		sound_to(M, 'sound/effects/EMPulse.ogg')

	for(var/atom/T in range(light_range, epicenter))
		#ifdef EMPDEBUG
		var/time = world.timeofday
		#endif
		var/distance = get_dist(epicenter, T)
		if(distance < 0)
			distance = 0
		if(distance < heavy_range)
			T.emp_act(1)
		else if(distance == heavy_range)
			if(prob(50))
				T.emp_act(1)
			else
				T.emp_act(2)
		else if(distance <= light_range)
			T.emp_act(2)
		#ifdef EMPDEBUG
		if((world.timeofday - time) >= EMPDEBUG)
			log_and_message_admins("EMPDEBUG: [T.name] - [T.type] - took [world.timeofday - time]ds to process emp_act()!")
		#endif
	return 1