// This is more or less the same as the AI/borg job code in the standard jobs modpack but including all of that just for these feels like a bit much.
// plus it has a dependency on psionics which is a feature not wanted.

/datum/job/shipmap/head/ai
	title = "AI"
	description = "You serve the crew of the ship, in accordance with your laws. You also manage any Robots that are linked to you."
	supervisors = "your laws"
	selection_color = "#2c2c2c"
	hud_icon = null
	hud_icon_state = "hudblank"
	department_types = list(/decl/department/synthetics)
	outfit_type = /decl/outfit/job/shipmap/synthetics/ai
	total_positions = 0 // Not used for AI, see is_position_available below and modules/mob/living/silicon/ai/latejoin.dm
	spawn_positions = 1
	account_allowed = FALSE
	loadout_allowed = FALSE
	economic_power = 0
	skill_points = 0
	no_skill_buffs = TRUE
	skip_loadout_preview = TRUE
	event_categories = list(ASSIGNMENT_COMPUTER)

/datum/job/shipmap/head/ai/equip_job(var/mob/living/human/H)
	return !!H

/datum/job/shipmap/head/ai/is_position_available()
	return (empty_playable_ai_cores.len != 0)

/datum/job/shipmap/head/ai/handle_variant_join(var/mob/living/human/H, var/alt_title)
	return H

/datum/job/shipmap/head/ai/do_spawn_special(var/mob/living/character, var/mob/new_player/new_player_mob, var/latejoin)
	character = character.AIize() // AIize the character, but don't move them yet

	// is_available for AI checks that there is an empty core available in this list
	var/obj/structure/aicore/deactivated/C = empty_playable_ai_cores[1]
	empty_playable_ai_cores -= C

	character.forceMove(C.loc)
	var/mob/living/silicon/ai/A = character
	A.on_mob_init()

	if(latejoin)
		new_player_mob.AnnounceCyborg(character, title, "has been downloaded to the empty core in \the [get_area_name(src)]")
	SSticker.mode.handle_latejoin(character)

	qdel(C)
	return TRUE


/datum/job/shipmap/robot
	title = "Robot"
	description = "You serve the crew of the ship, and your AI, in accordance with your laws."
	supervisors = "your laws and the AI"
	selection_color = "#3f3f3f"
	department_types = list(/decl/department/synthetics)
	outfit_type = /decl/outfit/job/shipmap/synthetics/robot
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 7
	loadout_allowed = FALSE
	account_allowed = FALSE
	economic_power = 0
	hud_icon = null
	hud_icon_state = "hudblank"
	skill_points = 0
	no_skill_buffs = TRUE
	guestbanned = TRUE
	not_random_selectable = TRUE
	skip_loadout_preview = TRUE
	event_categories = list(ASSIGNMENT_ROBOT)

// I hate this copypasta.
/datum/job/shipmap/robot/handle_variant_join(var/mob/living/human/H, var/alt_title)
	if(H)
		return H.Robotize(SSrobots.get_mob_type_by_title(alt_title || title))

/datum/job/shipmap/robot/equip_job(var/mob/living/human/H)
	return !!H

/datum/job/shipmap/robot/New()
	..()
	alt_titles = SSrobots.robot_alt_titles.Copy()
	alt_titles -= title // So the unit test doesn't flip out if a mob or brain type is declared for our main title.

/obj/abstract/landmark/start/shipmap/robot
	name = "Robot"

