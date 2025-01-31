// Basically the same as Exodus settings.
/decl/special_role/traitor/Initialize()
	. = ..()
	LAZYINITLIST(protected_jobs)
	protected_jobs |= list(
		/datum/job/shipmap/head/captain,
		/datum/job/shipmap/head/first_officer,
		/datum/job/shipmap/head/chief_of_security,
		/datum/job/shipmap/security_officer
	)

/decl/special_role/cultist/Initialize()
	. = ..()
	LAZYINITLIST(restricted_jobs)
	restricted_jobs |= list(
		/datum/job/shipmap/head/captain,
		/datum/job/shipmap/head/first_officer,
		/datum/job/shipmap/head/chief_of_security
	)
	LAZYINITLIST(protected_jobs)
	protected_jobs |= list(/datum/job/shipmap/security_officer)
	LAZYINITLIST(blacklisted_jobs)
	blacklisted_jobs |= list(/datum/job/shipmap/counselor)

/decl/special_role/loyalist
	command_department_id = /decl/department/command

/decl/special_role/revolutionary
	command_department_id = /decl/department/command
