var/global/const/CAMERA_CHANNEL_SUPPLY = "Supply"
var/global/const/CAMERA_CHANNEL_SERVICE = "Service"
var/global/const/CAMERA_CHANNEL_COMMAND = "Command"
var/global/const/CAMERA_CHANNEL_SHUTTLE = "Shuttle"
var/global/const/CAMERA_CHANNEL_DECK_ONE = "Deck One"
var/global/const/CAMERA_CHANNEL_DECK_TWO = "Deck Two"
var/global/const/CAMERA_CHANNEL_DECK_THREE = "Deck Three"

/obj/machinery/camera/network/engineering
	preset_channels = list(CAMERA_CAMERA_CHANNEL_ENGINEERING)
	req_access = null

/obj/machinery/camera/network/medbay
	preset_channels = list(CAMERA_CHANNEL_MEDICAL)
	req_access = null

/obj/machinery/camera/network/research
	preset_channels = list(CAMERA_CHANNEL_RESEARCH)
	req_access = null

/obj/machinery/camera/network/mining
	preset_channels = list(CAMERA_CHANNEL_SUPPLY)
	req_access = null

/obj/machinery/camera/network/security
	preset_channels = list(CAMERA_CHANNEL_SECURITY)
	req_access = null

/obj/machinery/camera/network/service
	preset_channels = list(CAMERA_CHANNEL_SERVICE)

/obj/machinery/camera/network/command
	preset_channels = list(CAMERA_CHANNEL_COMMAND)

/obj/machinery/camera/network/shuttle
	preset_channels = list(CAMERA_CHANNEL_SHUTTLE)

/obj/machinery/camera/network/deck_one
	preset_channels = list(CAMERA_CHANNEL_DECK_ONE)

/obj/machinery/camera/network/deck_two
	preset_channels = list(CAMERA_CHANNEL_DECK_TWO)

/obj/machinery/camera/network/deck_three
	preset_channels = list(CAMERA_CHANNEL_DECK_THREE)


// Motion cameras.
/obj/machinery/camera/motion/command
	preset_channels = list(CAMERA_CHANNEL_COMMAND)

// All upgrades.
/obj/machinery/camera/all/command
	preset_channels = list(CAMERA_CHANNEL_COMMAND)
