// A combined food and drink smartfridge that is access locked.
/obj/machinery/smartfridge/secure/bar
	name = "\improper Food and Drink Display"
	desc = "A storage unit for freshly made food and beverages."
	icon = 'icons/obj/machines/smartfridges/food.dmi'
	overlay_contents_icon = 'icons/obj/machines/smartfridges/contents_food.dmi'
	req_access = list(list(access_bar, access_kitchen))
	opacity = TRUE

/obj/machinery/smartfridge/secure/bar/accept_check(var/obj/item/O)
	var/static/list/_allowed_types = list(
		/obj/item/food,
		/obj/item/utensil,
		/obj/item/chems/glass,
		/obj/item/chems/drinks,
		/obj/item/chems/condiment
	)
	return istype(O) && O.reagents?.total_volume && is_type_in_list(O, _allowed_types)


/obj/machinery/computer/modular/preset/pilot
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/reports
	)
