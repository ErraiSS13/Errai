/datum/keybinding/admin
	abstract_type = /datum/keybinding/admin
	category = CATEGORY_ADMIN

/datum/keybinding/admin/can_use(client/user)
	return !!user.holder

/datum/keybinding/admin/mod_say
	hotkey_keys = list("F5")
	name = "mod_say"
	full_name = "Mod Say"
	description = "Talk with other moderators."

/datum/keybinding/admin/mod_say/down(client/user)
	user.cmd_mod_say(input(user, null, "dsay \"text\"") as text|null)
	return TRUE

/datum/keybinding/admin/admin_say
	hotkey_keys = list("ShiftF5")
	name = "admin_say"
	full_name = "Admin Say"
	description = "Talk with other admins."

/datum/keybinding/admin/admin_say/down(client/user)
	user.cmd_admin_say(input(user, null, "asay \"text\"") as text|null)
	return TRUE

/datum/keybinding/admin/admin_ghost
	hotkey_keys = list("F6")
	name = "admin_ghost"
	full_name = "Aghost"
	description = "Go ghost"

/datum/keybinding/admin/admin_ghost/down(client/user)
	user.admin_ghost()
	return TRUE

/datum/keybinding/admin/list_players
	hotkey_keys = list("F7")
	name = "list_players"
	full_name = "List Players"
	description = "Opens up the list players panel"

/datum/keybinding/admin/list_players/down(client/user)
	user.holder.list_players()
	return TRUE

/datum/keybinding/admin/admin_pm
	hotkey_keys = list("F8")
	name = "admin_pm"
	full_name = "Admin PM"
	description = "Sends Admin PM message"

/datum/keybinding/admin/admin_pm/down(client/user)
	user.cmd_admin_pm_panel()
	return TRUE

/datum/keybinding/admin/invisimin
	hotkey_keys = list("F9")
	name = "invisimin"
	full_name = "Admin Invisibility"
	description = "Toggles ghost-like invisibility (Don't abuse this)"

/datum/keybinding/admin/invisimin/down(client/user)
	user.invisimin()
	return TRUE

/datum/keybinding/admin/dead_say
	hotkey_keys = list("F10")
	name = "dead_say"
	full_name = "Dead Say"
	description = "Allows you to send a message to dead chat"

/datum/keybinding/admin/dead_say/down(client/user)
	user.dsay(input(src, null, "dsay \"text\"") as text|null)
	return TRUE

/datum/keybinding/admin/deadmin
	hotkey_keys = list("Unbound")
	name = "deadmin"
	full_name = "De-Admin"
	description = "Shed your admin powers"

/datum/keybinding/admin/deadmin/down(client/user)
	user.deadmin_self()
	return TRUE

/datum/keybinding/admin/readmin
	hotkey_keys = list("Unbound")
	name = "readmin"
	full_name = "Re-Admin"
	description = "Regain your admin powers"

/datum/keybinding/admin/readmin/down(client/user)
	user.readmin_self()
	return TRUE
