/obj/abstract/turbolift_spawner/shipmap
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	depth = 3
	lift_size_x = 4
	lift_size_y = 4

/obj/abstract/turbolift_spawner/shipmap/fore
	name = "Shipmap turbolift map placeholder - fore"
	dir = WEST

	areas_to_use = list(
		/area/turbolift/errai/deck_three_fore,
		/area/turbolift/errai/deck_two_fore,
		/area/turbolift/errai/deck_one_fore
		)

/obj/abstract/turbolift_spawner/shipmap/aft
	name = "Shipmap turbolift map placeholder - aft"
	dir = EAST

	areas_to_use = list(
		/area/turbolift/errai/deck_three_aft,
		/area/turbolift/errai/deck_two_aft,
		/area/turbolift/errai/deck_one_aft
		)

/obj/abstract/turbolift_spawner/shipmap/small
	abstract_type = /obj/abstract/turbolift_spawner/shipmap/small
	icon = 'icons/obj/turbolift_preview_nowalls_3x3.dmi' // This is wrong but there is no 2x2.
	dir = SOUTH
	depth = 2
	lift_size_x = 1
	lift_size_y = 1
	door_type =     null
	wall_type =     null
	firedoor_type = null
	light_type =    null
	floor_type =  /turf/floor/tiled/steel_grid
	button_type = /obj/structure/lift/button/standalone
	panel_type =  /obj/structure/lift/panel/standalone
	floor_departure_sound = 'sound/effects/lift_heavy_start.ogg'
	floor_arrival_sound =   'sound/effects/lift_heavy_stop.ogg'

/obj/abstract/turbolift_spawner/shipmap/small/atmospherics
	name = "Atmospherics cargo elevator placeholder"
	dir = EAST
	door_type = /obj/machinery/door/window/brigdoor/eastleft
	areas_to_use = list(
		/area/turbolift/errai/atmospherics_deck_three,
		/area/turbolift/errai/atmospherics_deck_two
	)
