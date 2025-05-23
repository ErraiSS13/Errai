/datum/event/rogue_drone
	endWhen = 1000
	var/list/drones_list = list()

/datum/event/rogue_drone/start()
	//spawn them at the same place as carp
	var/list/possible_spawns = list()
	for(var/obj/abstract/landmark/C in global.all_landmarks)
		if(C.name == "carpspawn")
			possible_spawns.Add(C)

	if(!length(possible_spawns))
		return

	//25% chance for this to be a false alarm
	var/num
	if(prob(25))
		num = 0
	else
		num = rand(2,6)
	for(var/i=0, i<num, i++)
		var/mob/living/simple_animal/hostile/malf_drone/D = new(get_turf(pick(possible_spawns)))
		drones_list.Add(D)
		if(prob(25))
			D.disabled = rand(15, 60)

/datum/event/rogue_drone/announce()
	var/msg
	if(prob(33))
		msg = "Attention: unidentified patrol drones detected within proximity to the [location_name()]"
	else if(prob(50))
		msg = "Unidentified Unmanned Drones approaching the [location_name()]. All hands take notice."
	else
		msg = "Class II Laser Fire detected nearby the [location_name()]."
	command_announcement.Announce(msg, "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/rogue_drone/end()
	var/num_recovered = 0
	for(var/mob/living/simple_animal/hostile/malf_drone/D in drones_list)
		spark_at(D.loc)
		D.has_loot = 0
		qdel(D)
		num_recovered++

	if(num_recovered > drones_list.len * 0.75)
		command_announcement.Announce("Be advised: sensors indicate the unidentified drone swarm has left the immediate proximity of the [location_name()].", "[location_name()] Sensor Array", zlevels = affecting_z)
	else
		command_announcement.Announce("Be advised: sensors indicate the unidentified drone swarm has left the immediate proximity of the [location_name()].", "[location_name()] Sensor Array", zlevels = affecting_z)
