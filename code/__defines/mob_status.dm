#define PENDING_STATUS(MOB, COND)      (LAZYACCESS(MOB.pending_status_counters, COND) || LAZYACCESS(MOB.status_counters, COND))
#define GET_STATUS(MOB, COND)          (LAZYACCESS(MOB.status_counters, COND))
#define HAS_STATUS(MOB, COND)          (GET_STATUS(MOB, COND) > 0)
#define ADJ_STATUS(MOB, COND, AMT)     (MOB.set_status_condition(COND, PENDING_STATUS(MOB, COND) + AMT))
#define SET_STATUS_MAX(MOB, COND, AMT) (MOB.set_status_condition(COND, max(PENDING_STATUS(MOB, COND), AMT)))