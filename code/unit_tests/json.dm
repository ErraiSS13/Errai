/datum/unit_test/items_shall_use_tech_levels_in_origin_tech
	name = "JSON: Items shall use valid tech levels in origin_tech JSON"

/datum/unit_test/items_shall_use_tech_levels_in_origin_tech/start_test()
	var/list/failures
	for(var/subtype in typesof(/obj/item))
		var/obj/item/test = subtype
		var/check_json = initial(test.origin_tech)
		if(isnull(check_json))
			continue
		try
			var/list/output = cached_json_decode(check_json)
			if(!islist(output) || !length(output))
				LAZYADD(failures, check_json)
			else
				for(var/tech in output)
					if(!isnum(output[tech]) || output[tech] < 1)
						LAZYADD(failures, check_json)
					else
						var/decl/research_field/field = SSfabrication.get_research_field_by_id(tech)
						if(!istype(field) || !field.name)
							LAZYADD(failures, "[subtype] - [tech]")
		catch()
			LAZYADD(failures, check_json)
	if(LAZYLEN(failures))
		fail("Some items had invalid tech levels present in origin_tech: [english_list(failures)].")
	else
		pass("All items with origin_tech have valid tech levels.")
	return 1

/datum/unit_test/atoms_should_use_valid_json
	name = "JSON: Atoms using JSON should have valid JSON values"

/datum/unit_test/atoms_should_use_valid_json/start_test()
	// Tried doing this with a list, but accessing initial vars is noodly
	// without an object instance so I'm being slack and hardcoding it.
	var/list/failures
	var/list/json_to_check

	for(var/atom/movable/subtype as anything in typesof(/obj))
		if(TYPE_IS_ABSTRACT(subtype))
			continue
		var/check_json = subtype::buckle_pixel_shift
		if(istext(check_json))
			LAZYSET(json_to_check, "[subtype].buckle_pixel_shift", check_json)
	for(var/subtype in typesof(/obj))
		var/obj/test = subtype
		var/check_json = initial(test.directional_offset)
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[subtype].directional_offset", check_json)
	for(var/subtype in typesof(/obj/item))
		var/obj/item/test = subtype
		var/check_json = initial(test.center_of_mass)
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[subtype].center_of_mass", check_json)
	for(var/subtype in typesof(/obj/item/chems))
		var/obj/item/chems/test = subtype
		var/check_json = initial(test.possible_transfer_amounts)
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[subtype].possible_transfer_amounts", check_json)
	for(var/subtype in typesof(/obj/item/chems/drinks))
		var/obj/item/chems/drinks/test = subtype
		var/check_json = initial(test.filling_states)
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[subtype].filling_states", check_json)
	for(var/subtype in typesof(/obj/item/chems/drinks/glass2))
		var/obj/item/chems/drinks/glass2/test = subtype
		var/check_json = initial(test.rim_pos)
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[subtype].rim_pos", check_json)
	for(var/subtype in typesof(/obj/structure/reagent_dispensers))
		var/obj/structure/reagent_dispensers/test = subtype
		var/check_json = initial(test.possible_transfer_amounts)
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[subtype].possible_transfer_amounts", check_json)
	for(var/mob/subtype as anything in typesof(/mob))
		if(TYPE_IS_ABSTRACT(subtype))
			continue
	var/list/quadruped_bodytypes = decls_repository.get_decls_of_subtype(/decl/bodytype/quadruped)
	for(var/quad_bodytype_path in quadruped_bodytypes)
		var/decl/bodytype/quadruped/quad_bodytype = quadruped_bodytypes[quad_bodytype_path]
		var/check_json = quad_bodytype.riding_offset
		if(istext(check_json))
			LAZYSET(json_to_check, "[quad_bodytype_path].riding_offset", check_json)
	var/list/prefabs = decls_repository.get_decls_of_subtype(/decl/prefab/ic_assembly)
	for(var/assembly_path in prefabs)
		var/decl/prefab/ic_assembly/assembly = prefabs[assembly_path]
		var/check_json = assembly.data
		if(!isnull(check_json))
			LAZYSET(json_to_check, "[assembly_path].data", check_json)
	// Validate JSON.
	for(var/check_key in json_to_check)
		try
			var/list/output = cached_json_decode(json_to_check[check_key])
			if(findtext(json_to_check[check_key], "{'") || !islist(output) || !length(output))
				LAZYADD(failures, check_key)
		catch()
			LAZYADD(failures, check_key)
	if(LAZYLEN(failures))
		fail("Some atoms had invalid JSON defined: [english_list(failures)].")
	else
		pass("All atoms expecting JSON values have valid JSON.")

	return 1

