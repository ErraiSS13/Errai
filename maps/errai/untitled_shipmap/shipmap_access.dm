// New access codes for the ship.
var/global/const/access_cargo_hold = "ACCESS_CARGO_HOLD"
/datum/access/cargo_hold
	id = access_cargo_hold
	desc = "Cargo Hold"
	region = ACCESS_REGION_SUPPLY

var/global/const/access_shuttle_pilot = "ACCESS_SHUTTLE_PILOT"
/datum/access/shuttle_pilot
	id = access_shuttle_pilot
	desc = "Shuttle Pilot"
	region = ACCESS_REGION_SUPPLY

// Tweaks to existing access codes.
/datum/access/hos
	desc = "Chief of Security"

/datum/access/rd
	desc = "Research Director"

/datum/access/hop
	desc = "First Officer"

/datum/access/research
	desc = "Research"

/datum/access/cargo
	desc = "Supply"

/datum/access/cmo
	region = ACCESS_REGION_MEDBAY

/datum/access/eva
	region = ACCESS_REGION_GENERAL

// Hiding unused access codes.
/datum/access/crematorium
	region = ACCESS_REGION_NONE

/datum/access/cargo_bot
	region = ACCESS_REGION_NONE

/datum/access/library
	region = ACCESS_REGION_NONE

/datum/access/lawyer
	region = ACCESS_REGION_NONE

/datum/access/virology
	region = ACCESS_REGION_NONE

/datum/access/mining_office
	region = ACCESS_REGION_NONE

/datum/access/mining_station
	region = ACCESS_REGION_NONE

/datum/access/gateway
	region = ACCESS_REGION_NONE

/datum/access/psychiatrist
	region = ACCESS_REGION_NONE

/datum/access/cameras
	region = ACCESS_REGION_NONE

/*
var/global/const/access_bearcat = "ACCESS_BEARCAT" //998
/datum/access/bearcat
	id = access_bearcat
	desc = "FTU Crewman"
	region = ACCESS_REGION_NONE
*/