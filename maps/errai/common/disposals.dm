// This should get upstreamed to Neb someday.

// A three-way junction that filters parcels from everything else. (Maint drones count as parcels)
/obj/structure/disposalpipe/sortjunction/parcel
	name = "parcel sorting junction"
	desc = "An underfloor disposal pipe which filters parcels, tagged or not, from everything else."
	flipped_state = /obj/structure/disposalpipe/sortjunction/parcel/flipped
	var/const/PARCEL_TAG = "PARCEL"

/obj/structure/disposalpipe/sortjunction/parcel/flipped
	icon_state = "pipe-j2s"
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	flipped_state = /obj/structure/disposalpipe/sortjunction/parcel

// This code is pretty bad but doing it the better way requires upstreaming to Neb first and passing more information into these kinds of functions.
/obj/structure/disposalpipe/sortjunction/parcel/divert_check(var/checkTag)
	return PARCEL_TAG == checkTag

// I cry
/obj/structure/disposalpipe/sortjunction/parcel/transfer(var/obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir, H.tomail ? PARCEL_TAG : H.destinationTag)
	to_world(H.tomail)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P


/datum/fabricator_recipe/pipe/disposal_dispenser/device/sorting/parcel
	name = "parcel disposal sorter"
	desc = "Sorts things in a disposal system"
	build_icon_state = "pipe-j1s"
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/parcel
	path = /obj/structure/disposalconstruct

/datum/fabricator_recipe/pipe/disposal_dispenser/device/sorting/parcelm
	name = "parcel disposal sorter (mirrored)"
	desc = "Sorts things in a disposal system"
	build_icon_state = "pipe-j2s"
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/parcel/flipped
	path = /obj/structure/disposalconstruct