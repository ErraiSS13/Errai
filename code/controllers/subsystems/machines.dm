#define SSMACHINES_PIPENETS      1
#define SSMACHINES_MACHINERY     2
#define SSMACHINES_POWERNETS     3
#define SSMACHINES_POWER_OBJECTS 4

#define START_PROCESSING_IN_LIST(Datum, List) \
if (Datum.is_processing) {\
	if(Datum.is_processing != "SSmachines.[#List]")\
	{\
		PRINT_STACK_TRACE("Failed to start processing. [log_info_line(Datum)] is already being processed by [Datum.is_processing] but queue attempt occurred on SSmachines.[#List]."); \
	}\
} else {\
	Datum.is_processing = "SSmachines.[#List]";\
	SSmachines.List += Datum;\
}

#define STOP_PROCESSING_IN_LIST(Datum, List) \
if(Datum.is_processing) {\
	if(SSmachines.List.Remove(Datum)) {\
		Datum.is_processing = null;\
	} else {\
		PRINT_STACK_TRACE("Failed to stop processing. [log_info_line(Datum)] is being processed by [is_processing] and not found in SSmachines.[#List]"); \
	}\
}

#define START_PROCESSING_PIPENET(Datum) START_PROCESSING_IN_LIST(Datum, pipenets)
#define STOP_PROCESSING_PIPENET(Datum) STOP_PROCESSING_IN_LIST(Datum, pipenets)

#define START_PROCESSING_POWERNET(Datum) START_PROCESSING_IN_LIST(Datum, powernets)
#define STOP_PROCESSING_POWERNET(Datum) STOP_PROCESSING_IN_LIST(Datum, powernets)

#define START_PROCESSING_POWER_OBJECT(Datum) START_PROCESSING_IN_LIST(Datum, power_objects)
#define STOP_PROCESSING_POWER_OBJECT(Datum) STOP_PROCESSING_IN_LIST(Datum, power_objects)

SUBSYSTEM_DEF(machines)
	name = "Machines"
	init_order = SS_INIT_MACHINES
	priority = SS_PRIORITY_MACHINERY
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME

	var/current_step = SSMACHINES_PIPENETS

	var/cost_pipenets      = 0
	var/cost_machinery     = 0
	var/cost_powernets     = 0
	var/cost_power_objects = 0

	var/list/pipenets      = list()
	var/list/machinery     = list() // These are all machines.
	var/list/powernets     = list()
	var/list/power_objects = list()

	var/list/processing  = list() // These are the machines which are processing.
	var/list/current_run = list()

/datum/controller/subsystem/machines/Initialize(timeofday)
	makepowernets()
	setup_atmos_machinery(machinery)
	fire()
	..()

#define INTERNAL_PROCESS_STEP(this_step, check_resumed, proc_to_call, cost_var, next_step)\
if(current_step == this_step || (check_resumed && !resumed)) {\
	timer = TICK_USAGE;\
	proc_to_call(resumed);\
	cost_var = MC_AVERAGE(cost_var, TICK_DELTA_TO_MS(TICK_USAGE - timer));\
	if(state != SS_RUNNING){\
		return;\
	}\
	resumed = 0;\
	current_step = next_step;\
}

/datum/controller/subsystem/machines/fire(resumed = 0)
	var/timer = TICK_USAGE

	INTERNAL_PROCESS_STEP(SSMACHINES_PIPENETS,TRUE,process_pipenets,cost_pipenets,SSMACHINES_MACHINERY)
	INTERNAL_PROCESS_STEP(SSMACHINES_MACHINERY,FALSE,process_machinery,cost_machinery,SSMACHINES_POWERNETS)
	INTERNAL_PROCESS_STEP(SSMACHINES_POWERNETS,FALSE,process_powernets,cost_powernets,SSMACHINES_POWER_OBJECTS)
	INTERNAL_PROCESS_STEP(SSMACHINES_POWER_OBJECTS,FALSE,process_power_objects,cost_power_objects,SSMACHINES_PIPENETS)

#undef INTERNAL_PROCESS_STEP

/datum/controller/subsystem/machines/StartLoadingMap()
	suspend()

/datum/controller/subsystem/machines/StopLoadingMap()
	wake()

// rebuild all power networks from scratch - only called at world creation or by the admin verb
// The above is a lie. Turbolifts also call this proc.
/datum/controller/subsystem/machines/proc/makepowernets()
	for(var/datum/powernet/PN in powernets)
		qdel(PN)
	powernets.Cut()
	setup_powernets_for_cables(global.all_cables)

/datum/controller/subsystem/machines/proc/setup_powernets_for_cables(list/cables)
	for(var/obj/structure/cable/PC in cables)
		if(!PC.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(PC)
			propagate_network(PC,PC.powernet)

/datum/controller/subsystem/machines/proc/setup_atmos_machinery(list/machines)
	set background=1

	report_progress("Initializing atmos machinery")
	for(var/obj/machinery/atmospherics/A in machines)
		A.atmos_init()
		CHECK_TICK

	report_progress("Initializing pipe networks")
	for(var/obj/machinery/atmospherics/machine in machines)
		machine.build_network()
		CHECK_TICK

/datum/controller/subsystem/machines/stat_entry()
	var/msg = list()
	msg += "C:{"
	msg += "PI:[round(cost_pipenets,1)]|"
	msg += "MC:[round(cost_machinery,1)]|"
	msg += "PN:[round(cost_powernets,1)]|"
	msg += "PO:[round(cost_power_objects,1)]"
	msg += "} "
	msg += "PI:[pipenets.len]|"
	msg += "MC:[processing.len]|"
	msg += "PN:[powernets.len]|"
	msg += "PO:[power_objects.len]|"
	msg += "MC/MS:[round((cost ? processing.len/cost : 0),0.1)]"
	..(jointext(msg, null))

/datum/controller/subsystem/machines/proc/process_pipenets(resumed = 0)
	if (!resumed)
		src.current_run = pipenets.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = src.current_run
	while(current_run.len)
		var/datum/pipe_network/PN = current_run[current_run.len]
		current_run.len--
		if(istype(PN) && !QDELETED(PN))
			PN.Process(wait)
		else
			pipenets.Remove(PN)
			PN.is_processing = null
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/process_machinery(resumed = 0)
	if (!resumed)
		src.current_run = processing.Copy()

	var/list/current_run = src.current_run
	while(current_run.len)
		var/obj/machinery/M = current_run[current_run.len]
		current_run.len--

		if(!istype(M)) // Below is a debugging and recovery effort. This should never happen, but has been observed recently.
			if(!M)
				continue // Hard delete; unlikely but possible. Soft deletes are handled below and expected.
			if(M in processing)
				processing.Remove(M)
				M.is_processing = null
				PRINT_STACK_TRACE("[log_info_line(M)] was found illegally queued on SSmachines.")
				continue
			else if(resumed)
				current_run.Cut() // Abandon current run; assuming that we were improperly resumed with the wrong process queue.
				PRINT_STACK_TRACE("[log_info_line(M)] was in the wrong subqueue on SSmachines on a resumed fire.")
				process_machinery(0)
				return
			else // ??? possibly dequeued by another machine or something ???
				PRINT_STACK_TRACE("[log_info_line(M)] was in the wrong subqueue on SSmachines on an unresumed fire.")
				continue

		if(!QDELETED(M) && (M.ProcessAll(wait) == PROCESS_KILL))
			processing.Remove(M)
			M.is_processing = null
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/process_powernets(resumed = 0)
	if (!resumed)
		src.current_run = powernets.Copy()

	var/list/current_run = src.current_run
	while(current_run.len)
		var/datum/powernet/PN = current_run[current_run.len]
		current_run.len--
		if(istype(PN) && !QDELETED(PN))
			PN.reset(wait)
		else
			powernets.Remove(PN)
			PN.is_processing = null
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/process_power_objects(resumed = 0)
	if (!resumed)
		src.current_run = power_objects.Copy()

	var/list/current_run = src.current_run
	while(current_run.len)
		var/obj/item/I = current_run[current_run.len]
		current_run.len--
		if(!I.pwr_drain(wait)) // 0 = Process Kill, remove from processing list.
			power_objects.Remove(I)
			I.is_processing = null
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/Recover()
	if (istype(SSmachines.pipenets))
		pipenets = SSmachines.pipenets
	if (istype(SSmachines.machinery))
		machinery = SSmachines.machinery
	if (istype(SSmachines.processing))
		processing = SSmachines.processing
	if (istype(SSmachines.powernets))
		powernets = SSmachines.powernets
	if (istype(SSmachines.power_objects))
		power_objects = SSmachines.power_objects

#undef SSMACHINES_PIPENETS
#undef SSMACHINES_MACHINERY
#undef SSMACHINES_POWERNETS
#undef SSMACHINES_POWER_OBJECTS
