/obj/structure/closet/crate/secure/loot
	name = "abandoned crate"
	desc = "What could be inside?"
	closet_appearance = /decl/closet_appearance/crate/secure
	var/list/code = list()
	var/list/lastattempt = list()
	var/attempts = 10
	var/codelen = 4
	locked = 1

/obj/structure/closet/crate/secure/loot/Initialize()
	. = ..()
	var/list/digits = list("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")

	for(var/i in 1 to codelen)
		code += pick(digits)
		digits -= code[code.len]

	generate_loot()

/obj/structure/closet/crate/secure/loot/proc/generate_loot()
	var/loot = rand(1, 100)
	switch(loot)
		if(1 to 5) // Common things go, 5%
			new /obj/item/chems/drinks/bottle/rum(src)
			new /obj/item/chems/drinks/bottle/whiskey(src)
			new /obj/item/food/grown/ambrosiadeus(src)
			new /obj/item/flame/fuelled/lighter/zippo(src)
		if(6 to 10)
			new /obj/item/tool/drill(src)
			new /obj/item/taperecorder(src)
			new /obj/item/clothing/suit/space(src)
			new /obj/item/clothing/head/helmet/space(src)
		if(11 to 15)
			new /obj/item/chems/glass/beaker/advanced(src)
		if(16 to 20)
			new /obj/item/stack/material/ore/diamond(src, 10)
		if(21 to 25)
			for(var/i = 0, i < 3, i++)
				new /obj/machinery/portable_atmospherics/hydroponics(src)
		if(26 to 30)
			for(var/i = 0, i < 3, i++)
				new /obj/item/chems/glass/beaker/noreact(src)
		if(31 to 35)
			var/obj/item/cash/cash = new(src)
			cash.adjust_worth(rand(300,800))
		if(36 to 40)
			new /obj/item/baton(src)
		if(41 to 45)
			new /obj/item/clothing/pants/shorts/athletic/red(src)
			new /obj/item/clothing/pants/shorts/athletic/blue(src)
		if(46 to 50)
			new/obj/item/clothing/jumpsuit/chameleon(src)
			for(var/i = 0, i < 7, i++)
				new /obj/item/clothing/neck/tie/horrible(src)
		if(51 to 52) // Uncommon, 2% each
			new /obj/item/classic_baton(src)
		if(53 to 54)
			new /obj/item/latexballon(src)
		if(55 to 56)
			var/newitem = pick(subtypesof(/obj/item/toy/prize))
			new newitem(src)
		if(57 to 58)
			new /obj/item/toy/balloon(src)
		if(59 to 60)
			new /obj/item/rig(src)
		if(61 to 62)
			for(var/i = 0, i < 12, ++i)
				new /obj/item/clothing/head/kitty(src)
		if(63 to 64)
			var/t = rand(4,7)
			for(var/i = 0, i < t, ++i)
				var/newcoin = pick(subtypesof(/obj/item/coin))
				new newcoin(src)
		if(65 to 66)
			new /obj/item/clothing/suit/ianshirt(src)
		if(67 to 68)
			var/t = rand(4,7)
			for(var/i = 0, i < t, ++i)
				var/newitem = pick(subtypesof(/obj/item/stock_parts) - /obj/item/stock_parts/subspace)
				new newitem(src)
		if(69 to 70)
			new /obj/item/tool/pickaxe/titanium(src)
		if(71 to 72)
			new /obj/item/tool/drill(src)
		if(73 to 74)
			new /obj/item/tool/hammer/jack(src)
		if(75 to 76)
			new /obj/item/tool/pickaxe/ocp(src)
		if(77 to 78)
			new /obj/item/tool/drill/diamond(src)
		if(79 to 80)
			new /obj/item/tool/pickaxe/plasteel(src)
		if(81 to 82)
			new /obj/item/gun/energy/plasmacutter(src)
		if(83 to 84)
			new /obj/item/sword/katana/toy(src)
		if(85 to 88)
			new /obj/item/seeds/random(src)
		if(89, 90)
			new /obj/item/organ/internal/heart(src)
		if(91,92)
			new /obj/item/sword/katana(src)
		if(93)
			new /obj/item/firstaid/combat(src) // Probably the least OP
		if(94) // Why the hell not
			new /obj/item/backpack/clown(src)
			new /obj/item/clothing/costume/clown(src)
			new /obj/item/clothing/shoes/clown_shoes(src)
			new /obj/item/clothing/mask/gas/clown_hat(src)
			new /obj/item/bikehorn(src)
			new /obj/item/pen/crayon/rainbow(src)
			new /obj/item/chems/spray/waterflower(src)
		if(95)
			new /obj/item/clothing/costume/mime(src)
			new /obj/item/clothing/shoes/color/black(src)
			new /obj/item/clothing/gloves(src)
			new /obj/item/clothing/mask/gas/mime(src)
			new /obj/item/clothing/head/beret(src)
			new /obj/item/clothing/suspenders(src)
			new /obj/item/pen/crayon/mime(src)
		if(96)
			new /obj/item/vampiric(src)
		if(97)
			new /obj/random/archaeological_find(src)
		if(98)
			new /obj/item/energy_blade/sword(src)
		if(99)
			new /obj/item/belt/champion(src)
			new /obj/item/clothing/mask/luchador(src)
		if(100)
			new /obj/item/clothing/head/bearpelt(src)

/obj/structure/closet/crate/secure/loot/togglelock(mob/user)
	if(!locked)
		return

	to_chat(user, "<span class='notice'>The crate is locked with a Deca-code lock.</span>")
	var/input = input(user, "Enter [codelen] digits.", "Deca-Code Lock", "") as text
	if(!Adjacent(user))
		return

	if(input == null || length(input) != codelen)
		to_chat(user, "<span class='notice'>You leave the crate alone.</span>")
	else if(check_input(input) && locked)
		to_chat(user, "<span class='notice'>The crate unlocks!</span>")
		playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
		..()
	else
		visible_message("<span class='warning'>A red light on \the [src]'s control panel flashes briefly.</span>")
		attempts--
		if (attempts == 0)
			to_chat(user, "<span class='danger'>The crate's anti-tamper system activates!</span>")
			var/turf/T = get_turf(src.loc)
			explosion(T, 0, 0, 1, 2)
			qdel(src)

/obj/structure/closet/crate/secure/loot/emag_act(var/remaining_charges, var/mob/user)
	if (locked)
		to_chat(user, "<span class='notice'>The crate unlocks!</span>")
		locked = 0

/obj/structure/closet/crate/secure/loot/proc/check_input(var/input)
	if(length(input) != codelen)
		return 0

	. = 1
	lastattempt.Cut()
	for(var/i in 1 to codelen)
		var/guesschar = copytext(input, i, i+1)
		lastattempt += guesschar
		if(guesschar != code[i])
			. = 0

/obj/structure/closet/crate/secure/loot/attackby(obj/item/used_item, mob/user)
	if(!locked || !IS_MULTITOOL(used_item))
		return ..()
	// Greetings Urist McProfessor, how about a nice game of cows and bulls?
	to_chat(user, "<span class='notice'>DECA-CODE LOCK ANALYSIS:</span>")
	if (attempts == 1)
		to_chat(user, "<span class='warning'>* Anti-Tamper system will activate on the next failed access attempt.</span>")
	else
		to_chat(user, "<span class='notice'>* Anti-Tamper system will activate after [src.attempts] failed access attempts.</span>")
	if(lastattempt.len)
		var/bulls = 0
		var/cows = 0

		var/list/code_contents = code.Copy()
		for(var/i in 1 to codelen)
			if(lastattempt[i] == code[i])
				++bulls
			else if(lastattempt[i] in code_contents)
				++cows
			code_contents -= lastattempt[i]
		to_chat(user, "<span class='notice'>Last code attempt had [bulls] correct digits at correct positions and [cows] correct digits at incorrect positions.</span>")
	return TRUE
