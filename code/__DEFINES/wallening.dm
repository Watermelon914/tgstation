// Replaces the sprites of walls with the wallening version if wallening is enabled
#ifdef WALLENING
#define GET_WALL_PATH(wall) 'icons/turf/walls/wallening/##wall'
// Takes the first choice if wallening is enabled. Otherwise, takes the 2nd choice
#define GET_WALL_PATH_CHOICE(wall1, wall2) ##wall1
#else
#define GET_WALL_PATH(wall) 'icons/turf/walls/normal/##wall'
#define GET_WALL_PATH_CHOICE(wall1, wall2) ##wall2
#endif

#ifdef WALLENING
#define IS_WALLENING TRUE
#else
#define IS_WALLENING FALSE
#endif
