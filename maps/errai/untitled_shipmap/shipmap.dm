#if !defined(USING_MAP_DATUM)

	#ifdef UNIT_TEST
		#include "code/unit_tests/offset_tests.dm"
	#endif

	// Gamemodes
	#include "../../../mods/gamemodes/cult/_cult.dme"
	//#include "mods/gamemodes/cult/_cult.dme"
	#include "../../../mods/gamemodes/heist/_heist.dme"
	#include "../../../mods/gamemodes/ninja/_ninja.dme"
	#include "../../../mods/gamemodes/revolution/_revolution.dme"
	#include "../../../mods/gamemodes/spyvspy/_spyvspy.dme"
	#include "../../../mods/gamemodes/traitor/_traitor.dme"
	#include "../../../mods/gamemodes/mixed.dm"

	// Nebula modpacks.
	#include "../../../mods/content/corporate/_corporate.dme"
	#include "../../../mods/content/dungeon_loot/_dungeon_loot.dme"
	#include "../../../mods/content/government/_government.dme"
	#include "../../../mods/content/matchmaking/_matchmaking.dme"
	#include "../../../mods/content/modern_earth/_modern_earth.dme"
	#include "../../../mods/content/mouse_highlights/_mouse_highlight.dme"
	#include "../../../mods/content/pheromones/_pheromones.dme"
	#include "../../../mods/content/supermatter/_supermatter.dme"
	#include "../../../mods/content/xenobiology/_xenobiology.dme"

	#include "../../../mods/mobs/dionaea/_dionaea.dme"
//	#include "../../../mods/mobs/borers/_borers.dme"

	// Must come after borers for compatibility.
//	#include "../../../mods/content/psionics/_psionics.dme"

	// Species modpacks.
//	#include "../../../mods/species/ascent/_ascent.dme"
//	#include "../../../mods/species/bayliens/_bayliens.dme"
//	#include "../../../mods/species/drakes/_drakes.dme"
//	#include "../../../mods/species/neoavians/_neoavians.dme"
//	#include "../../../mods/species/serpentid/_serpentid.dme"
//	#include "../../../mods/species/utility_frames/_utility_frames.dme"
//	#include "../../../mods/species/vox/_vox.dme"

	// Away sites.
	#include "../../../maps/random_ruins/exoplanet_ruins/playablecolony/playablecolony.dm"

	#include "../../../mods/content/government/away_sites/icarus/icarus.dm"
	#include "../../../mods/content/corporate/away_sites/lar_maria/lar_maria.dm"

	#include "../../../maps/away/bearcat/bearcat.dm"
	#include "../../../maps/away/casino/casino.dm"
	#include "../../../maps/away/derelict/derelict.dm"
	#include "../../../maps/away/errant_pisces/errant_pisces.dm"
	#include "../../../maps/away/lost_supply_base/lost_supply_base.dm"
	#include "../../../maps/away/magshield/magshield.dm"
	#include "../../../maps/away/mining/mining.dm"
	#include "../../../maps/away/mobius_rift/mobius_rift.dm"
	#include "../../../maps/away/smugglers/smugglers.dm"
	#include "../../../maps/away/unishi/unishi.dm"
	#include "../../../maps/away/yacht/yacht.dm"
	#include "../../../maps/away/liberia/liberia.dm"

	// Errai Modpacks.

	// Map files.
	// Common files.
	#include "../common/mapping_colors.dm"
	#include "../common/common_areas.dm"

	// Shipmap files.
	// Jobs.
//	#include "jobs/_goals.dm"
//	#include "jobs/_jobs.dm"
//	#include "jobs/captain.dm"
//	#include "jobs/command.dm"
//	#include "jobs/civilian.dm"
//	#include "jobs/engineering.dm"
//	#include "jobs/supply.dm"
//	#include "jobs/medical.dm"
//	#include "jobs/science.dm"
//	#include "jobs/security.dm"
//	#include "jobs/synthetics.dm"

	// Outfits.
//	#include "outfits/_pda.dm"
//	#include "outfits/cargo.dm"
//	#include "outfits/civilian.dm"
//	#include "outfits/command.dm"
//	#include "outfits/engineering.dm"
//	#include "outfits/medical.dm"
//	#include "outfits/science.dm"
//	#include "outfits/security.dm"

	// Misc.
//	#include "exodus_announcements.dm"
//	#include "exodus_antagonism.dm"
//	#include "exodus_cameras.dm"
//	#include "spaceship_areas.dm"
//	#include "exodus_elevator.dm"
//	#include "spaceship_departments.dm"
//	#include "spaceship_jobs.dm"
//	#include "exodus_loadout.dm"
//	#include "spaceship_overmap.dm"
	#include "shipmap_overrides.dm"
//	#include "exodus_setup.dm"
//	#include "spaceship_shuttles.dm"
//	#include "exodus_unit_testing.dm"

	// Map files.
	#include "shipmap-1.dmm"
	#include "shipmap-2.dmm"
	#include "shipmap-3.dmm"

	#define USING_MAP_DATUM /datum/map/shipmap

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Shipmap

#endif