//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/global/list/admin_verbs_default = list(
	/datum/admins/proc/show_player_panel,	//shows an interface for individual players, with various links (links require additional flags,
	/client/proc/secrets,
	/client/proc/deadmin_self,			//destroys our own admin datum so we can play as a regular player,
	/client/proc/hide_verbs,			//hides all our adminverbs,
	/client/proc/hide_most_verbs,		//hides all our hideable adminverbs,
	/client/proc/debug_variables,		//allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify,
	/client/proc/watched_variables,
	/client/proc/debug_global_variables,//as above but for global variables,
	/client/proc/cmd_check_new_players
	)
var/global/list/admin_verbs_admin = list(
	/client/proc/list_players,		//shows an interface for all players, with links to various panels,
	/client/proc/invisimin,				//allows our mob to go invisible/visible,
	/datum/admins/proc/show_game_mode,  //Configuration window for the current game mode.,
	/datum/admins/proc/force_mode_latespawn, //Force the mode to try a latespawn proc,
	/datum/admins/proc/force_antag_latespawn, //Force a specific template to try a latespawn proc,
	/datum/admins/proc/toggleenter,		//toggles whether people can join the current game,
	/datum/admins/proc/toggleguests,	//toggles whether guests can join the current game,
	/datum/admins/proc/announce,		//priority announce something to all clients.,
	/client/proc/colorooc,				//allows us to set a custom colour for everythign we say in ooc,
	/client/proc/admin_ghost,			//allows us to ghost/reenter body at will,
	/client/proc/toggle_view_range,		//changes how far we can see,
	/datum/admins/proc/view_txt_log,	//shows the server log (diary) for today,
	/client/proc/cmd_admin_pm_context,	//right-click adminPM interface,
	/client/proc/cmd_admin_pm_panel,	//admin-pm list,
	/client/proc/cmd_admin_delete,		//delete an instance/object/mob/etc,
	/client/proc/cmd_admin_check_contents,	//displays the contents of an instance,
	/datum/admins/proc/access_news_network,	//allows access of newscasters,
	/client/proc/giveserverlog,		//allows us to give access to runtime logs to somebody,
	/client/proc/getserverlog,			//allows us to fetch server logs (diary) for other days,
	/client/proc/jumptocoord,			//we ghost and jump to a coordinate,
	/client/proc/Getmob,				//teleports a mob to our location,
	/client/proc/Getkey,				//teleports a mob with a certain ckey to our location,
	/client/proc/Jump,
	/client/proc/jumptokey,				//allows us to jump to the location of a mob with a certain ckey,
	/client/proc/jumptomob,				//allows us to jump to a specific mob,
	/client/proc/jumptoturf,			//allows us to jump to a specific turf,
	/client/proc/admin_call_shuttle,	//allows us to call the emergency shuttle,
	/client/proc/admin_cancel_shuttle,	//allows us to cancel the emergency shuttle, sending it back to centcomm,
	/client/proc/cmd_admin_direct_narrate,	//send text directly to a player with no padding. Useful for narratives and fluff-text,
	/client/proc/cmd_admin_visible_narrate,
	/client/proc/cmd_admin_audible_narrate,
	/client/proc/cmd_admin_local_narrate,
	/client/proc/cmd_admin_world_narrate,	//sends text to all players with no padding,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/check_ai_laws,			//shows AI and borg laws,
	/client/proc/rename_silicon,		//properly renames silicons,
	/client/proc/manage_silicon_laws,	// Allows viewing and editing silicon laws. ,
	/client/proc/show_round_status,
	/client/proc/admin_memo,			//admin memo system. show/delete/write. +SERVER needed to delete admin memos of others,
	/client/proc/dsay,					//talk in deadchat using our ckey
//	/client/proc/toggle_hear_deadcast,	//toggles whether we hear deadchat,
	/client/proc/investigate_show,		//various admintools for investigation. Such as a singulo grief-log,
	/datum/admins/proc/toggleooc,		//toggles ooc on/off for everyone,
	/datum/admins/proc/toggleaooc,		//toggles aooc on/off for everyone,
	/datum/admins/proc/togglelooc,		//toggles looc on/off for everyone,
	/datum/admins/proc/toggleoocdead,	//toggles ooc on/off for everyone who is dead,
	/datum/admins/proc/toggledsay,		//toggles dsay on/off for everyone,
	/client/proc/game_panel,			//game panel, allows to change game-mode etc,
	/client/proc/cmd_admin_say,			//admin-only ooc chat,
	/datum/admins/proc/togglehubvisibility, //toggles visibility on the BYOND Hub,
	/datum/admins/proc/PlayerNotes,
	/client/proc/cmd_mod_say,
	/datum/admins/proc/show_player_info,
	/client/proc/free_slot_submap,
	/client/proc/free_slot_crew,			//frees slot for chosen job,
	/client/proc/cmd_admin_change_custom_event,
	/client/proc/cmd_admin_rejuvenate,
	/client/proc/toggleghostwriters,
	/client/proc/toggledrones,
	/datum/admins/proc/show_skills,
	/client/proc/man_up,
	/client/proc/global_man_up,
	/client/proc/response_team, // Response Teams admin verb,
	/client/proc/toggle_antagHUD_use,
	/client/proc/toggle_antagHUD_restrictions,
	/client/proc/allow_character_respawn,    // Allows a ghost to respawn ,
	/client/proc/event_manager_panel,
	/client/proc/empty_ai_core_toggle_latejoin,
	/client/proc/empty_ai_core_toggle_latejoin,
	/client/proc/aooc,
	/client/proc/change_human_appearance_admin,	// Allows an admin to change the basic appearance of human-based mobs ,
	/client/proc/change_human_appearance_self,	// Allows the human-based mob itself change its basic appearance ,
	/client/proc/change_security_level,
	/client/proc/makePAI,
	/client/proc/fixatmos,
	/client/proc/list_traders,
	/client/proc/add_trader,
	/client/proc/remove_trader,
	/datum/admins/proc/sendFax,
	/datum/admins/proc/show_traits
)
var/global/list/admin_verbs_ban = list(
	/client/proc/DB_ban_panel,
	/client/proc/unban_panel,
	/client/proc/jobbans
	)
var/global/list/admin_verbs_sounds = list(
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/play_server_sound
	)

var/global/list/admin_verbs_fun = list(
	/client/proc/change_lobby_screen,
	/client/proc/object_talk,
	/datum/admins/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/everyone_random,
	/client/proc/cinematic,
	/datum/admins/proc/toggle_aliens,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/toggle_random_events,
	/client/proc/editappear,
	/client/proc/roll_dices,
	/datum/admins/proc/call_supply_drop,
	/datum/admins/proc/call_drop_pod,
	/client/proc/create_dungeon,
	/datum/admins/proc/ai_hologram_set
	)

var/global/list/admin_verbs_spawn = list(
	/datum/admins/proc/spawn_fruit,
	/datum/admins/proc/spawn_fluid_verb,
	/datum/admins/proc/spawn_custom_item,
	/datum/admins/proc/check_custom_items,
	/datum/admins/proc/spawn_plant,
	/datum/admins/proc/spawn_atom,		// allows us to spawn instances,
	/client/proc/respawn_character,
	/client/proc/respawn_as_self,
	/client/proc/spawn_chemdisp_cartridge,
	/datum/admins/proc/mass_debug_closet_icons
	)
var/global/list/admin_verbs_server = list(
	/datum/admins/proc/capture_map_part,
	/client/proc/set_holiday,
	/datum/admins/proc/startnow,
	/datum/admins/proc/endnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/toggle_log_hrefs,
	/datum/admins/proc/immreboot,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/cmd_admin_delete,		// delete an instance/object/mob/etc,
	/client/proc/cmd_debug_del_all,
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/adjump,
	/datum/admins/proc/toggle_aliens,
	/client/proc/toggle_random_events,
	/client/proc/nanomapgen_DumpImage,
	/datum/admins/proc/addserverwhitelist,
	/datum/admins/proc/removeserverwhitelist,
	/datum/admins/proc/panicbunker,
	/datum/admins/proc/addbunkerbypass,
	/datum/admins/proc/revokebunkerbypass
	)
var/global/list/admin_verbs_debug = list(
	/datum/admins/proc/jump_to_fluid_source,
	/datum/admins/proc/jump_to_fluid_active,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/ZASSettings,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/debug_controller,
	/client/proc/debug_antagonist_template,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_debug_tog_aliens,
	/client/proc/air_report,
	/client/proc/reload_admins,
	/client/proc/reload_secrets,
	/client/proc/restart_controller,
	/client/proc/print_random_map,
	/client/proc/create_random_map,
	/client/proc/apply_random_map,
	/client/proc/overlay_random_map,
	/client/proc/delete_random_map,
	/datum/admins/proc/map_template_load,
	/datum/admins/proc/map_template_load_new_z,
	/datum/admins/proc/map_template_upload,
	/client/proc/enable_debug_verbs,
	/client/proc/callproc,
	/client/proc/callproc_target,
	/client/proc/SDQL_query,
	/client/proc/SDQL2_query,
	/client/proc/Jump,
	/client/proc/jumptomob,
	/client/proc/jumptocoord,
	/client/proc/dsay,
	/datum/admins/proc/run_unit_test,
	/turf/proc/view_chunk,
	/turf/proc/update_chunk,
	/datum/admins/proc/capture_map,
	/datum/admins/proc/view_runtimes,
	/client/proc/cmd_analyse_health_context,
	/client/proc/cmd_analyse_health_panel,
	/client/proc/visualpower,
	/client/proc/visualpower_remove,
	/client/proc/ping_webhook,
	/client/proc/reload_webhooks,
	/datum/admins/proc/check_unconverted_single_icon_items,
	/client/proc/spawn_material,
	/client/proc/verb_adjust_tank_bomb_severity,
	/client/proc/force_ghost_trap_trigger,
	/client/proc/spawn_quantum_mechanic,
	/client/proc/spawn_exoplanet,
	/client/proc/print_cargo_prices,
	/client/proc/resend_nanoui_templates,
	/client/proc/display_del_log,
	/client/proc/spawn_ore_pile,
	/datum/admins/proc/force_initialize_weather,
	/datum/admins/proc/force_weather_state,
	/datum/admins/proc/force_kill_weather,
	/client/proc/force_reload_theme_css,
	/client/proc/toggle_browser_inspect,
	)

var/global/list/admin_verbs_paranoid_debug = list(
	/client/proc/callproc,
	/client/proc/callproc_target,
	/client/proc/debug_controller
	)

var/global/list/admin_verbs_possess = list(
	/proc/possess,
	/proc/release
	)
var/global/list/admin_verbs_permissions = list(
	/client/proc/edit_admin_permissions
	)
var/global/list/admin_verbs_rejuv = list(
	/client/proc/respawn_character
	)

//verbs which can be hidden - needs work
var/global/list/admin_verbs_hideable = list(
	/client/proc/deadmin_self,
//	/client/proc/deadchat,
	/datum/admins/proc/show_special_roles,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/toggleguests,
	/datum/admins/proc/announce,
	/client/proc/colorooc,
	/client/proc/admin_ghost,
	/client/proc/toggle_view_range,
	/datum/admins/proc/view_txt_log,
	/client/proc/cmd_admin_check_contents,
	/datum/admins/proc/access_news_network,
	/client/proc/admin_call_shuttle,
	/client/proc/admin_cancel_shuttle,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_visible_narrate,
	/client/proc/cmd_admin_audible_narrate,
	/client/proc/cmd_admin_local_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/play_server_sound,
	/client/proc/object_talk,
	/datum/admins/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/cinematic,
	/datum/admins/proc/toggle_aliens,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/toggle_random_events,
	/client/proc/set_holiday,
	/datum/admins/proc/startnow,
	/datum/admins/proc/endnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/toggle_log_hrefs,
	/datum/admins/proc/immreboot,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/adjump,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/callproc,
	/client/proc/callproc_target,
	/client/proc/reload_admins,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/debug_controller,
	/client/proc/startSinglo,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_debug_tog_aliens,
	/client/proc/air_report,
	/client/proc/enable_debug_verbs,
	/client/proc/roll_dices,
	/proc/possess,
	/proc/release,
	/datum/admins/proc/panicbunker,
	/datum/admins/proc/addbunkerbypass,
	/datum/admins/proc/revokebunkerbypass,
	/client/proc/spawn_quantum_mechanic,
	/client/proc/respawn_as_self
	)
var/global/list/admin_verbs_mod = list(
	/client/proc/cmd_admin_pm_context,	// right-click adminPM interface,
	/client/proc/cmd_admin_pm_panel,	// admin-pm list,
	/client/proc/debug_variables,		// allows us to -see- the variables of any instance in the game.,
	/client/proc/watched_variables,
	/client/proc/debug_global_variables,// as above but for global variables,
	/datum/admins/proc/PlayerNotes,
	/client/proc/admin_ghost,			// allows us to ghost/reenter body at will,
	/client/proc/cmd_mod_say,
	/datum/admins/proc/show_player_info,
	/client/proc/list_players,
	/client/proc/dsay,
	/datum/admins/proc/show_skills,
	/datum/admins/proc/show_player_panel,
	/client/proc/show_round_status,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/aooc,
	/datum/admins/proc/sendFax,
	/datum/admins/proc/paralyze_mob,
	/datum/admins/proc/view_persistent_data,
	/datum/admins/proc/dump_configuration,
	/datum/admins/proc/dump_character_info_manifest
)

/client/proc/add_admin_verbs()
	if(holder)
		verbs += admin_verbs_default
		if(holder.rights & R_BUILDMODE)		verbs += /client/proc/togglebuildmodeself
		if(holder.rights & R_ADMIN)			verbs += admin_verbs_admin
		if(holder.rights & R_BAN)			verbs += admin_verbs_ban
		if(holder.rights & R_FUN)			verbs += admin_verbs_fun
		if(holder.rights & R_SERVER)		verbs += admin_verbs_server
		if(holder.rights & R_DEBUG)
			verbs += admin_verbs_debug
			if(get_config_value(/decl/config/toggle/paranoid) && !(holder.rights & R_ADMIN))
				verbs.Remove(admin_verbs_paranoid_debug)			//Right now it's just callproc but we can easily add others later on.
		if(holder.rights & R_POSSESS)		verbs += admin_verbs_possess
		if(holder.rights & R_PERMISSIONS)	verbs += admin_verbs_permissions
		if(holder.rights & R_STEALTH)		verbs += /client/proc/stealth
		if(holder.rights & R_REJUVENATE)	verbs += admin_verbs_rejuv
		if(holder.rights & R_SOUNDS)		verbs += admin_verbs_sounds
		if(holder.rights & R_SPAWN)			verbs += admin_verbs_spawn
		if(holder.rights & R_MOD)			verbs += admin_verbs_mod

/client/proc/remove_admin_verbs()
	verbs.Remove(
		admin_verbs_default,
		/client/proc/togglebuildmodeself,
		admin_verbs_admin,
		admin_verbs_ban,
		admin_verbs_fun,
		admin_verbs_server,
		admin_verbs_debug,
		admin_verbs_possess,
		admin_verbs_permissions,
		/client/proc/stealth,
		admin_verbs_rejuv,
		admin_verbs_sounds,
		admin_verbs_spawn,
		debug_verbs
		)

/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Most"
	set category = "Admin"

	verbs.Remove(/client/proc/hide_most_verbs, admin_verbs_hideable)
	verbs += /client/proc/show_verbs

	to_chat(src, "<span class='interface'>Most of your adminverbs have been hidden.</span>")
	SSstatistics.add_field_details("admin_verb","HMV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin"

	remove_admin_verbs()
	verbs += /client/proc/show_verbs

	to_chat(src, "<span class='interface'>Almost all of your adminverbs have been hidden.</span>")
	SSstatistics.add_field_details("admin_verb","TAVVH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin"

	verbs -= /client/proc/show_verbs
	add_admin_verbs()

	to_chat(src, "<span class='interface'>All of your adminverbs are now visible.</span>")
	SSstatistics.add_field_details("admin_verb","TAVVS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!





/client/proc/admin_ghost()
	set category = "Admin"
	set name = "Aghost"
	if(!holder)	return
	if(isghost(mob))
		var/mob/observer/ghost/ghost = mob
		ghost.reenter_corpse()
		SSstatistics.add_field_details("admin_verb","P") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	else if(isnewplayer(mob))
		to_chat(src, SPAN_WARNING("Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first."))
	else
		//ghostize
		var/mob/body = mob
		var/mob/observer/ghost/ghost = body.ghostize()
		ghost.admin_ghosted = 1
		if(body)
			body.teleop = ghost
			if(!body.key)
				body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		SSstatistics.add_field_details("admin_verb","O") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Admin"
	set desc = "Toggles ghost-like invisibility (Don't abuse this)"
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.set_invisibility(initial(mob.invisibility))
			to_chat(mob, "<span class='danger'>Invisimin off. Invisibility reset.</span>")
			mob.alpha = max(mob.alpha + 100, 255)
		else
			mob.set_invisibility(INVISIBILITY_OBSERVER)
			to_chat(mob, "<span class='notice'>Invisimin on. You are now as invisible as a ghost.</span>")
			mob.alpha = max(mob.alpha - 100, 0)

/client/proc/list_players()
	set name = "List Players"
	set category = "Admin"
	if(holder)
		holder.list_players()
	SSstatistics.add_field_details("admin_verb","PPN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/show_round_status()
	set name = "Check Round Status"
	set category = "Admin"
	if(holder)
		holder.show_round_status()
		log_admin("[key_name(usr)] checked round status.")	//for tsar~
	SSstatistics.add_field_details("admin_verb","CHA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/jobbans()
	set name = "Display Job bans"
	set category = "Admin"
	if(holder)
		if(get_config_value(/decl/config/toggle/on/ban_legacy_system))
			holder.Jobbans()
		else
			holder.DB_ban_panel()
	SSstatistics.add_field_details("admin_verb","VJB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin"
	if(holder)
		if(get_config_value(/decl/config/toggle/on/ban_legacy_system))
			holder.unbanpanel()
		else
			holder.DB_ban_panel()
	SSstatistics.add_field_details("admin_verb","UBP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if(holder)
		holder.Game()
	SSstatistics.add_field_details("admin_verb","GP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (holder)
		holder.Secrets()
	SSstatistics.add_field_details("admin_verb","S") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/colorooc()
	set category = "Fun"
	set name = "OOC Text Color"
	if(!holder)	return
	var/response = alert(src, "Please choose a distinct color that is easy to read and doesn't mix with all the other chat and radio frequency colors.", "Change own OOC color", "Pick new color", "Reset to default", "Cancel")
	if(response == "Pick new color")
		prefs.ooccolor = input(src, "Please select your OOC colour.", "OOC colour") as color
	else if(response == "Reset to default")
		prefs.ooccolor = initial(prefs.ooccolor)
	SScharacter_setup.queue_preferences_save(prefs)

	SSstatistics.add_field_details("admin_verb","OC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

#define MAX_WARNS 3
#define AUTOBANTIME 10

/client/proc/warn(warned_ckey)
	if(!check_rights(R_ADMIN))	return

	if(!warned_ckey || !istext(warned_ckey))	return
	if(warned_ckey in admin_datums)
		to_chat(usr, SPAN_WARNING("Error: warn(): You can't warn admins."))
		return

	var/datum/preferences/D
	var/client/C = global.ckey_directory[warned_ckey]
	if(C)
		D = C.prefs
	else
		D = SScharacter_setup.preferences_datums[warned_ckey]

	if(!D)
		to_chat(src, SPAN_WARNING("Error: warn(): No such ckey found."))
		return

	if(++D.warns >= MAX_WARNS)					//uh ohhhh...you'reee iiiiin trouuuubble O:)
		var/mins_readable = minutes_to_readable(AUTOBANTIME)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a [mins_readable] autoban.")
		if(C)
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)] resulting in a [mins_readable] ban.")
			to_chat(C, SPAN_RED("<BIG><B>You have been autobanned due to a warning by [ckey].</B></BIG><br>This is a temporary ban, it will be removed in [mins_readable]."))
			qdel(C)
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] resulting in a [mins_readable] ban.")
		AddBan(warned_ckey, D.last_id, "Autobanning due to too many formal warnings", ckey, 1, AUTOBANTIME)
		SSstatistics.add_field("ban_warn",1)
	else
		if(C)
			to_chat(C, SPAN_RED("<BIG><B>You have been formally warned by an administrator.</B></BIG><br>Further warnings will result in an autoban."))
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)]. They have [MAX_WARNS-D.warns] strikes remaining.")
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [MAX_WARNS-D.warns] strikes remaining.")

	SSstatistics.add_field_details("admin_verb","WARN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

#undef MAX_WARNS
#undef AUTOBANTIME

/client/proc/drop_bomb() // Some admin dickery that can probably be done better -- TLE
	set category = "Special Verbs"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/turf/epicenter = mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce?") in choices
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)

		if("Custom Bomb")
			if(get_config_value(/decl/config/toggle/use_iterative_explosions))
				var/power = input(src, "Input power num.", "Power?") as num
				explosion_iter(get_turf(mob), power, (UP|DOWN))
			else
				var/devastation_range = input("Devastation range (in tiles):") as num
				var/heavy_impact_range = input("Heavy impact range (in tiles):") as num
				var/light_impact_range = input("Light impact range (in tiles):") as num
				var/flash_range = input("Flash range (in tiles):") as num
				explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)

	log_and_message_admins("created an admin explosion at [epicenter.loc].")
	SSstatistics.add_field_details("admin_verb","DB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"

	if(!check_rights(R_ADMIN))
		return

	if(!usr.RemoveClickHandler(/datum/click_handler/build_mode))
		usr.PushClickHandler(/datum/click_handler/build_mode)
	SSstatistics.add_field_details("admin_verb","TBMS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/object_talk(var/msg as text) // -- TLE
	set category = "Special Verbs"
	set name = "oSay"
	set desc = "Display a message to everyone who can hear the target"

	msg = sanitize(msg)

	if(mob.control_object)
		if(!msg)
			return
		mob.control_object.audible_message("<b>[mob.control_object]</b> says, \"[msg]\"")
	SSstatistics.add_field_details("admin_verb","OT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/readmin_self()
	set name = "Re-Admin self"
	set category = "Admin"

	if(deadmin_holder)
		deadmin_holder.reassociate()
		log_admin("[src] re-admined themself.")
		message_admins("[src] re-admined themself.", 1)
		to_chat(src, "<span class='interface'>You now have the keys to control the planet, or at least [global.using_map.full_name].</span>")
		verbs -= /client/proc/readmin_self

/client/proc/deadmin_self()
	set name = "De-admin self"
	set category = "Admin"

	if(holder)
		if(alert("Confirm self-deadmin for the round? You can re-admin yourself at any time.",,"Yes","No") == "Yes")
			log_admin("[src] deadmined themself.")
			message_admins("[src] deadmined themself.", 1)
			deadmin()
			to_chat(src, "<span class='interface'>You are now a normal player.</span>")
			verbs |= /client/proc/readmin_self
	SSstatistics.add_field_details("admin_verb","DAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_log_hrefs()
	set name = "Toggle href logging"
	set category = "Server"
	if(!holder)	return
	if(toggle_config_value(/decl/config/toggle/log_hrefs))
		to_chat(src, "<b>Started logging hrefs</b>")
	else
		to_chat(src, "<b>Stopped logging hrefs</b>")

/client/proc/check_ai_laws()
	set name = "Check AI Laws"
	set category = "Admin"
	if(holder)
		src.holder.output_ai_laws()

/client/proc/rename_silicon()
	set name = "Rename Silicon"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/mob/living/silicon/S = input("Select silicon.", "Rename Silicon.") as null|anything in global.silicon_mob_list
	if(!S) return

	var/new_name = sanitize_safe(input(src, "Enter new name. Leave blank or as is to cancel.", "[S.real_name] - Enter new silicon name", S.real_name))
	if(new_name && new_name != S.real_name)
		log_and_message_admins("has renamed the silicon '[S.real_name]' to '[new_name]'")
		S.fully_replace_character_name(new_name)
	SSstatistics.add_field_details("admin_verb","RAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/manage_silicon_laws()
	set name = "Manage Silicon Laws"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/mob/living/silicon/S = input("Select silicon.", "Manage Silicon Laws") as null|anything in global.silicon_mob_list
	if(!S) return

	var/datum/nano_module/law_manager/L = new(S)
	L.ui_interact(usr, state = global.admin_topic_state)
	log_and_message_admins("has opened [S]'s law manager.")
	SSstatistics.add_field_details("admin_verb","MSL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/change_human_appearance_admin()
	set name = "Change Mob Appearance - Admin"
	set desc = "Allows you to change the mob appearance"
	set category = "Admin"

	if(!check_rights(R_FUN)) return

	var/mob/living/human/H = input("Select mob.", "Change Mob Appearance - Admin") as null|anything in global.human_mob_list
	if(!H) return

	log_and_message_admins("is altering the appearance of [H].")
	H.change_appearance(APPEARANCE_ALL, usr, usr, check_species_whitelist = 0, state = global.admin_topic_state)
	SSstatistics.add_field_details("admin_verb","CHAA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/change_human_appearance_self()
	set name = "Change Mob Appearance - Self"
	set desc = "Allows the mob to change its appearance"
	set category = "Admin"

	if(!check_rights(R_FUN)) return

	var/mob/living/human/H = input("Select mob.", "Change Mob Appearance - Self") as null|anything in global.human_mob_list
	if(!H) return

	if(!H.client)
		to_chat(usr, "Only mobs with clients can alter their own appearance.")
		return

	var/whitelist_check = alert("Do you wish for [H] to be allowed to select non-whitelisted races?","Alter Mob Appearance","Yes","No","Cancel") == "No"
	var/decl/pronouns/pronouns = H.get_pronouns(ignore_coverings = TRUE)
	log_and_message_admins("has allowed [H] to change [pronouns.his] appearance, [whitelist_check ? "excluding" : "including"] races that requires whitelisting.")
	H.change_appearance(APPEARANCE_ALL, H.loc, check_species_whitelist = whitelist_check)
	SSstatistics.add_field_details("admin_verb","CMAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/change_security_level()
	set name = "Set security level"
	set desc = "Sets the security level"
	set category = "Admin"

	if(!check_rights(R_ADMIN))	return

	var/decl/security_state/security_state = GET_DECL(global.using_map.security_state)

	var/decl/security_level/new_security_level = input(usr, "It's currently [security_state.current_security_level.name].", "Select Security Level")  as null|anything in (security_state.all_security_levels - security_state.current_security_level)
	if(!new_security_level)
		return

	if(alert("Switch from [security_state.current_security_level.name] to [new_security_level.name]?","Change security level?","Yes","No") == "Yes")
		security_state.set_security_level(new_security_level, TRUE)


//---- bs12 verbs ----
/client/proc/editappear()
	set name = "Edit Appearance"
	set category = "Fun"

	if(!check_rights(R_FUN))	return

	var/mob/living/human/M = input("Select mob.", "Edit Appearance") as null|anything in global.human_mob_list

	if(!ishuman(M))
		to_chat(usr, "<span class='warning'>You can only do this to humans!</span>")
		return
	switch(alert("Are you sure you wish to edit this mob's appearance? This can result in unintended consequences.",,"Yes","No"))
		if("No")
			return

	var/update_hair = FALSE
	var/new_facial = input("Please select facial hair color.", "Character Generation") as color
	if(new_facial)
		SET_FACIAL_HAIR_COLOR(M, new_facial, TRUE)
		update_hair = TRUE

	var/new_hair = input("Please select hair color.", "Character Generation") as color
	if(new_hair)
		SET_HAIR_COLOR(M, new_hair, TRUE)
		update_hair = TRUE

	var/new_eyes = input("Please select eye color.", "Character Generation") as color
	if(new_eyes)
		M.set_eye_colour(new_eyes)

	var/new_skin = input("Please select body color.", "Character Generation") as color
	if(new_skin)
		M.set_skin_colour(new_skin, skip_update = TRUE)

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as text

	if (new_tone)
		M.skin_tone = max(min(round(text2num(new_tone)), 220), 1)
		M.skin_tone =  -M.skin_tone + 35

	// hair
	var/new_hairstyle = input(usr, "Select a hair style", "Grooming") as null|anything in decls_repository.get_decl_paths_of_subtype(/decl/sprite_accessory/hair)
	if(new_hairstyle)
		SET_HAIR_STYLE(M, new_hairstyle, TRUE)
		update_hair = TRUE

	// facial hair
	var/new_fstyle = input(usr, "Select a facial hair style", "Grooming")  as null|anything in decls_repository.get_decl_paths_of_subtype(/decl/sprite_accessory/facial_hair)
	if(new_fstyle)
		SET_FACIAL_HAIR_STYLE(M, new_fstyle, TRUE)
		update_hair = TRUE

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female", "Neuter")
	if (new_gender)
		if(new_gender == "Male")
			M.set_gender(MALE)
		else if (new_gender == "Female")
			M.set_gender(FEMALE)
		else
			M.set_gender(NEUTER)

	if(update_hair)
		M.update_hair(TRUE)
	M.update_body()

/client/proc/free_slot_submap()
	set name = "Free Job Slot (Submap)"
	set category = "Admin"
	if(!holder) return

	var/list/jobs = list()
	for(var/thing in SSmapping.submaps)
		var/datum/submap/submap = thing
		for(var/otherthing in submap.jobs)
			var/datum/job/submap/job = submap.jobs[otherthing]
			if(!job.is_position_available())
				jobs["[job.title] - [submap.name]"] = job

	if(!LAZYLEN(jobs))
		to_chat(usr, "There are no fully staffed offsite jobs.")
		return

	var/job_name = input("Please select job slot to free", "Free job slot")  as null|anything in jobs
	if(job_name)
		var/datum/job/submap/job = jobs[job_name]
		if(istype(job) && !job.is_position_available())
			job.make_position_available()
			message_admins("An offsite job slot for [job_name] has been opened by [key_name_admin(usr)]")

/client/proc/free_slot_crew()
	set name = "Free Job Slot (Crew)"
	set category = "Admin"
	if(holder)
		var/list/jobs = list()
		for (var/datum/job/J in SSjobs.primary_job_datums)
			if(!J.is_position_available())
				jobs[J.title] = J
		if (!jobs.len)
			to_chat(usr, "There are no fully staffed jobs.")
			return
		var/job_title = input("Please select job slot to free", "Free job slot")  as null|anything in jobs
		var/datum/job/job = jobs[job_title]
		if(job && !job.is_position_available())
			job.make_position_available()
			message_admins("A job slot for [job_title] has been opened by [key_name_admin(usr)]")
			return

/client/proc/toggleghostwriters()
	set name = "Toggle ghost writers"
	set category = "Server"
	if(!holder)
		return
	if(toggle_config_value(/decl/config/toggle/on/cult_ghostwriter))
		to_chat(src, "<b>Enabled ghost writers.</b>")
		message_admins("Admin [key_name_admin(usr)] has enabled ghost writers.", 1)
	else
		to_chat(src, "<b>Disallowed ghost writers.</b>")
		message_admins("Admin [key_name_admin(usr)] has disabled ghost writers.", 1)

/client/proc/toggledrones()
	set name = "Toggle maintenance drones"
	set category = "Server"
	if(!holder)	return
	if(toggle_config_value(/decl/config/toggle/on/allow_drone_spawn))
		to_chat(src, "<b>Enabled maint drones.</b>")
		message_admins("Admin [key_name_admin(usr)] has enabled maint drones.", 1)
	else
		to_chat(src, "<b>Disallowed maint drones.</b>")
		message_admins("Admin [key_name_admin(usr)] has disabled maint drones.", 1)

/client/proc/man_up(mob/T as mob in SSmobs.mob_list)
	set category = "Fun"
	set name = "Man Up"
	set desc = "Tells mob to man up and deal with it."

	to_chat(T, "<span class='notice'><b><font size=3>Man up and deal with it.</font></b></span>")
	to_chat(T, "<span class='notice'>Move on.</span>")

	log_and_message_admins("told [key_name(T)] to man up and deal with it.")

/client/proc/global_man_up()
	set category = "Fun"
	set name = "Man Up Global"
	set desc = "Tells everyone to man up and deal with it."

	for (var/mob/T as mob in SSmobs.mob_list)
		to_chat(T, "<br><center><span class='notice'><b><font size=4>Man up.<br> Deal with it.</font></b><br>Move on.</span></center><br>")
		sound_to(T, 'sound/voice/ManUp1.ogg')

	log_and_message_admins("told everyone to man up and deal with it.")

/client/proc/change_lobby_screen()
	set name = "Lobby Screen: Change"
	set category = "Fun"

	if(!check_rights(R_FUN))
		return

	log_and_message_admins("is trying to change the title screen.")
	SSstatistics.add_field_details("admin_verb", "LSC")

	switch(alert(usr, "Select option", "Lobby Screen", "Upload custom", "Reset to default", "Cancel"))
		if("Upload custom")
			var/file = input(usr) as icon|null

			if(!file)
				return

			global.using_map.update_titlescreen(file)

		if("Reset to default")
			global.using_map.update_titlescreen()

		if("Cancel")
			return

/client/proc/force_reload_theme_css()
	set category = "Debug"
	set name     = "Reload UI Theme CSS"
	set desc     = "Forces the client to reload its UI theme css file."
	if(!check_rights(R_DEBUG))
		return
	ReloadThemeCss(src)
