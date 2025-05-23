/obj/item/gun/launcher/pneumatic
	name = "pneumatic cannon"
	desc = "A large gas-powered cannon."
	icon = 'icons/obj/guns/launcher/pneumatic.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = @'{"combat":4,"materials":3}'
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_HUGE
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	fire_sound_text = "a loud whoosh of moving air"
	fire_delay = 50
	fire_sound = 'sound/weapons/tablehit1.ogg'
	storage = /datum/storage/hopper

	var/fire_pressure                           // Used in fire checks/pressure checks.
	var/obj/item/tank/tank = null               // Tank of gas for use in firing the cannon.

	var/possible_pressure_amounts = list(5,10,20,25,50) // Possible pressure settings.
	var/pressure_setting = 10                   // Percentage of the gas in the tank used to fire the projectile.
	var/force_divisor = 400                     // Force equates to speed. Speed/5 equates to a damage multiplier for whoever you hit.
	                                            // For reference, a fully pressurized oxy tank at 50% gas release firing a health
	                                            // analyzer with a force_divisor of 10 hit with a damage multiplier of 3000+.

/obj/item/gun/launcher/pneumatic/get_stored_inventory()
	. = ..()
	if(length(.) && tank)
		. -= tank

/obj/item/gun/launcher/pneumatic/verb/set_pressure() //set amount of tank pressure.
	set name = "Set Valve Pressure"
	set category = "Object"
	set src in range(0)
	var/N = input("Percentage of tank used per shot:","[src]") as null|anything in possible_pressure_amounts
	if (N)
		pressure_setting = N
		to_chat(usr, "You dial the pressure valve to [pressure_setting]%.")

/obj/item/gun/launcher/pneumatic/proc/eject_tank(mob/user) //Remove the tank.
	if(!tank)
		to_chat(user, "There's no tank in [src].")
		return

	to_chat(user, "You twist the valve and pop the tank out of [src].")
	user.put_in_hands(tank)
	tank = null
	update_icon()

/obj/item/gun/launcher/pneumatic/proc/unload_hopper(mob/user)
	var/list/item_contents = storage?.get_contents()
	if(length(item_contents))
		var/obj/item/removing = item_contents[item_contents.len]
		storage.remove_from_storage(user, removing, src.loc)
		user.put_in_hands(removing)
		to_chat(user, "You remove [removing] from the hopper.")
	else
		to_chat(user, "There is nothing to remove in \the [src].")

/obj/item/gun/launcher/pneumatic/attack_hand(mob/user)
	if(!user.is_holding_offhand(src) || !user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	unload_hopper(user)
	return TRUE

/obj/item/gun/launcher/pneumatic/attackby(obj/item/used_item, mob/user)
	if(!tank && istype(used_item, /obj/item/tank) && user.try_unequip(used_item, src))
		tank = used_item
		user.visible_message(
			"\The [user] jams \the [used_item] into [src]'s valve and twists it closed.",
			"You jam \the [used_item] into \the [src]'s valve and twist it closed."
		)
		update_icon()
		return TRUE
	return ..()

/obj/item/gun/launcher/pneumatic/attack_self(mob/user)
	eject_tank(user)

/obj/item/gun/launcher/pneumatic/consume_next_projectile(atom/movable/firer)
	var/list/storage_contents = storage?.get_contents()
	if(!length(storage_contents))
		return null
	if (!tank)
		to_chat(firer, "There is no gas tank in [src]!")
		return null

	var/environment_pressure = 10
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/environment = T.return_air()
		if(environment)
			environment_pressure = environment.return_pressure()

	fire_pressure = (tank.air_contents.return_pressure() - environment_pressure)*pressure_setting/100
	if(fire_pressure < 10)
		to_chat(firer, "There isn't enough gas in the tank to fire [src].")
		return null

	var/obj/item/launched = storage_contents[1]
	storage.remove_from_storage((ismob(firer) ? firer : null), launched, src)
	return launched

/obj/item/gun/launcher/pneumatic/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance > 2)
		return
	. += "The valve is dialed to [pressure_setting]%."
	if(tank)
		. += "The tank dial reads [tank.air_contents.return_pressure()] kPa."
	else
		. += "Nothing is attached to the tank valve!"

/obj/item/gun/launcher/pneumatic/update_release_force(obj/item/projectile)
	if(tank)
		release_force = ((fire_pressure*tank.volume)/projectile.w_class)/force_divisor //projectile speed.
		if(release_force > 80) release_force = 80 //damage cap.
	else
		release_force = 0

/obj/item/gun/launcher/pneumatic/handle_post_fire()
	if(tank)
		var/lost_gas_amount = tank.air_contents.total_moles*(pressure_setting/100)
		var/datum/gas_mixture/removed = tank.remove_air(lost_gas_amount)

		var/turf/T = get_turf(src.loc)
		if(T) T.assume_air(removed)
	..()

/obj/item/gun/launcher/pneumatic/on_update_icon()
	. = ..()
	if(tank)
		icon_state = "[get_world_inventory_state()]-tank"
	else
		icon_state = get_world_inventory_state()
	update_held_icon()

/obj/item/gun/launcher/pneumatic/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && tank)
		overlay.icon_state += "-tank"
	. = ..()

/obj/item/gun/launcher/pneumatic/small
	name = "small pneumatic cannon"
	desc = "It looks smaller than your garden variety cannon"
	w_class = ITEM_SIZE_NORMAL
	storage = /datum/storage/hopper/small
