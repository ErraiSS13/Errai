/obj/item/holosign_creator
	name = "holographic sign projector"
	desc = "A handy-dandy holographic projector that displays a janitorial sign."
	icon = 'icons/obj/items/holosign_projector.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	throw_speed = 3
	throw_range = 7
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = @'{"engineering":5,"exoticmatter":4,"powerstorage":4}'

	var/list/signs = list()
	var/max_signs = 10
	var/creation_time = 0 //time to create a holosign in deciseconds.
	var/holosign_type = /obj/structure/holosign
	var/holocreator_busy = FALSE //to prevent placing multiple holo barriers at once

/obj/item/holosign_creator/Destroy()
	for(var/sign in signs)
		qdel(sign)
	signs.Cut()
	. = ..()

/obj/item/holosign_creator/afterattack(atom/target, mob/user, flag)
	. = ..()
	if(flag)
		var/turf/T = get_turf(target)
		if(!T)
			return // Some objs qdel on attackby (notably, holosigns), which happens before this.
		var/obj/structure/holosign/H = locate(holosign_type) in T
		if(H)
			return
		else
			if(!is_blocked_turf(T, TRUE)) //can't put holograms on a tile that has dense stuff
				if(holocreator_busy)
					to_chat(user, "<span class='notice'>[src] is busy creating a hologram.</span>")
					return
				if(signs.len < max_signs)
					playsound(src.loc, 'sound/machines/click.ogg', 20, 1)
					if(creation_time)
						holocreator_busy = TRUE
						if(!do_after(user, creation_time, target = target))
							holocreator_busy = FALSE
							return
						holocreator_busy = FALSE
						if(signs.len >= max_signs)
							return
						if(is_blocked_turf(T, TRUE)) //don't try to sneak dense stuff on our tile during the wait.
							return
					H = new holosign_type(get_turf(target), src)
					to_chat(user, "<span class='notice'>You create \a [H] with [src].</span>")
				else
					to_chat(user, "<span class='notice'>[src] is projecting at max capacity!</span>")

/obj/item/holosign_creator/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	return FALSE

/obj/item/holosign_creator/attack_self(mob/user)
	if(signs.len)
		for(var/H in signs)
			qdel(H)
		to_chat(user, "<span class='notice'>You clear all active holograms.</span>")