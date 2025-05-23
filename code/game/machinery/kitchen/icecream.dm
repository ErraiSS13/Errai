#define ICECREAM_VANILLA 1
#define ICECREAM_CHOCOLATE 2
#define ICECREAM_STRAWBERRY 3
#define ICECREAM_BLUE 4
#define ICECREAM_CHERRY 5
#define ICECREAM_BANANA 6
#define CONE_WAFFLE 7
#define CONE_CHOC 8

// Ported wholesale from Apollo Station.

/obj/machinery/icecream_vat
	name = "icecream vat"
	desc = "A heavy metal container used to produce and store ice cream."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "icecream_vat"
	density = TRUE
	anchored = FALSE
	atom_flags = ATOM_FLAG_NO_CHEM_CHANGE | ATOM_FLAG_OPEN_CONTAINER
	idle_power_usage = 100

	var/list/product_types = list()
	var/dispense_flavour = ICECREAM_VANILLA
	var/flavour_name = "vanilla"

	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null

/obj/machinery/icecream_vat/proc/get_ingredient_list(var/type)
	switch(type)
		if(ICECREAM_CHOCOLATE)
			return list(/decl/material/liquid/drink/milk, /decl/material/solid/ice, /decl/material/liquid/nutriment/coco)
		if(ICECREAM_STRAWBERRY)
			return list(/decl/material/liquid/drink/milk, /decl/material/solid/ice, /decl/material/liquid/drink/juice/berry)
		if(ICECREAM_BLUE)
			return list(/decl/material/liquid/drink/milk, /decl/material/solid/ice, /decl/material/liquid/alcohol/bluecuracao)
		if(ICECREAM_CHERRY)
			return list(/decl/material/liquid/drink/milk, /decl/material/solid/ice, /decl/material/liquid/nutriment/cherryjelly)
		if(ICECREAM_BANANA)
			return list(/decl/material/liquid/drink/milk, /decl/material/solid/ice, /decl/material/liquid/drink/juice/banana)
		if(CONE_WAFFLE)
			return list(/decl/material/liquid/nutriment/flour, /decl/material/liquid/nutriment/sugar)
		if(CONE_CHOC)
			return list(/decl/material/liquid/nutriment/flour, /decl/material/liquid/nutriment/sugar, /decl/material/liquid/nutriment/coco)
		else
			return list(/decl/material/liquid/drink/milk, /decl/material/solid/ice)

/obj/machinery/icecream_vat/proc/get_flavour_name(var/flavour_type)
	switch(flavour_type)
		if(ICECREAM_CHOCOLATE)
			return "chocolate"
		if(ICECREAM_STRAWBERRY)
			return "strawberry"
		if(ICECREAM_BLUE)
			return "blue"
		if(ICECREAM_CHERRY)
			return "cherry"
		if(ICECREAM_BANANA)
			return "banana"
		if(CONE_WAFFLE)
			return "waffle"
		if(CONE_CHOC)
			return "chocolate"
		else
			return "vanilla"

/obj/machinery/icecream_vat/Initialize(mapload, d, populate_parts)
	. = ..()
	initialize_reagents()
	while(product_types.len < 8)
		product_types.Add(5)

/obj/machinery/icecream_vat/initialize_reagents(populate = TRUE)
	create_reagents(100)
	. = ..()

/obj/machinery/icecream_vat/populate_reagents()
	add_to_reagents(/decl/material/liquid/drink/milk, 5)
	add_to_reagents(/decl/material/liquid/nutriment/flour, 5)
	add_to_reagents(/decl/material/liquid/nutriment/sugar, 5)
	add_to_reagents(/decl/material/solid/ice, 5)

/obj/machinery/icecream_vat/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/icecream_vat/interact(mob/user)
	user.set_machine(src)
	var/dat
	dat += "<b>ICECREAM</b><br><div class='statusDisplay'>"
	dat += "<b>Dispensing: [flavour_name] icecream </b> <br><br>"
	dat += "<b>Vanilla icecream:</b> <a href='byond://?src=\ref[src];select=[ICECREAM_VANILLA]'><b>Select</b></a> <a href='byond://?src=\ref[src];make=[ICECREAM_VANILLA];amount=1'><b>Make</b></a> <a href='byond://?src=\ref[src];make=[ICECREAM_VANILLA];amount=5'><b>x5</b></a> [product_types[ICECREAM_VANILLA]] scoops left. (Ingredients: milk, ice)<br>"
	dat += "<b>Strawberry icecream:</b> <a href='byond://?src=\ref[src];select=[ICECREAM_STRAWBERRY]'><b>Select</b></a> <a href='byond://?src=\ref[src];make=[ICECREAM_STRAWBERRY];amount=1'><b>Make</b></a> <a href='byond://?src=\ref[src];make=[ICECREAM_STRAWBERRY];amount=5'><b>x5</b></a> [product_types[ICECREAM_STRAWBERRY]] dollops left. (Ingredients: milk, ice, berry juice)<br>"
	dat += "<b>Chocolate icecream:</b> <a href='byond://?src=\ref[src];select=[ICECREAM_CHOCOLATE]'><b>Select</b></a> <a href='byond://?src=\ref[src];make=[ICECREAM_CHOCOLATE];amount=1'><b>Make</b></a> <a href='byond://?src=\ref[src];make=[ICECREAM_CHOCOLATE];amount=5'><b>x5</b></a> [product_types[ICECREAM_CHOCOLATE]] dollops left. (Ingredients: milk, ice, coco powder)<br>"
	dat += "<b>Blue icecream:</b> <a href='byond://?src=\ref[src];select=[ICECREAM_BLUE]'><b>Select</b></a> <a href='byond://?src=\ref[src];make=[ICECREAM_BLUE];amount=1'><b>Make</b></a> <a href='byond://?src=\ref[src];make=[ICECREAM_BLUE];amount=5'><b>x5</b></a> [product_types[ICECREAM_BLUE]] dollops left. (Ingredients: milk, ice, blue curacao)<br>"
	dat += "<b>Cherry icecream:</b> <a href='byond://?src=\ref[src];select=[ICECREAM_CHERRY]'><b>Select</b></a> <a href='byond://?src=\ref[src];make=[ICECREAM_CHERRY];amount=1'><b>Make</b></a> <a href='byond://?src=\ref[src];make=[ICECREAM_CHERRY];amount=5'><b>x5</b></a> [product_types[ICECREAM_CHERRY]] dollops left. (Ingredients: milk, ice, cherry jelly)<br>"
	dat += "<b>Banana icecream:</b> <a href='byond://?src=\ref[src];select=[ICECREAM_BANANA]'><b>Select</b></a> <a href='byond://?src=\ref[src];make=[ICECREAM_BANANA];amount=1'><b>Make</b></a> <a href='byond://?src=\ref[src];make=[ICECREAM_BANANA];amount=5'><b>x5</b></a> [product_types[ICECREAM_BANANA]] dollops left. (Ingredients: milk, ice, banana)<br></div>"
	dat += "<br><b>CONES</b><br><div class='statusDisplay'>"
	dat += "<b>Waffle cones:</b> <a href='byond://?src=\ref[src];cone=[CONE_WAFFLE]'><b>Dispense</b></a> <a href='byond://?src=\ref[src];make=[CONE_WAFFLE];amount=1'><b>Make</b></a> <a href='byond://?src=\ref[src];make=[CONE_WAFFLE];amount=5'><b>x5</b></a> [product_types[CONE_WAFFLE]] cones left. (Ingredients: flour, sugar)<br>"
	dat += "<b>Chocolate cones:</b> <a href='byond://?src=\ref[src];cone=[CONE_CHOC]'><b>Dispense</b></a> <a href='byond://?src=\ref[src];make=[CONE_CHOC];amount=1'><b>Make</b></a> <a href='byond://?src=\ref[src];make=[CONE_CHOC];amount=5'><b>x5</b></a> [product_types[CONE_CHOC]] cones left. (Ingredients: flour, sugar, coco powder)<br></div>"
	dat += "<br>"
	dat += "<b>VAT CONTENT</b><br>"
	for(var/decl/material/reagent as anything in reagents?.liquid_volumes)
		dat += "[reagent.get_reagent_name(reagents, MAT_PHASE_LIQUID)]: [LIQUID_VOLUME(reagents, reagent)]"
		dat += "<A href='byond://?src=\ref[src];disposeI=\ref[reagent]'>Purge</A><BR>"

	for(var/decl/material/reagent as anything in reagents?.solid_volumes)
		dat += "[reagent.get_reagent_name(reagents, MAT_PHASE_SOLID)]: [SOLID_VOLUME(reagents, reagent)]"
		dat += "<A href='byond://?src=\ref[src];disposeI=\ref[reagent]'>Purge</A><BR>"

	dat += "<a href='byond://?src=\ref[src];refresh=1'>Refresh</a> <a href='byond://?src=\ref[src];close=1'>Close</a>"

	var/datum/browser/popup = new(user, "icecreamvat","Icecream Vat", 700, 500, src)
	popup.set_content(dat)
	popup.open()

/obj/machinery/icecream_vat/attackby(var/obj/item/used_item, var/mob/user)
	if(istype(used_item, /obj/item/food/icecream))
		var/obj/item/food/icecream/icecream = used_item
		if(!icecream.ice_creamed)
			if(product_types[dispense_flavour] > 0)
				src.visible_message("[html_icon(src)] <span class='info'>[user] scoops delicious [flavour_name] icecream into [icecream].</span>")
				product_types[dispense_flavour] -= 1
				icecream.add_ice_cream(flavour_name)
			//	if(beaker)
			//		beaker.reagents.trans_to(icecream, 10)
				if(icecream.reagents.total_volume < 10)
					icecream.add_to_reagents(/decl/material/liquid/nutriment/sugar, 10 - icecream.reagents.total_volume)
			else
				to_chat(user, "<span class='warning'>There is not enough icecream left!</span>")
		else
			to_chat(user, "<span class='notice'>[used_item] already has icecream in it.</span>")
		return TRUE
	else if(ATOM_IS_OPEN_CONTAINER(used_item))
		return TRUE
	else
		return ..()

/obj/machinery/icecream_vat/proc/make(var/mob/user, var/make_type, var/amount)
	for(var/reagent in get_ingredient_list(make_type))
		if(reagents.has_reagent(reagent, amount))
			continue
		amount = 0
		break
	if(amount)
		for(var/reagent in get_ingredient_list(make_type))
			remove_from_reagents(reagent, amount)
		product_types[make_type] += amount
		var/flavour = get_flavour_name(make_type)
		if(make_type > 6)
			src.visible_message("<span class='info'>[user] cooks up some [flavour] cones.</span>")
		else
			src.visible_message("<span class='info'>[user] whips up some [flavour] icecream.</span>")
	else
		to_chat(user, "<span class='warning'>You don't have the ingredients to make this.</span>")

/obj/machinery/icecream_vat/OnTopic(user, href_list)
	if(href_list["close"])
		close_browser(usr, "window=icecreamvat")
		return TOPIC_HANDLED

	if(href_list["select"])
		dispense_flavour = text2num(href_list["select"])
		flavour_name = get_flavour_name(dispense_flavour)
		src.visible_message("<span class='notice'>[user] sets [src] to dispense [flavour_name] flavoured icecream.</span>")
		. = TOPIC_HANDLED

	else if(href_list["cone"])
		var/dispense_cone = text2num(href_list["cone"])
		var/cone_name = get_flavour_name(dispense_cone)
		if(product_types[dispense_cone] >= 1)
			product_types[dispense_cone] -= 1
			var/obj/item/food/icecream/icecream = new(src.loc)
			icecream.cone_type = cone_name
			icecream.icon_state = "icecream_cone_[cone_name]"
			icecream.desc = "Delicious [cone_name] cone, but no ice cream."
			src.visible_message("<span class='info'>[user] dispenses a crunchy [cone_name] cone from [src].</span>")
		else
			to_chat(user, "<span class='warning'>There are no [cone_name] cones left!</span>")
		. = TOPIC_REFRESH

	else if(href_list["make"])
		var/amount = (text2num(href_list["amount"]))
		var/C = text2num(href_list["make"])
		make(user, C, amount)
		. = TOPIC_REFRESH

	else if(href_list["disposeI"])
		var/decl/material/reagent = locate(href_list["disposeI"])
		if(reagent)
			reagents.clear_reagent(reagent.type)
		. = TOPIC_REFRESH

	if(href_list["refresh"])
		. = TOPIC_REFRESH

/obj/item/food/icecream
	name = "ice cream cone"
	desc = "Delicious waffle cone, but no ice cream."
	icon = 'icons/obj/icecream.dmi'
	icon_state = "icecream_cone_waffle" //default for admin-spawned cones, href_list["cone"] should overwrite this all the time
	layer = ABOVE_OBJ_LAYER
	bitesize = 3
	volume = 20
	nutriment_amt = 5
	nutriment_type = /decl/material/liquid/nutriment
	nutriment_desc = list("crunchy waffle cone" = 1)
	var/ice_creamed
	var/cone_type

/obj/item/food/icecream/Initialize(mapload, material_key, skip_plate = FALSE)
	. = ..()
	update_icon()

/obj/item/food/icecream/on_update_icon()
	. = ..()
	if(ice_creamed)
		add_overlay("icecream_[ice_creamed]")

/obj/item/food/icecream/proc/add_ice_cream(var/flavour_name)
	name = "[flavour_name] icecream"
	desc = "Delicious [cone_type] cone with a dollop of [flavour_name] ice cream."
	ice_creamed = flavour_name
	update_icon()

#undef ICECREAM_VANILLA
#undef ICECREAM_CHOCOLATE
#undef ICECREAM_STRAWBERRY
#undef ICECREAM_BLUE
#undef ICECREAM_CHERRY
#undef ICECREAM_BANANA
#undef CONE_WAFFLE
#undef CONE_CHOC