/mob/living/human/get_examine_header(mob/user, distance, infix, suffix, hideflags)
	SHOULD_CALL_PARENT(FALSE)
	. = list("<span class='info'>*---------*<br/>[user == src ? "You are" : "This is"] <EM>[name]</EM>")
	if(!(hideflags & HIDEJUMPSUIT) || !(hideflags & HIDEFACE))
		var/species_name = "\improper "
		if(isSynthetic() && species.cyborg_noun)
			species_name += "[species.cyborg_noun] [species.name]"
		else
			species_name += "[species.name]"
		. += ", <b><font color='[species.get_species_flesh_color(src)]'>\a [species_name]!</font></b>[(user.can_use_codex() && SScodex.get_codex_entry(get_codex_value(user))) ?  SPAN_NOTICE(" \[<a href='byond://?src=\ref[SScodex];show_examined_info=\ref[src];show_to=\ref[user]'>?</a>\]") : ""]"
	var/extra_species_text = species.get_additional_examine_text(src)
	if(extra_species_text)
		. += "<br>[extra_species_text]"
	var/show_descs = show_descriptors_to(user)
	if(show_descs)
		. += "<br><span class='info'>[jointext(show_descs, "<br>")]</span>"
	var/print_flavour = print_flavor_text()
	if(print_flavour)
		. += "<br/>*---------*"
		. += "<br/>[print_flavour]"
	. += "<br/>*---------*"
	. = list(jointext(., null))

/mob/living/human/get_other_examine_strings(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)

	. = ..()

	var/self_examine = (user == src)
	var/use_He    = self_examine ? "You"  : pronouns.He
	var/use_he    = self_examine ? "you"  : pronouns.he
	var/use_His   = self_examine ? "Your" : pronouns.His
	var/use_his   = self_examine ? "your" : pronouns.his
	var/use_is    = self_examine ? "are"  : pronouns.is
	var/use_does  = self_examine ? "do"   : pronouns.does
	var/use_has   = self_examine ? "have" : pronouns.has
	var/use_him   = self_examine ? "you"  : pronouns.him
	var/use_looks = self_examine ? "look" : "looks"

	//Jitters
	var/jitteriness = GET_STATUS(src, STAT_JITTER)
	if(jitteriness >= 300)
		. += "<span class='warning'><B>[use_He] [use_is] convulsing violently!</B></span>"
	else if(jitteriness >= 200)
		. += "<span class='warning'>[use_He] [use_is] extremely jittery.</span>"
	else if(jitteriness >= 100)
		. += "<span class='warning'>[use_He] [use_is] twitching ever so slightly.</span>"

	//Disfigured face
	if(!(hideflags & HIDEFACE)) //Disfigurement only matters for the head currently.
		var/obj/item/organ/external/limb = GET_EXTERNAL_ORGAN(src, BP_HEAD)
		if(limb && (limb.status & ORGAN_DISFIGURED)) //Check to see if we even have a head and if the head's disfigured.
			if(limb.species) //Check to make sure we have a species
				. += limb.species.disfigure_msg(src)
			else //Just in case they lack a species for whatever reason.
				. += "<span class='warning'>[use_His] face is horribly mangled!</span>"

	//splints
	for(var/organ in list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM))
		var/obj/item/organ/external/limb = GET_EXTERNAL_ORGAN(src, organ)
		if(limb && limb.splinted && limb.splinted.loc == limb)
			. += "<span class='warning'>[use_He] [use_has] \a [limb.splinted] on [use_his] [limb.name]!</span>"

	if (stat)
		. += "<span class='warning'>[use_He] [use_is]n't responding to anything around [use_him] and seems to be unconscious.</span>"
		if((stat == DEAD || is_asystole() || suffocation_counter) && distance <= 3)
			. += "<span class='warning'>[use_He] [use_does] not appear to be breathing.</span>"

	var/datum/reagents/touching_reagents = get_contact_reagents()
	if(touching_reagents?.total_volume >= 1)
		var/saturation = touching_reagents.total_volume / touching_reagents.maximum_volume
		if(saturation > 0.9)
			. += "[use_He] [use_is] completely saturated."
		else if(saturation > 0.6)
			. += "[use_He] [use_is] looking half-drowned."
		else if(saturation > 0.3)
			. += "[use_He] [use_is] looking notably soggy."
		else
			. += "[use_He] [use_is] looking a bit soggy."

	var/fire_level = get_fire_intensity()
	if(fire_level > 0)
		. += "[use_He] [use_is] looking highly flammable!"
	else if(fire_level < 0)
		. += "[use_He] [use_is] looking rather incombustible."

	if(is_on_fire())
		. += "<span class='warning'>[use_He] [use_is] on fire!</span>"

	var/ssd_msg = species.get_ssd(src)
	if(ssd_msg && (!should_have_organ(BP_BRAIN) || has_brain()) && stat != DEAD)
		if(!key)
			. += "<span class='deadsay'>[use_He] [use_is] [ssd_msg]. It doesn't look like [use_he] [use_is] waking up anytime soon.</span>"
		else if(!client)
			. += "<span class='deadsay'>[use_He] [use_is] [ssd_msg].</span>"

	var/obj/item/organ/external/head/H = get_organ(BP_HEAD, /obj/item/organ/external/head)
	if(istype(H) && H.forehead_graffiti && H.graffiti_style)
		. += "<span class='notice'>[use_He] [use_has] \"[H.forehead_graffiti]\" written on [use_his] [H.name] in [H.graffiti_style]!</span>"

	if(became_younger)
		. += "[use_He] [use_looks] a lot younger than you remember."
	if(became_older)
		. += "[use_He] [use_looks] a lot older than you remember."

	var/list/wound_flavor_text = list()
	var/applying_pressure = ""
	var/list/shown_objects = list()
	var/list/hidden_bleeders = list()

	var/decl/bodytype/root_bodytype = get_bodytype()
	for(var/organ_tag in root_bodytype.has_limbs)

		var/list/organ_data = root_bodytype.has_limbs[organ_tag]
		var/organ_descriptor = organ_data["descriptor"]
		var/obj/item/organ/external/limb = GET_EXTERNAL_ORGAN(src, organ_tag)

		if(!limb)
			wound_flavor_text[organ_descriptor] = "<b>[use_He] [use_is] missing [use_his] [organ_descriptor].</b>"
			continue

		wound_flavor_text[limb.name] = ""

		if(limb.applied_pressure == src)
			applying_pressure = "<span class='info'>[use_He] [use_is] applying pressure to [use_his] [limb.name].</span>"

		var/obj/item/clothing/hidden
		for(var/slot in global.standard_clothing_slots)
			var/obj/item/clothing/C = get_equipped_item(slot)
			if(istype(C) && (C.body_parts_covered & limb.body_part))
				hidden = C
				break

		if(hidden && user != src)
			if(limb.status & ORGAN_BLEEDING && !(hidden.item_flags & ITEM_FLAG_THICKMATERIAL)) //not through a spacesuit
				if(!hidden_bleeders[hidden])
					hidden_bleeders[hidden] = list()
				hidden_bleeders[hidden] += limb.name
		else
			if(!isSynthetic() && BP_IS_PROSTHETIC(limb) && (limb.parent && !BP_IS_PROSTHETIC(limb.parent)))
				wound_flavor_text[limb.name] = "[use_He] [use_has] a [limb.name].\n"
			var/wounddesc = limb.get_wounds_desc()
			if(wounddesc != "nothing")
				wound_flavor_text[limb.name] += "[use_He] [use_has] [wounddesc] on [use_his] [limb.name]."
		if(!hidden || distance <=1)
			if(limb.is_dislocated())
				wound_flavor_text[limb.name] += "[use_His] [limb.joint] is dislocated!<br>"
			if(((limb.status & ORGAN_BROKEN) && limb.brute_dam > limb.min_broken_damage) || (limb.status & ORGAN_MUTATED))
				wound_flavor_text[limb.name] += "[use_His] [limb.name] is dented and swollen!<br>"
			if(limb.status & ORGAN_DEAD)
				if(BP_IS_PROSTHETIC(limb) || BP_IS_CRYSTAL(limb))
					wound_flavor_text[limb.name] += "[use_His] [limb.name] is irrecoverably damaged!"
				else
					wound_flavor_text[limb.name] += "[use_His] [limb.name] is grey and necrotic!<br>"
			else if((limb.brute_dam + limb.burn_dam) >= limb.max_damage && limb.germ_level >= INFECTION_LEVEL_TWO)
				wound_flavor_text[limb.name] += "[use_His] [limb.name] is likely beyond saving, and has begun to decay!"

		for(var/datum/wound/wound in limb.wounds)
			var/list/embedlist = wound.embedded_objects
			if(LAZYLEN(embedlist))
				shown_objects += embedlist
				var/parsedembed[0]
				for(var/obj/embedded in embedlist)
					if(!parsedembed.len || (!parsedembed.Find(embedded.name) && !parsedembed.Find("multiple [embedded.name]")))
						parsedembed.Add(embedded.name)
					else if(!parsedembed.Find("multiple [embedded.name]"))
						parsedembed.Remove(embedded.name)
						parsedembed.Add("multiple "+embedded.name)
				wound_flavor_text["[limb.name]"] += "The [wound.desc] on [use_his] [limb.name] has \a [english_list(parsedembed, and_text = " and a ", comma_text = ", a ")] sticking out of it!"
	for(var/hidden in hidden_bleeders)
		wound_flavor_text[hidden] = "[use_He] [use_has] blood soaking through [hidden] around [use_his] [english_list(hidden_bleeders[hidden])]!"

	. += "<span class='warning'>"
	for(var/limb in wound_flavor_text)
		. += wound_flavor_text[limb]
	. += "</span>"

	for(var/obj/implant in get_visible_implants(0))
		if(implant in shown_objects)
			continue
		. += "<span class='danger'>[src] [use_has] \a [implant.name] sticking out of [use_his] flesh!</span>"
	if(digitalcamo)
		. += "[use_He] [use_is] repulsively uncanny!"

	if(hasHUD(user, HUD_SECURITY))
		var/perpname = "wot"
		var/criminal = "None"

		var/obj/item/card/id/check_id = GetIdCard()
		if(istype(check_id))
			perpname = check_id.registered_name
		else
			perpname = src.name

		if(perpname)
			var/datum/computer_network/network = user.getHUDnetwork(HUD_SECURITY)
			if(network)
				var/datum/computer_file/report/crew_record/R = network.get_crew_record_by_name(perpname)
				if(R)
					criminal = R.get_criminalStatus()

				. += "<span class = 'deptradio'>Criminal status:</span> <a href='byond://?src=\ref[src];criminal=1'>\[[criminal]\]</a>"
				. += "<span class = 'deptradio'>Security records:</span> <a href='byond://?src=\ref[src];secrecord=1'>\[View\]</a>"

	if(hasHUD(user, HUD_MEDICAL))
		var/perpname = "wot"
		var/medical = "None"

		var/obj/item/card/id/check_id = GetIdCard()
		if(istype(check_id))
			perpname = check_id.registered_name
		else
			perpname = src.name

		var/datum/computer_network/network = user.getHUDnetwork(HUD_MEDICAL)
		if(network)
			var/datum/computer_file/report/crew_record/R = network.get_crew_record_by_name(perpname)
			if(R)
				medical = R.get_status()

			. += "<span class = 'deptradio'>Physical status:</span> <a href='byond://?src=\ref[src];medical=1'>\[[medical]\]</a>"
			. += "<span class = 'deptradio'>Medical records:</span> <a href='byond://?src=\ref[src];medrecord=1'>\[View\]</a>"

	// Show IC/OOC info if available.
	if(comments_record_id)
		var/datum/character_information/comments = SScharacter_info.get_record(comments_record_id)
		if(comments?.show_info_on_examine && (comments.ic_info || comments.ooc_info))
			. += "*---------*"
			if(comments.ic_info)
				if(length(comments.ic_info) <= 40)
					. += "<b>IC Info:</b>"
					. += "&nbsp;&nbsp;&nbsp;&nbsp;[comments.ic_info]"
				else
					. += "<b>IC Info:</b>"
					. += "&nbsp;&nbsp;&nbsp;&nbsp;[copytext_preserve_html(comments.ic_info,1,37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</a>"
			if(comments.ooc_info)
				if(length(comments.ooc_info) <= 40)
					. += "<b>OOC Info:</b>"
					. += "&nbsp;&nbsp;&nbsp;&nbsp;[comments.ooc_info]"
				else
					. += "<b>OOC Info:</b>"
					. += "&nbsp;&nbsp;&nbsp;&nbsp;[copytext_preserve_html(comments.ooc_info,1,37)]... <a href='byond://?src=\ref[src];flavor_more=1'>More...</a>"

	. += "*---------*</span>"
	. += applying_pressure

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "[use_He] [pose]"

	var/list/human_examines = decls_repository.get_decls_of_subtype(/decl/human_examination)
	for(var/exam in human_examines)
		var/decl/human_examination/examiner = human_examines[exam]
		var/adding_text = examiner.do_examine(user, distance, src)
		if(adding_text)
			. += adding_text

	// Foul, todo fix this
	if(stat && ishuman(user) && !user.incapacitated() && Adjacent(user))
		spawn(0)
			user.visible_message("<b>\The [user]</b> checks \the [src]'s pulse.", "You check \the [src]'s pulse.")
			if(do_after(user, 15, src))
				if(get_pulse() == PULSE_NONE)
					to_chat(user, "<span class='deadsay'>[use_He] [use_has] no pulse.</span>")
				else
					to_chat(user, "<span class='deadsay'>[use_He] [use_has] a pulse!</span>")

//Helper procedure. Called by /mob/living/human/examined_by() and /mob/living/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M, hudtype)
	return !!M.getHUDsource(hudtype)

/mob/proc/getHUDsource(hudtype)
	return

/mob/living/human/getHUDsource(hudtype)
	var/obj/item/clothing/glasses/glasses = get_equipped_item(slot_glasses_str)
	if(!istype(glasses))
		return ..()
	if(glasses.glasses_hud_type & hudtype)
		return glasses
	if(glasses.hud && (glasses.hud.glasses_hud_type & hudtype))
		return glasses.hud

/mob/living/silicon/robot/getHUDsource(hudtype)
	for(var/obj/item/borg/sight/sight in get_held_items())
		if(istype(sight) && (sight.glasses_hud_type & hudtype))
			return sight

//Gets the computer network M's source of hudtype is using
/mob/proc/getHUDnetwork(hudtype)
	var/obj/O = getHUDsource(hudtype)
	if(!O)
		return
	var/datum/extension/network_device/D = get_extension(O, /datum/extension/network_device)
	return D.get_network()

/mob/living/silicon/getHUDnetwork(hudtype)
	if(getHUDsource(hudtype))
		return get_computer_network()

/mob/living/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	var/decl/pronouns/pronouns = get_pronouns()
	pose = sanitize(input(usr, "This is [src]. [pronouns.He]...", "Pose", null)  as text)

/mob/living/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/list/HTML = list()
	HTML += "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Update Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='byond://?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	show_browser(src, jointext(HTML,null), "window=flavor_changes;size=430x300")
