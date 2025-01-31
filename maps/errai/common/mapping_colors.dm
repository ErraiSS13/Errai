// This hard-sets colors for specific objects to aid in mapping. When the game loads the maps, the colors will be overriden, but it should still show in StrongDMM.
// Note that the colors won't be accurate to what's seen in-game, due to coloring the whole sprite and that the base sprite might be grey instead of white.

// Floor tiles.
/turf/floor/tiled
	color = /decl/flooring/tiling::color
	icon_state = /decl/flooring/tiling::icon_base

/turf/floor/tiled/dark
	color = /decl/flooring/tiling/dark::color
	icon_state = /decl/flooring/tiling/dark::icon_base

/turf/floor/tiled/dark/monotile
	color = /decl/flooring/tiling/mono/dark::color
	icon_state = /decl/flooring/tiling/mono/dark::icon_base

/turf/floor/tiled/techfloor
	color = /decl/flooring/tiling/tech::color
	icon_state = /decl/flooring/tiling/tech::icon_base

/turf/floor/tiled/techmaint
	color = /decl/flooring/tiling/new_tile/techmaint::color
	icon_state = /decl/flooring/tiling/new_tile/techmaint::icon_base

/turf/floor/tiled/freezer
	color = /decl/flooring/tiling/freezer::color
	icon_state = /decl/flooring/tiling/freezer::icon_base

/turf/floor/tiled/steel_ridged
	icon_state = /decl/flooring/tiling/new_tile/steel_ridged::icon_base
	color = /decl/flooring/tiling/new_tile/steel_ridged::color

/turf/floor/tiled/monotile
	icon_state = /decl/flooring/tiling/mono::icon_base
	color = /decl/flooring/tiling/mono::color

/turf/floor/tiled/white
	icon_state = /decl/flooring/tiling/white::icon_base
	color = /decl/flooring/tiling/white::color

/turf/floor/tiled/steel_grid
	icon_state = /decl/flooring/tiling/new_tile/steel_grid::icon_base
	color = /decl/flooring/tiling/new_tile/steel_grid::color


// Airlocks.
// Colors may differ due to requiring each 'department' to be uniquely colored.
/obj/machinery/door/airlock/Initialize(mapload, d, populate_parts, obj/structure/door_assembly/assembly)
	color = null // This is kind of blah, might be a good idea to upstream clearing color at some point.
	return ..()

/obj/machinery/door/airlock/double/glass
	icon_state = "closed" // To distinguish from solid double airlocks.

// Command.
/obj/machinery/door/airlock/command
	color = COLOR_COMMAND_BLUE

/obj/machinery/door/airlock/glass/command
	color = COLOR_COMMAND_BLUE

/obj/machinery/door/airlock/hatch/autoname/command
	color = COLOR_COMMAND_BLUE

/obj/machinery/door/airlock/double/command
	color = COLOR_COMMAND_BLUE

/obj/machinery/door/airlock/double/glass/command
	color = COLOR_COMMAND_BLUE


// Security.
/obj/machinery/door/airlock/security
	color = COLOR_NT_RED

/obj/machinery/door/airlock/glass/security
	color = COLOR_NT_RED

/obj/machinery/door/airlock/double/security
	color = COLOR_NT_RED

/obj/machinery/door/airlock/double/glass/security
	color = COLOR_NT_RED


// Engineering.
/obj/machinery/door/airlock/engineering
	color = COLOR_YELLOW

/obj/machinery/door/airlock/glass/engineering
	color = COLOR_YELLOW

/obj/machinery/door/airlock/hatch/autoname/engineering
	color = COLOR_YELLOW

/obj/machinery/door/airlock/double/engineering
	color = COLOR_YELLOW

/obj/machinery/door/airlock/double/glass/engineering
	color = COLOR_YELLOW


// Atmospherics.
/obj/machinery/door/airlock/atmos
	color = COLOR_CYAN

/obj/machinery/door/airlock/glass/atmos
	color = COLOR_CYAN

/obj/machinery/door/airlock/double/atmos
	color = COLOR_CYAN

/obj/machinery/door/airlock/double/glass/atmos
	color = COLOR_CYAN


// Medical.
/obj/machinery/door/airlock/medical
	color = COLOR_DEEP_SKY_BLUE

/obj/machinery/door/airlock/glass/medical
	color = COLOR_DEEP_SKY_BLUE

/obj/machinery/door/airlock/double/medical
	color = COLOR_DEEP_SKY_BLUE

/obj/machinery/door/airlock/double/glass/medical
	color = COLOR_DEEP_SKY_BLUE


// Virology.
/obj/machinery/door/airlock/virology
	color = COLOR_GREEN

/obj/machinery/door/airlock/glass/virology
	color = COLOR_GREEN

/obj/machinery/door/airlock/double/virology
	color = COLOR_GREEN

/obj/machinery/door/airlock/double/glass/virology
	color = COLOR_GREEN


// Mining.
/obj/machinery/door/airlock/mining
	color = COLOR_PALE_ORANGE

/obj/machinery/door/airlock/glass/mining
	color = COLOR_PALE_ORANGE

/obj/machinery/door/airlock/double/mining
	color = COLOR_PALE_ORANGE

/obj/machinery/door/airlock/double/glass/mining
	color = COLOR_PALE_ORANGE


// Research.
/obj/machinery/door/airlock/research
	color = COLOR_RESEARCH

/obj/machinery/door/airlock/glass/research
	color = COLOR_RESEARCH

/obj/machinery/door/airlock/double/research
	color = COLOR_RESEARCH

/obj/machinery/door/airlock/double/glass/research
	color = COLOR_RESEARCH


// "Science", somehow distinct from Research, presumably a holdover from Bay.
/obj/machinery/door/airlock/science
	color = COLOR_VIOLET

/obj/machinery/door/airlock/glass/science
	color = COLOR_VIOLET

/obj/machinery/door/airlock/hatch/autoname/science
	color = COLOR_VIOLET

/obj/machinery/door/airlock/double/science
	color = COLOR_VIOLET

/obj/machinery/door/airlock/double/glass/science
	color = COLOR_VIOLET


// "Sol".
/obj/machinery/door/airlock/sol
	color = COLOR_BLUE_GRAY

/obj/machinery/door/airlock/glass/sol
	color = COLOR_BLUE_GRAY

/obj/machinery/door/airlock/double/sol
	color = COLOR_BLUE_GRAY

/obj/machinery/door/airlock/double/glass/sol
	color = COLOR_BLUE_GRAY


// Civilian.
/obj/machinery/door/airlock/civilian
	color = COLOR_CIVIE_GREEN

/obj/machinery/door/airlock/glass/civilian
	color = COLOR_CIVIE_GREEN

/obj/machinery/door/airlock/double/civilian
	color = COLOR_CIVIE_GREEN

/obj/machinery/door/airlock/double/glass/civilian
	color = COLOR_CIVIE_GREEN


// Chaplain.
/obj/machinery/door/airlock/chaplain
	color = COLOR_GRAY20


// Freezer.
/obj/machinery/door/airlock/freezer
	color = COLOR_WHITE // This won't really do anything.

/obj/machinery/door/airlock/glass/freezer
	color = COLOR_WHITE

/obj/machinery/door/airlock/double/freezer
	color = COLOR_WHITE

/obj/machinery/door/airlock/double/glass/freezer
	color = COLOR_WHITE

// Maintenance.
/obj/machinery/door/airlock/maintenance
	color = COLOR_AMBER

/obj/machinery/door/airlock/glass/maintenance
	color = COLOR_AMBER

/obj/machinery/door/airlock/hatch/autoname/maintenance
	color = COLOR_AMBER

/obj/machinery/door/airlock/double/maintenance
	color = COLOR_AMBER

/obj/machinery/door/airlock/double/glass/maintenance
	color = COLOR_AMBER


// External.
/obj/machinery/door/airlock/external
	color = COLOR_NT_RED

// General.
/obj/machinery/door/airlock/hatch
	color = null

/obj/machinery/door/airlock/hatch/autoname/general
	color = null

