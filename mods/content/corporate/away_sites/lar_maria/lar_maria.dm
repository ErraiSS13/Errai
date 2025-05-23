#include "../../_corporate.dme"
#include "lar_maria_areas.dm"

/obj/effect/overmap/visitable/sector/lar_maria
	name = "Lar Maria space station"
	desc = "Sensors detect an orbital station with low energy profile and sporadic life signs."
	icon_state = "object"
	initial_generic_waypoints = list(
		"nav_lar_maria_docking"
	)

/datum/map_template/ruin/away_site/lar_maria
	name = "Lar Maria"
	description = "An orbital virus research station."
	prefix = "mods/content/corporate/away_sites/"
	suffixes = list("lar_maria/lar_maria-1.dmm", "lar_maria/lar_maria-2.dmm")
	cost = 2
	area_usage_test_exempted_root_areas = list(/area/lar_maria)

/obj/effect/shuttle_landmark/lar_maria_docking
	name = "docking port"
	landmark_tag = "nav_lar_maria_docking"
	flags = SLANDMARK_FLAG_REORIENT | SLANDMARK_FLAG_AUTOSET

///////////////////////////////////crew and prisoners
/obj/abstract/landmark/corpse/lar_maria
	eye_colors_per_species = list(/decl/species/human::uid = list(COLOR_RED))//red eyes
	skin_tones_per_species = list(/decl/species/human::uid = list(-15))
	facial_styles_per_species = list(/decl/species/human::uid = list(/decl/sprite_accessory/facial_hair/shaved))
	genders_per_species = list(/decl/species/human::uid = list(MALE))

/mob/living/simple_animal/hostile/lar_maria
	name = "Lar Maria hostile mob"
	desc = "You shouldn't see me!"
	icon = 'mods/content/corporate/away_sites/lar_maria/lar_maria_guard_light.dmi'
	unsuitable_atmos_damage = 15
	environment_smash = 1
	faction = "lar_maria"
	status_flags = CANPUSH
	base_movement_delay = 2
	natural_weapon = /obj/item/natural_weapon/punch
	ai = /datum/mob_controller/aggressive/lar_maria

	var/obj/abstract/landmark/corpse/lar_maria/corpse = null
	var/weapon = null

/datum/mob_controller/aggressive/lar_maria
	emote_speech = list("Die!", "Fresh meat!", "Hurr!", "You said help will come!", "I did nothing!", "Eat my fist!", "One for the road!")
	speak_chance = 12.5
	emote_hear   = list("roars", "giggles", "breathes loudly", "mumbles", "yells something unintelligible")
	emote_see    = list("cries", "grins insanely", "itches fiercly", "scratches his face", "shakes his fists above his head")
	turns_per_wander = 10
	stop_wander_when_pulled = 0
	can_escape_buckles = TRUE

/mob/living/simple_animal/hostile/lar_maria/death(gibbed)
	. = ..()
	if(. && !gibbed)
		if(corpse)
			new corpse (src.loc)
		if (weapon)
			new weapon(src.loc)
		visible_message(SPAN_WARNING("Small shining spores float away from the dying [name]!"))
		qdel(src)

/mob/living/simple_animal/hostile/lar_maria/test_subject
	name = "test subject"
	desc = "Sick, filthy, angry and probably crazy human in an orange robe."
	max_health = 40
	corpse = /obj/abstract/landmark/corpse/lar_maria/test_subject
	icon = 'mods/content/corporate/away_sites/lar_maria/lar_maria_test_subject.dmi'

/obj/abstract/landmark/corpse/lar_maria/test_subject
	name = "dead test subject"
	corpse_outfits = list(/decl/outfit/corpse/test_subject)
	spawn_flags = CORPSE_SPAWNER_NO_RANDOMIZATION//no name, no hairs etc.

/decl/outfit/corpse/test_subject
	name = "dead ZHP test subject"
	uniform = /obj/item/clothing/jumpsuit/orange
	shoes = /obj/item/clothing/shoes/color/orange

/obj/abstract/landmark/corpse/lar_maria/zhp_guard
	name = "dead guard"
	corpse_outfits = list(/decl/outfit/corpse/zhp_guard)
	skin_tones_per_species = list(/decl/species/human::uid = list(-15))

/obj/abstract/landmark/corpse/lar_maria/zhp_guard/dark
	skin_tones_per_species = list(/decl/species/human::uid = list(-115))

/decl/outfit/corpse/zhp_guard
	name = "Dead ZHP guard"
	uniform = /obj/item/clothing/jumpsuit/virologist
	suit = /obj/item/clothing/suit/armor/pcarrier/light
	head = /obj/item/clothing/head/soft/zhp_cap
	shoes = /obj/item/clothing/shoes/jackboots/duty
	l_ear = /obj/item/radio/headset

/mob/living/simple_animal/hostile/lar_maria/guard//angry guards armed with batons and shotguns. Still bite
	name = "security"
	desc = "Guard dressed at Zeng-Hu Pharmaceuticals uniform."
	max_health = 60
	natural_weapon = /obj/item/baton
	weapon = /obj/item/baton
	corpse = /obj/abstract/landmark/corpse/lar_maria/zhp_guard

/mob/living/simple_animal/hostile/lar_maria/guard/Initialize()
	. = ..()
	var/skin_color = pick(list("light","dark"))
	if(istype(weapon, /obj/item/gun))
		if(skin_color == "dark")
			icon = 'mods/content/corporate/away_sites/lar_maria/lar_maria_guard_dark_ranged.dmi'
		else
			icon = 'mods/content/corporate/away_sites/lar_maria/lar_maria_guard_light_ranged.dmi'
	else
		if(skin_color == "dark")
			icon = 'mods/content/corporate/away_sites/lar_maria/lar_maria_guard_dark.dmi'
		else
			icon = 'mods/content/corporate/away_sites/lar_maria/lar_maria_guard_light.dmi'
	if (skin_color == "dark")
		corpse = /obj/abstract/landmark/corpse/lar_maria/zhp_guard/dark

/mob/living/simple_animal/hostile/lar_maria/guard/ranged
	weapon = /obj/item/gun/projectile/shotgun/pump
	projectiletype = /obj/item/projectile/bullet/shotgun/beanbag

/mob/living/simple_animal/hostile/lar_maria/guard/ranged/has_ranged_attack()
	return TRUE

/obj/item/clothing/head/soft/zhp_cap
	name = "Zeng-Hu Pharmaceuticals cap"
	icon = 'mods/content/corporate/icons/clothing/head/zhp_cap.dmi'
	desc = "A green cap with Zeng-Hu Pharmaceuticals symbol on it."

/mob/living/simple_animal/hostile/lar_maria/virologist
	name = "virologist"
	desc = "Virologist dressed at Zeng-Hu Pharmaceuticals uniform."
	icon = 'mods/content/corporate/away_sites/lar_maria/lar_maria_virologist_m.dmi'
	max_health = 50
	corpse = /obj/abstract/landmark/corpse/lar_maria/virologist

/obj/abstract/landmark/corpse/lar_maria/virologist
	name = "dead virologist"
	corpse_outfits = list(/decl/outfit/corpse/zhp_virologist)

/decl/outfit/corpse/zhp_virologist
	name = "Dead male ZHP virologist"
	uniform = /obj/item/clothing/jumpsuit/virologist
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/color/white
	gloves = /obj/item/clothing/gloves/latex/nitrile
	head = /obj/item/clothing/head/surgery
	mask = /obj/item/clothing/mask/surgical
	glasses = /obj/item/clothing/glasses/eyepatch/hud/medical

/mob/living/simple_animal/hostile/lar_maria/virologist/female
	icon = 'mods/content/corporate/away_sites/lar_maria/lar_maria_virologist_f.dmi'
	weapon = /obj/item/scalpel
	corpse = /obj/abstract/landmark/corpse/lar_maria/virologist_female

/obj/abstract/landmark/corpse/lar_maria/virologist_female
	name = "dead virologist"
	corpse_outfits = list(/decl/outfit/corpse/zhp_virologist_female)
	hair_styles_per_species = list(/decl/species/human::uid = list(/decl/sprite_accessory/hair/flair))
	hair_colors_per_species = list(/decl/species/human::uid = list("#ae7b48"))
	genders_per_species = list(/decl/species/human::uid = list(FEMALE))

/decl/outfit/corpse/zhp_virologist_female
	name = "Dead female ZHP virologist"
	uniform = /obj/item/clothing/jumpsuit/virologist
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/color/white
	gloves = /obj/item/clothing/gloves/latex/nitrile
	mask = /obj/item/clothing/mask/surgical

////////////////////////////Notes and papers
/obj/item/paper/lar_maria/note_1
	name = "paper note"
	info = {"
			<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><b><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></b></center>
			<i>We received the latest batch of subjects this evening. Evening? Is it even evening? The schedule out here is so fucked in terms of sleep-cycles I forget to even check what time it is sometimes. I'm pretty sure it's evening anyway. Anyway, point is, we got the new guys, and thus far they seem like they fit the criteria pretty well. No family histories of diseases or the like, no current illnesses, prime physical condition, perfect subjects for our work. Tomorrow we start testing out the type 008 Serum. Hell if I know where this stuff's coming from, but it's fascinating. Injected into live subjects, it seems like it has a tendancy to not only cure them of ailments, but actually improve their bodily functions...</i>
			"}

/obj/item/paper/lar_maria/note_2
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>I can't believe it, the type 8 Serum seems to actually have a regenerative effect on the subjects. We actually cut one's arm open during the test and ten minutes later, it had clotted. Fifteen and it was healing, and within two hours it was nothing but a fading scar. This is insanity, and the worst part is, we can't even determine HOW it does it yet. All these samples of the goo and not a damn clue how it works, it's infuriating! I'm going to try some additional tests with this stuff. I've heard it's got all kinds of uses, fuel enhancer, condiment, so on and so forth, even with this minty taste, but we'll see. There's got to be some rhyme or reason to this damned stuff.</i>
			"}

/obj/item/paper/lar_maria/note_3
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>The samples of Type 8 we've got are almost out, but it seems like we're actually onto something major here. We'll need to get more sent over asap. This stuff may well be the key to immortality. We cut off one of the test subject's arms and they just put it back on and it healed in an hour or so to the point it was working fine. It's nothing short of miraculous.</i>
			"}

/obj/item/paper/lar_maria/note_4
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>Tedd, don't get into the cells with the Type 8 subjects anymore, something's off about them the last couple days. They haven't been moving right, and they seem distracted nearly constantly, and not in a normal way. They also look like they're turning kinda... green? One of the other guys says it's probably just a virus or something reacting with it, but I don't know, something seems off.</i>
			"}

/obj/item/paper/lar_maria/note_5
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			This is a reminder to all facility staff, while we may be doing important work for the good of humanity here, our methods are not necessarily one hundred percent legal, and as such you are NOT permitted, as outlined in your contract, to discuss the nature of your work, nor any other related information, with anyone not directly involved with the project without express permission of your facility director. This includes family, friends, local or galactic news outlets and bluenet chat forums.
			"}

/obj/item/paper/lar_maria/note_6
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			Due to the recent incident in the labs involving Type 8 test subject #12 and #33, all research personnel are to refrain from interacting directly with the research subjects involved in serum type 8 testing without the presence of armed guards and full Biohazard protective measures in place.
			"}

/obj/item/paper/lar_maria/note_7
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>Can we get some more diversity in test subjects? I know we're mostly working with undesirables, but criminals and frontier colonists aren't exactly the most varied bunch. We could majorly benefit from having some non-human test subjects, for example. Oooh, or one of those snake things Xynergy's got a monopoly on.</i>
			"}

/obj/item/paper/lar_maria/note_8
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>On a related note, can we get some more female subjects? There's been some discussion about gender related differences in reactions to some of the chemicals we're working on. Testosterone and shit affecting chemical balances or something, I'm not sure, point is, variety.</i>
			"}

/obj/item/paper/lar_maria/note_9
	name = "paper note"
	info = "<i><font color='blue'>can we get some fresh carp sometime? Or freshish? Or frozen? I just really want carp, ok? I'm willing to pay for it if so.</font></i>"
