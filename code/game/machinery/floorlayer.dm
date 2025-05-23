/obj/machinery/floorlayer

	name = "automatic floor layer"
	icon = 'icons/obj/machines/pipe_dispenser.dmi'
	icon_state = "pipe_d"
	density = TRUE
	interact_offline = TRUE
	var/turf/old_turf
	var/on = 0
	var/obj/item/stack/tile/T
	var/list/mode = list("dismantle"=0,"laying"=0,"collect"=0)

/obj/machinery/floorlayer/Initialize()
	. = ..()
	T = new /obj/item/stack/tile/floor(src)

/obj/machinery/floorlayer/Move(new_turf,M_Dir)
	. = ..()

	if(on)
		if(mode["dismantle"])
			dismantle_floor(old_turf)

		if(mode["laying"])
			lay_floor(old_turf)

		if(mode["collect"])
			CollectTiles(old_turf)


	old_turf = new_turf

/obj/machinery/floorlayer/physical_attack_hand(mob/user)
	on=!on
	user.visible_message("<span class='notice'>[user] has [!on?"de":""]activated \the [src].</span>", "<span class='notice'>You [!on?"de":""]activate \the [src].</span>")
	return TRUE

/obj/machinery/floorlayer/attackby(var/obj/item/used_item, var/mob/user)

	if(IS_WRENCH(used_item))
		var/m = input("Choose work mode", "Mode") as null|anything in mode
		mode[m] = !mode[m]
		var/O = mode[m]
		user.visible_message("<span class='notice'>[user] has set \the [src] [m] mode [!O?"off":"on"].</span>", "<span class='notice'>You set \the [src] [m] mode [!O?"off":"on"].</span>")
		return TRUE

	if(istype(used_item, /obj/item/stack/tile))
		if(!user.try_unequip(used_item, T))
			return TRUE
		to_chat(user, "<span class='notice'>\The [used_item] successfully loaded.</span>")
		TakeTile(T)
		return TRUE

	if(IS_CROWBAR(used_item))
		if(!length(contents))
			to_chat(user, "<span class='notice'>\The [src] is empty.</span>")
		else
			var/obj/item/stack/tile/E = input("Choose remove tile type.", "Tiles") as null|anything in contents
			if(E)
				to_chat(user, "<span class='notice'>You remove \the [E] from \the [src].</span>")
				E.dropInto(loc)
				T = null
		return TRUE

	if(IS_SCREWDRIVER(used_item))
		T = input("Choose tile type.", "Tiles") as null|anything in contents
		return TRUE
	return ..()

/obj/machinery/floorlayer/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/dismantle = mode["dismantle"]
	var/laying    = mode["laying"]
	var/collect   = mode["collect"]
	. += SPAN_NOTICE("\The [src] [!T?"don't ":""]has [!T?"":"[T.get_amount()] [T] "]tile\s, dismantle is [dismantle?"on":"off"], laying is [laying?"on":"off"], collect is [collect?"on":"off"].")

/obj/machinery/floorlayer/proc/reset()
	on = 0

/obj/machinery/floorlayer/proc/dismantle_floor(var/turf/new_turf)
	if(istype(new_turf, /turf/floor))
		var/turf/floor/T = new_turf
		if(!T.is_plating())
			T.clear_flooring(place_product = !T.is_floor_damaged())
	return new_turf.is_plating()

/obj/machinery/floorlayer/proc/TakeNewStack()
	for(var/obj/item/stack/tile/tile in contents)
		T = tile
		return 1
	return 0

/obj/machinery/floorlayer/proc/SortStacks()
	for(var/obj/item/stack/tile/tile1 in contents)
		for(var/obj/item/stack/tile/tile2 in contents)
			tile2.transfer_to(tile1)

/obj/machinery/floorlayer/proc/lay_floor(var/turf/w_turf)
	if(!T)
		if(!TakeNewStack())
			return 0
	w_turf.attackby(T , src)
	return 1

/obj/machinery/floorlayer/proc/TakeTile(var/obj/item/stack/tile/tile)
	if(!T)	T = tile
	tile.forceMove(src)

	SortStacks()

/obj/machinery/floorlayer/proc/CollectTiles(var/turf/w_turf)
	for(var/obj/item/stack/tile/tile in w_turf)
		TakeTile(tile)
