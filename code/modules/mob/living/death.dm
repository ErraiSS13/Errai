/mob/living/death(gibbed)
	. = ..()
	if(.)
		if(buckled_mob)
			unbuckle_mob()
		if(hiding)
			hiding = FALSE
		var/obj/item/rig/rig = get_rig()
		if(rig)
			rig.notify_ai(SPAN_DANGER("Warning: user death event. Mobility control passed to integrated intelligence system."))
		stop_aiming(no_message=1)
		if(istype(ai))
			ai.handle_death(gibbed)
		handle_regular_hud_updates() // Update health icon etc.

		var/decl/species/my_species = get_species()
		if(my_species)
			if(!gibbed && my_species.death_sound)
				playsound(loc, my_species.death_sound, 80, 1, 1)
			my_species.handle_death(src)

