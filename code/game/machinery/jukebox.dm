/obj/machinery/media/jukebox
	name = "mediatronic jukebox"
	desc = "An immense, standalone touchscreen on a swiveling base, equipped with phased array speakers. Embossed on one corner of the ultrathin bezel is the brand name, 'Leitmotif Enterprise Edition'."
	icon = 'icons/obj/jukebox_new.dmi'
	icon_state = "jukebox3-nopower"
	var/state_base = "jukebox3"
	anchored = TRUE
	density = TRUE
	power_channel = EQUIP
	idle_power_usage = 10
	active_power_usage = 100
	clicksound = 'sound/machines/buttonbeep.ogg'
	pixel_x = -8

	uncreated_component_parts = null
	stat_immune = 0
	construct_state = /decl/machine_construction/default/panel_closed

	var/playing = 0
	var/volume = 20

	var/sound_id
	var/datum/sound_token/sound_token

	var/datum/track/current_track
	var/list/datum/track/tracks


/obj/machinery/media/jukebox/old
	name = "space jukebox"
	desc = "A battered and hard-loved jukebox in some forgotten style, carefully restored to some semblance of working condition."
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox2-nopower"
	state_base = "jukebox2"
	pixel_x = 0

/obj/machinery/media/jukebox/Initialize()
	. = ..()
	tracks = setup_music_tracks(tracks)
	queue_icon_update()
	sound_id = "[/obj/machinery/media/jukebox]_[sequential_id(/obj/machinery/media/jukebox)]"

/obj/machinery/media/jukebox/Destroy()
	StopPlaying()
	QDEL_NULL_LIST(tracks)
	current_track = null
	. = ..()

/obj/machinery/media/jukebox/powered()
	return anchored && ..()

/obj/machinery/media/jukebox/power_change()
	. = ..()
	if(stat & (NOPOWER|BROKEN) && playing)
		StopPlaying()

/obj/machinery/media/jukebox/on_update_icon()
	overlays.Cut()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		if(stat & BROKEN)
			icon_state = "[state_base]-broken"
		else
			icon_state = "[state_base]-nopower"
		return
	icon_state = state_base
	if(playing)
		if(emagged)
			overlays += "[state_base]-emagged"
		else
			overlays += "[state_base]-running"

/obj/machinery/media/jukebox/CanUseTopic(user, state)
	if(!anchored)
		to_chat(user, "<span class='warning'>You must secure \the [src] first.</span>")
		return STATUS_CLOSE
	return ..()

/obj/machinery/media/jukebox/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/juke_tracks = new
	for(var/datum/track/T in tracks)
		juke_tracks.Add(list(list("track"=T.title)))

	var/list/data = list(
		"current_track" = current_track != null ? current_track.title : "No track selected",
		"playing" = playing,
		"tracks" = juke_tracks,
		"volume" = volume
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "jukebox.tmpl", "Your Media Library", 340, 440)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/media/jukebox/OnTopic(var/mob/user, var/list/href_list, state)
	if (href_list["title"])
		for(var/datum/track/T in tracks)
			if(T.title == href_list["title"])
				current_track = T
				StartPlaying()
				break
		return TOPIC_REFRESH

	if (href_list["stop"])
		StopPlaying()
		return TOPIC_REFRESH

	if (href_list["play"])
		if(emagged)
			emag_play()
		else if(!current_track)
			to_chat(user, "No track selected.")
		else
			StartPlaying()
		return TOPIC_REFRESH

	if (href_list["volume"])
		AdjustVolume(text2num(href_list["volume"]))
		return TOPIC_REFRESH

/obj/machinery/media/jukebox/proc/emag_play()
	playsound(loc, 'sound/items/AirHorn.ogg', 100, 1)
	for(var/mob/living/M in ohearers(6, src))
		if(ishuman(M))
			var/mob/living/human/H = M
			if(H.get_sound_volume_multiplier() < 0.2)
				continue
		M.set_status_condition(STAT_ASLEEP,    0)
		ADJ_STATUS(M, STAT_STUTTER,  20)
		SET_STATUS_MAX(M, STAT_DEAF, 30)
		SET_STATUS_MAX(M, STAT_WEAK,  3)
		if(prob(30))
			SET_STATUS_MAX(M, STAT_STUN, 10)
			SET_STATUS_MAX(M, STAT_PARA,  4)
		else
			M.set_status_condition(STAT_JITTER, 400)
	spawn(15)
		explode()

/obj/machinery/media/jukebox/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/media/jukebox/proc/explode()
	src.visible_message("<span class='danger'>\the [src] blows apart!</span>", 1)

	explosion(src.loc, 0, 0, 1, rand(1,2), 1)

	spark_at(src, cardinal_only = TRUE)

	new /obj/effect/decal/cleanable/blood/oil(src.loc)
	qdel(src)

/obj/machinery/media/jukebox/attackby(obj/item/used_item, mob/user)
	if((IS_WRENCH(used_item) || IS_HAMMER(used_item)) && !panel_open)
		add_fingerprint(user)
		wrench_floor_bolts(user, 0, used_item)
		power_change()
		return TRUE
	return ..()

/obj/machinery/media/jukebox/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		StopPlaying()
		visible_message("<span class='danger'>\The [src] makes a fizzling sound.</span>")
		update_icon()
		return 1

/obj/machinery/media/jukebox/proc/StopPlaying()
	playing = 0
	update_use_power(POWER_USE_IDLE)
	QDEL_NULL(sound_token)


/obj/machinery/media/jukebox/proc/StartPlaying()
	StopPlaying()
	if(!current_track)
		return

	// Jukeboxes cheat massively and actually don't share id. This is only done because it's music rather than ambient noise.
	sound_token = play_looping_sound(src, sound_id, current_track.GetTrack(), volume = volume, range = 7, falloff = 3, prefer_mute = TRUE, preference = /datum/client_preference/play_game_music, streaming = TRUE)

	playing = 1
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/media/jukebox/proc/AdjustVolume(var/new_volume)
	volume = clamp(new_volume, 0, 50)
	if(sound_token)
		sound_token.SetVolume(volume)
