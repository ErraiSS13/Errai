//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implant/freedom
	name = "freedom implant"
	desc = "Use this to escape from those evil Red Shirts."
	origin_tech = @'{"materials":1,"biotech":2,"esoteric":2}'
	implant_color = "r"
	hidden = 1
	var/activation_emote
	var/uses

/obj/item/implant/freedom/get_data()
	return {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Freedom Beacon<BR>
	<b>Life:</b> optimum 5 uses<BR>
	<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
	<HR>
	<b>Implant Details:</b> <BR>
	<b>Function:</b> Transmits a specialized cluster of signals to override handcuff locking
	mechanisms<BR>
	<b>Special Features:</b><BR>
	<i>Neuro-Scan</i>- Analyzes certain shadow signals in the nervous system<BR>
	<b>Integrity:</b> The battery is extremely weak and commonly after injection its
	life can drive down to only 1 use.<HR>
	No Implant Specifics"}

/obj/item/implant/freedom/Initialize()
	. = ..()
	uses = rand(1, 5)

/obj/item/implant/freedom/trigger(emote, mob/living/source)
	if (emote == activation_emote)
		activate()

/obj/item/implant/freedom/activate()
	if(uses < 1 || malfunction)	return 0
	if(remove_cuffs_and_unbuckle(imp_in))
		uses--
		to_chat(imp_in, "You feel a faint click.")

/obj/item/implant/freedom/proc/remove_cuffs_and_unbuckle(mob/living/user)
	var/obj/cuffs = user.get_equipped_item(slot_handcuffed_str)
	if(!cuffs)
		return 0
	. = user.try_unequip(cuffs)
	if(. && user.buckled && user.buckled.buckle_require_restraints)
		user.buckled.unbuckle_mob()
	return

/obj/item/implant/freedom/implanted(mob/living/source)
	src.activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_v", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	source.StoreMemory("\A [src] can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", /decl/memory_options/system)
	to_chat(source, "\The [src] can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")
	return TRUE

/obj/item/implanter/freedom
	name = "implanter (F)"
	imp = /obj/item/implant/freedom

/obj/item/implantcase/freedom
	name = "glass case - 'freedom'"
	imp = /obj/item/implant/freedom