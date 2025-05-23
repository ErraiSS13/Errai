var/global/list/registered_weapons = list()
var/global/list/registered_cyborg_weapons = list()

/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/basic_energy.dmi'
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	accuracy = 1

	var/charge_cost = 20           // How much energy is needed to fire.
	var/max_shots = 10             // Determines the capacity of the weapon's power cell, if the type is not overridded in setup_power_supply().
	var/modifystate                // Changes the icon_state used for the charge overlay.
	var/charge_meter = 1           // If set, the icon state will be chosen based on the current charge
	var/indicator_color            // Color used for overlay based charge meters
	var/self_recharge = 0          // If set, the weapon will recharge itself
	var/use_external_power = 0     // If set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4          // How many ticks between recharges.
	var/charge_tick = 0            // Current charge tick tracker.

	// Which projectile type to create when firing.
	var/projectile_type = /obj/item/projectile/beam/practice

/obj/item/gun/energy/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	accepted_cell_type          = accepted_cell_type          || loaded_cell_type || /obj/item/cell/device/variable
	loaded_cell_type            = loaded_cell_type            || accepted_cell_type
	power_supply_extension_type = power_supply_extension_type || /datum/extension/loaded_cell/unremovable
	return ..(loaded_cell_type, accepted_cell_type, power_supply_extension_type, max_shots*charge_cost)

/obj/item/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/gun/energy/Initialize(var/ml, var/material_key)
	setup_power_supply()
	. = ..()
	if(self_recharge)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/gun/energy/Destroy()
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/energy/Process()
	var/obj/item/cell/power_supply = get_cell()
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0

		if(!power_supply || power_supply.charge >= power_supply.maxcharge)
			return 0 // check if we actually need to recharge

		if(use_external_power)
			var/obj/item/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				return 0

		power_supply.give(charge_cost) //... to recharge the shot
		update_icon()
	return 1

/obj/item/gun/energy/consume_next_projectile()
	var/obj/item/cell/power_supply = get_cell()
	if(!power_supply)
		return null
	if(!ispath(projectile_type))
		return null
	if(!power_supply.checked_use(charge_cost))
		return null
	return new projectile_type(src)

/obj/item/gun/energy/proc/get_external_power_supply()
	if(isrobot(loc) || istype(loc, /obj/item/rig_module) || istype(loc, /obj/item/mech_equipment))
		return loc.get_cell()

/obj/item/gun/energy/proc/get_shots_remaining()
	var/obj/item/cell/power_supply = get_cell()
	if(!power_supply)
		return 0
	return round(power_supply.charge / charge_cost)

/obj/item/gun/energy/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/obj/item/cell/power_supply = get_cell()
	if(!power_supply)
		. += "Seems like it's dead."
		return
	if (charge_cost == 0)
		. += "This gun seems to have an unlimited number of shots."
	else
		. += "Has [get_shots_remaining()] shot\s remaining."

/obj/item/gun/energy/proc/get_charge_ratio()
	. = 0
	var/obj/item/cell/power_supply = get_cell()
	if(power_supply)
		var/ratio = power_supply.percent()
		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		// Also make sure cells adminbussed with higher-than-max charge don't break sprites
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = clamp(round(ratio, 25), 25, 100)
		return ratio

/obj/item/gun/energy/on_update_icon()
	..()
	if(charge_meter)
		update_charge_meter()

/obj/item/gun/energy/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && charge_meter)
		var/charge_state = get_charge_state(overlay.icon_state)
		if(charge_state && check_state_in_icon(charge_state, overlay.icon))
			overlay.overlays += mutable_appearance(overlay.icon, charge_state, get_charge_color())
	. = ..()

/obj/item/gun/energy/proc/get_charge_state(var/initial_state)
	return "[initial_state][get_charge_ratio()]"

/obj/item/gun/energy/proc/get_charge_color()
	return indicator_color

/obj/item/gun/energy/proc/update_charge_meter()
	if(use_single_icon)
		add_overlay(mutable_appearance(icon, "[get_world_inventory_state()][get_charge_ratio()]", indicator_color))
		return
	var/obj/item/cell/power_supply = get_cell()
	if(power_supply)
		if(modifystate)
			icon_state = "[modifystate][get_charge_ratio()]"
		else
			icon_state = "[initial(icon_state)][get_charge_ratio()]"
