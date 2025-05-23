//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/*Composed of 7 parts
3 Particle emitters
proc
emit_particle()

1 power box
the only part of this thing that uses power, can hack to mess with the pa/make it better.
Lies, only the control computer draws power.

1 fuel chamber
contains procs for mixing gas and whatever other fuel it uses
mix_gas()

1 gas holder WIP
acts like a tank valve on the ground that you wrench gas tanks onto
proc
extract_gas()
return_gas()
attach_tank()
remove_tank()
get_available_mix()

1 End Cap

1 Control computer
interface for the pa, acts like a computer with an html menu for diff parts and a status report
all other parts contain only a ref to this
a /machine/, tells the others to do work
contains ref for all parts
proc
process()
check_build()

Setup map
  |EC|
CC|FC|
  |PB|
PE|PE|PE


Icon Addemdum
Icon system is much more robust, and the icons are all variable based.
Each part has a reference string, powered, strength, and contruction values.
Using this the update_icon() proc is simplified a bit (using for absolutely was problematic with naming),
so the icon_state comes out be:
"[reference][strength]", with a switch controlling construction_states and ensuring that it doesn't
power on while being contructed, and all these variables are set by the computer through it's scan list
Essential order of the icons:
Standard - [reference]
Wrenched - [reference]
Wired    - [reference]w
Closed   - [reference]c
Powered  - [reference]p[strength]
Strength being set by the computer and a null strength (Computer is powered off or inactive) returns a 'null', counting as empty
So, hopefully this is helpful if any more icons are to be added/changed/wondering what the hell is going on here

*/

/obj/structure/particle_accelerator
	name = "Particle Accelerator"
	desc = "Part of a Particle Accelerator."
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "none"
	anchored = FALSE
	density = TRUE
	obj_flags = OBJ_FLAG_ROTATABLE

	var/obj/machinery/particle_accelerator/control_box/master = null
	var/construction_state = 0
	var/reference = null
	var/powered = 0
	var/strength = null
	var/desc_holder = null

/obj/structure/particle_accelerator/Destroy()
	construction_state = 0
	if(master)
		master.part_scan()
	. = ..()

/obj/structure/particle_accelerator/end_cap
	name = "Alpha Particle Generation Array"
	desc_holder = "This is where Alpha particles are generated from \[REDACTED\]"
	icon_state = "end_cap"
	reference = "end_cap"

/obj/structure/particle_accelerator/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	switch(construction_state)
		if(0)
			. += "Looks like it's not attached to the flooring."
		if(1)
			. += "It is missing some cables."
		if(2)
			. += "The panel is open."
		if(3)
			if(powered)
				. += desc_holder
			else
				. += "\The [src] is assembled."

/obj/structure/particle_accelerator/attackby(obj/item/used_item, mob/user)
	if(has_extension(used_item, /datum/extension/tool))
		if(process_tool_hit(used_item,user))
			return TRUE
	return ..()

/obj/structure/particle_accelerator/Move()
	. = ..()
	if(master && master.active)
		master.toggle_power()
		investigate_log("was moved whilst active; it <font color='red'>powered down</font>.","singulo")

/obj/structure/particle_accelerator/explosion_act(severity)
	. = ..()
	if(severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(25)))
		physically_destroyed()

/obj/structure/particle_accelerator/on_update_icon()
	..()
	switch(construction_state)
		if(0,1)
			icon_state="[reference]"
		if(2)
			icon_state="[reference]w"
		if(3)
			if(powered)
				icon_state="[reference]p[strength]"
			else
				icon_state="[reference]c"

/obj/structure/particle_accelerator/proc/update_state()
	if(master)
		master.update_state()
		return 0


/obj/structure/particle_accelerator/proc/report_ready(var/obj/O)
	if(O && (O == master))
		if(construction_state >= 3)
			return 1
	return 0


/obj/structure/particle_accelerator/proc/report_master()
	if(master)
		return master
	return 0


/obj/structure/particle_accelerator/proc/connect_master(var/obj/O)
	if(O && istype(O,/obj/machinery/particle_accelerator/control_box))
		if(O.dir == src.dir)
			master = O
			return 1
	return 0


/obj/structure/particle_accelerator/proc/process_tool_hit(var/obj/item/O, var/mob/user)
	if(!istype(O) || !ismob(user))
		return FALSE

	var/temp_state = src.construction_state
	switch(src.construction_state)//TODO:Might be more interesting to have it need several parts rather than a single list of steps
		if(0)
			if(IS_WRENCH(O))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				src.anchored = TRUE
				user.visible_message("[user.name] secures \the [src] to the floor.", \
					"You secure the external bolts.")
				temp_state++
		if(1)
			if(IS_WRENCH(O))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				src.anchored = FALSE
				user.visible_message("[user.name] detaches \the [src] from the floor.", \
					"You remove the external bolts.")
				temp_state--
			else if(IS_COIL(O))
				if(O:use(1,user))
					user.visible_message("[user.name] adds wires to \the [src].", \
						"You add some wires.")
					temp_state++
		if(2)
			if(IS_WIRECUTTER(O))//TODO:Shock user if it's on?
				user.visible_message("[user.name] removes some wires from \the [src].", \
					"You remove some wires.")
				temp_state--
			else if(IS_SCREWDRIVER(O))
				user.visible_message("[user.name] closes \the [src]'s access panel.", \
					"You close the access panel.")
				temp_state++
		if(3)
			if(IS_SCREWDRIVER(O))
				user.visible_message("[user.name] opens \the [src]'s access panel.", \
					"You open the access panel.")
				temp_state--
	if(temp_state == src.construction_state)//Nothing changed
		return 0
	else
		src.construction_state = temp_state
		if(src.construction_state < 3)//Was taken apart, update state
			update_state()
		update_icon()
		return 1

/obj/machinery/particle_accelerator
	name = "Particle Accelerator"
	desc = "Part of a Particle Accelerator."
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "none"
	anchored = FALSE
	density = TRUE
	use_power = POWER_USE_OFF
	idle_power_usage = 0
	active_power_usage = 0
	var/construction_state = 0
	var/active = 0
	var/reference = null
	var/powered = null
	var/strength = 0
	var/desc_holder = null

/obj/machinery/particle_accelerator/on_update_icon()
	return

/obj/machinery/particle_accelerator/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	switch(construction_state)
		if(0)
			. += "Looks like it's not attached to the flooring."
		if(1)
			. += "It is missing some cables."
		if(2)
			. += "The panel is open."
		if(3)
			if(powered)
				. += desc_holder
			else
				. += "\The [src] is assembled."

/obj/machinery/particle_accelerator/attackby(obj/item/used_item, mob/user)
	if(has_extension(used_item, /datum/extension/tool))
		if(process_tool_hit(used_item,user))
			return TRUE
	return ..()

/obj/machinery/particle_accelerator/explosion_act(severity)
	. = ..()
	if(. && (severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(25))))
		physically_destroyed()

/obj/machinery/particle_accelerator/proc/update_state()
	return 0

/obj/machinery/particle_accelerator/proc/process_tool_hit(var/obj/item/O, var/mob/user)
	if(!istype(O) || !ismob(user))
		return FALSE
	var/temp_state = src.construction_state
	switch(src.construction_state)//TODO:Might be more interesting to have it need several parts rather than a single list of steps
		if(0)
			if(IS_WRENCH(O))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				src.anchored = TRUE
				user.visible_message("[user.name] secures \the [src] to the floor.", \
					"You secure the external bolts.")
				temp_state++
		if(1)
			if(IS_WRENCH(O))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				src.anchored = FALSE
				user.visible_message("[user.name] detaches \the [src] from the floor.", \
					"You remove the external bolts.")
				temp_state--
			else if(IS_COIL(O))
				if(O:use(1))
					user.visible_message("[user.name] adds wires to \the [src].", \
						"You add some wires.")
					temp_state++
		if(2)
			if(IS_WIRECUTTER(O))//TODO:Shock user if it's on?
				user.visible_message("[user.name] removes some wires from \the [src].", \
					"You remove some wires.")
				temp_state--
			else if(IS_SCREWDRIVER(O))
				user.visible_message("[user.name] closes \the [src]'s access panel.", \
					"You close the access panel.")
				temp_state++
		if(3)
			if(IS_SCREWDRIVER(O))
				user.visible_message("[user.name] opens \the [src]'s access panel.", \
					"You open the access panel.")
				temp_state--
				active = 0
	if(temp_state == src.construction_state)//Nothing changed
		return 0
	else
		if(src.construction_state < 3)//Was taken apart, update state
			update_state()
			if(use_power)
				update_use_power(POWER_USE_OFF)
		src.construction_state = temp_state
		if(src.construction_state >= 3)
			update_use_power(POWER_USE_IDLE)
		update_icon()
		return 1