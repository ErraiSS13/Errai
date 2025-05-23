/obj/machinery/gateway
	name = "gateway"
	desc = "A mysterious gateway built by unknown hands, it allows for faster than light travel to far-flung locations."
	icon = 'icons/obj/machines/gateway.dmi'
	icon_state = "off"
	density = TRUE
	anchored = TRUE
	var/active = 0


/obj/machinery/gateway/Initialize()
	update_icon()
	if(dir == SOUTH)
		set_density(0)
	. = ..()

/obj/machinery/gateway/on_update_icon()
	if(active)
		icon_state = "on"
		return
	icon_state = "off"



//this is da important part wot makes things go
/obj/machinery/gateway/centerstation
	density = TRUE
	icon_state = "offcenter"

	//warping vars
	var/list/linked = list()
	var/ready = 0				//have we got all the parts for a gateway?
	var/wait = 0				//this just grabs world.time at world start
	var/obj/machinery/gateway/centeraway/awaygate = null

/obj/machinery/gateway/centerstation/Initialize()
	update_icon()
	wait = world.time + get_config_value(/decl/config/num/gateway_delay)	//+ thirty minutes default
	awaygate = locate(/obj/machinery/gateway/centeraway)
	. = ..()

/obj/machinery/gateway/centerstation/on_update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"



/obj/machinery/gateway/centerstation/Process()
	if(stat & (NOPOWER))
		if(active) toggleoff()
		return

	if(active)
		use_power_oneoff(5000)


/obj/machinery/gateway/centerstation/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in global.alldirs)
		T = get_step(loc, i)
		var/obj/machinery/gateway/G = locate(/obj/machinery/gateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = 0
		toggleoff()
		break

	if(linked.len == 8)
		ready = 1


/obj/machinery/gateway/centerstation/proc/toggleon(mob/user)
	if(!ready)
		return
	if(linked.len != 8)
		return
	if(stat & NOPOWER)
		return
	if(!awaygate)
		to_chat(user, "<span class='notice'>Error: No destination found.</span>")
		return
	if(world.time < wait)
		to_chat(user, "<span class='notice'>Error: Warpspace triangulation in progress. Estimated time to completion: [round(((wait - world.time) / 10) / 60)] minutes.</span>")
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()


/obj/machinery/gateway/centerstation/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = 0
		G.update_icon()
	active = 0
	update_icon()


/obj/machinery/gateway/centerstation/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS, TRUE))
		return ..()
	if(!ready)
		detect()
		return TRUE
	if(!active)
		toggleon(user)
		return TRUE
	toggleoff()
	return TRUE

//okay, here's the good teleporting stuff
/obj/machinery/gateway/centerstation/Bumped(atom/movable/M)
	if(!ready)		return
	if(!active)		return
	if(!awaygate)	return
	if(awaygate.calibrated)
		M.forceMove(get_step(awaygate.loc, SOUTH))
		M.set_dir(SOUTH)
		return

/obj/machinery/gateway/centerstation/attackby(obj/item/used_item, mob/user)
	if(IS_MULTITOOL(used_item))
		to_chat(user, "The gate is already calibrated, there is no work for you to do here.")
		return TRUE
	return FALSE

/////////////////////////////////////Away////////////////////////


/obj/machinery/gateway/centeraway
	density = TRUE
	icon_state = "offcenter"
	use_power = POWER_USE_OFF
	var/calibrated = 1
	var/list/linked = list()	//a list of the connected gateway chunks
	var/ready = 0
	var/obj/machinery/gateway/centerstation/stationgate = null


/obj/machinery/gateway/centeraway/Initialize()
	update_icon()
	stationgate = locate(/obj/machinery/gateway/centerstation)
	. = ..()

/obj/machinery/gateway/centeraway/on_update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"


/obj/machinery/gateway/centeraway/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in global.alldirs)
		T = get_step(loc, i)
		var/obj/machinery/gateway/G = locate(/obj/machinery/gateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = 0
		toggleoff()
		break

	if(linked.len == 8)
		ready = 1


/obj/machinery/gateway/centeraway/proc/toggleon(mob/user)
	if(!ready)			return
	if(linked.len != 8)	return
	if(!stationgate)
		to_chat(user, "<span class='notice'>Error: No destination found.</span>")
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()


/obj/machinery/gateway/centeraway/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = 0
		G.update_icon()
	active = 0
	update_icon()


/obj/machinery/gateway/centeraway/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS, TRUE))
		return ..()
	if(!ready)
		detect()
		return TRUE
	if(!active)
		toggleon(user)
		return TRUE
	toggleoff()
	return TRUE

/obj/machinery/gateway/centeraway/Bumped(atom/movable/M)
	if(!ready)	return
	if(!active)	return
	if(ishuman(M))
		for(var/obj/item/implant/exile/E in M)//Checking that there is an exile implant in the contents
			if(E.imp_in == M)//Checking that it's actually implanted vs just in their pocket
				to_chat(M, "The remote gate has detected your exile implant and is blocking your entry.")
				return
	M.forceMove(get_step(stationgate.loc, SOUTH))
	M.set_dir(SOUTH)

/obj/machinery/gateway/centeraway/attackby(obj/item/used_item, mob/user)
	if(IS_MULTITOOL(used_item))
		if(calibrated)
			to_chat(user, "The gate is already calibrated, there is no work for you to do here.")
			return TRUE
		else
			to_chat(user, "<span class='notice'><b>Recalibration successful!</b></span>: This gate's systems have been fine tuned.  Travel to this gate will now be on target.")
			calibrated = 1
			return TRUE
	return FALSE
