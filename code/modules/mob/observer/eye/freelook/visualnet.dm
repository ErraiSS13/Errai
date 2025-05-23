// VISUAL NET
//
// The datum containing all the chunks.
var/global/list/datum/visualnet/all_visual_nets = list()
/datum/visualnet
	// The chunks of the map, mapping the areas that an object can see.
	var/list/chunks = list()
	var/list/sources = list()
	var/chunk_type = /datum/chunk
	var/list/valid_source_types

/datum/visualnet/New()
	..()
	all_visual_nets += src
	if(!valid_source_types)
		valid_source_types = list()

/datum/visualnet/Destroy()
	all_visual_nets -= src
	for(var/source in sources)
		remove_source(source, FALSE)
	sources.Cut()
	for(var/chunk in chunks)
		var/chunk_datum = chunks[chunk]
		qdel(chunk_datum)
	chunks.Cut()
	. = ..()

// Checks if a chunk has been Generated in x, y, z.
/datum/visualnet/proc/is_chunk_generated(x, y, z)
	x &= ~0xf
	y &= ~0xf
	var/key = "[x],[y],[z]"
	return !isnull(chunks[key])

// Returns the chunk in the x, y, z.
// If there is no chunk, it creates a new chunk and returns that.
/datum/visualnet/proc/get_chunk(x, y, z)
	x &= ~0xf
	y &= ~0xf
	var/key = "[x],[y],[z]"
	if(!chunks[key])
		chunks[key] = new chunk_type(src, x, y, z)

	return chunks[key]

// Updates what the eye can see. It is recommended you use this when the eye moves or its location is set.

/datum/visualnet/proc/update_eye_chunks(mob/observer/eye/freelook/eye, var/full_update = FALSE)
	. = list()
	var/turf/T = get_turf(eye)
	if(T)
		// 0xf = 15
		var/x1 = max(0, T.x - 16) & ~0xf
		var/y1 = max(0, T.y - 16) & ~0xf
		var/x2 = min(world.maxx, T.x + 16) & ~0xf
		var/y2 = min(world.maxy, T.y + 16) & ~0xf

		for(var/x = x1; x <= x2; x += 16)
			for(var/y = y1; y <= y2; y += 16)
				. += get_chunk(x, y, T.z)

	if(full_update)
		eye.visibleChunks.Cut()

	var/list/remove = eye.visibleChunks - .
	var/list/add = . - eye.visibleChunks

	for(var/chunk in remove)
		var/datum/chunk/c = chunk
		c.remove_eye(eye)

	for(var/chunk in add)
		var/datum/chunk/c = chunk
		c.add_eye(eye)

/datum/visualnet/proc/remove_eye(mob/observer/eye/freelook/eye)
	for(var/chunk in eye.visibleChunks)
		var/datum/chunk/c = chunk
		c.remove_eye(eye)

// Updates the chunks that the turf is located in. Use this when obstacles are destroyed or	when doors open.

/datum/visualnet/proc/update_visibility(atom/A, var/opacity_check = TRUE)
	if((GAME_STATE < RUNLEVEL_GAME) || (opacity_check && !A.opacity))
		return
	major_chunk_change(A)

// Will check if an atom is on a viewable turf. Returns 1 if it is, otherwise returns 0.
/datum/visualnet/proc/is_visible(var/atom/target)
	// 0xf = 15
	var/turf/position = get_turf(target)
	return position && is_turf_visible(position)

/datum/visualnet/proc/is_turf_visible(var/turf/position)
	if(!position)
		return FALSE
	var/datum/chunk/chunk = get_chunk(position.x, position.y, position.z)
	if(chunk)
		if(chunk.dirty)
			chunk.update(TRUE) // Update now, no matter if it's visible or not.
		if(position in chunk.visibleTurfs)
			return TRUE
	return FALSE

// Never access this proc directly!!!!
// This will update the chunk and all the surrounding chunks.
/datum/visualnet/proc/major_chunk_change(var/atom/source)
	for_all_chunks_in_range(source, TYPE_PROC_REF(/datum/chunk, visibility_changed), list())

/datum/visualnet/proc/add_source(var/atom/source, var/update_visibility = TRUE, var/opacity_check = FALSE)
	if(!(source && is_valid_source(source)))
		log_visualnet("Was given an unhandled source", source)
		return FALSE
	if(source in sources)
		return FALSE
	sources += source
	events_repository.register(/decl/observ/moved, source, src, TYPE_PROC_REF(/datum/visualnet, source_moved))
	events_repository.register(/decl/observ/destroyed, source, src, TYPE_PROC_REF(/datum/visualnet, remove_source))
	for_all_chunks_in_range(source, TYPE_PROC_REF(/datum/chunk, add_source), list(source))
	if(update_visibility)
		update_visibility(source, opacity_check)
	return TRUE

/datum/visualnet/proc/remove_source(var/atom/source, var/update_visibility = TRUE, var/opacity_check = FALSE)
	if(!sources.Remove(source))
		return FALSE

	events_repository.unregister(/decl/observ/moved, source, src, TYPE_PROC_REF(/datum/visualnet, source_moved))
	events_repository.unregister(/decl/observ/destroyed, source, src, TYPE_PROC_REF(/datum/visualnet, remove_source))
	for_all_chunks_in_range(source, TYPE_PROC_REF(/datum/chunk, remove_source), list(source))
	if(update_visibility)
		update_visibility(source, opacity_check)
	return TRUE

/datum/visualnet/proc/is_valid_source(var/atom/source)
	if(is_type_in_list(source, valid_source_types))
		return TRUE

/datum/visualnet/proc/source_moved(var/atom/movable/source, var/old_loc, var/new_loc)
	var/turf/old_turf = get_turf(old_loc)
	var/turf/new_turf = get_turf(new_loc)

	if(old_turf == new_turf)
		return

	// A more proper way would be to figure out which chunks have gone out of range, and which have come into range
	//  and only remove/add to those.
	if(old_turf)
		for_all_chunks_in_range(source, TYPE_PROC_REF(/datum/chunk, remove_source), list(source), old_turf)
	if(new_turf)
		for_all_chunks_in_range(source, TYPE_PROC_REF(/datum/chunk, add_source), list(source), new_turf)

/datum/visualnet/proc/for_all_chunks_in_range(var/atom/source, var/proc_call, var/list/proc_args, var/turf/T)
	T = T ? T : get_turf(source)
	if(!T)
		return

	var/x1 = max(0, T.x - 8) & ~0xf
	var/y1 = max(0, T.y - 8) & ~0xf
	var/x2 = min(world.maxx, T.x + 8) & ~0xf
	var/y2 = min(world.maxy, T.y + 8) & ~0xf

	for(var/x = x1; x <= x2; x += 16)
		for(var/y = y1; y <= y2; y += 16)
			if(is_chunk_generated(x, y, T.z))
				var/datum/chunk/c = get_chunk(x, y, T.z)
				call(c, proc_call)(arglist(proc_args))

// Debug verb for VVing the chunk that the turf is in.
/turf/proc/view_chunk()
	set name = "View Chunk"
	set category = "Debug"
	set src in world

	if(cameranet.is_chunk_generated(x, y, z))
		var/datum/chunk/chunk = cameranet.get_chunk(x, y, z)
		usr.client.debug_variables(chunk)

/turf/proc/update_chunk()
	set name = "Update Chunk"
	set category = "Debug"
	set src in world

	if(cameranet.is_chunk_generated(x, y, z))
		var/datum/chunk/chunk = cameranet.get_chunk(x, y, z)
		chunk.visibility_changed(TRUE)
