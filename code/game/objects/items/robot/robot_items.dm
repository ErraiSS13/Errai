//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32
/obj/item/borg
	max_health = ITEM_HEALTH_NO_DAMAGE

/**********************************************************************
						Cyborg Spec Items
***********************************************************************/
/obj/item/borg/overdrive
	name = "overdrive"
	icon = 'icons/obj/signs/warnings.dmi'
	icon_state = "shock"

/**********************************************************************
						HUD/SIGHT things
***********************************************************************/
/obj/item/borg/sight
	icon = 'icons/obj/signs/warnings.dmi'
	icon_state = "secureareaold"
	var/sight_mode = null
	var/glasses_hud_type

/obj/item/borg/sight/xray
	name = "\proper x-ray vision"
	sight_mode = BORGXRAY


/obj/item/borg/sight/thermal
	name = "\proper thermal vision"
	sight_mode = BORGTHERM
	icon_state = "world-active"
	icon = 'icons/clothing/eyes/scanner_thermal.dmi'


/obj/item/borg/sight/meson
	name = "\proper meson vision"
	sight_mode = BORGMESON
	icon_state = "world-active"
	icon = 'icons/clothing/eyes/scanner_meson.dmi'

/obj/item/borg/sight/material
	name = "\proper material scanner vision"
	sight_mode = BORGMATERIAL

/obj/item/borg/sight/hud
	name = "hud"
	var/obj/item/clothing/glasses/hud/hud = null


/obj/item/borg/sight/hud/med
	name = "medical hud"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/eyes/hud_medical.dmi'
	glasses_hud_type = HUD_MEDICAL

/obj/item/borg/sight/hud/med/Initialize()
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/health(src)

/obj/item/borg/sight/hud/sec
	name = "security hud"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/eyes/hud_security.dmi'
	glasses_hud_type = HUD_SECURITY

/obj/item/borg/sight/hud/Initialize()
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/security(src)


/obj/item/borg/sight/hud/jani
	name = "janitor hud"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/eyes/hud_janitor.dmi'
	glasses_hud_type = HUD_JANITOR

/obj/item/borg/sight/hud/jani/Initialize()
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/janitor(src)