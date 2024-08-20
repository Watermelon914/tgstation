// Replaces the sprites of walls with the wallening version if wallening is enabled
// Takes the first choice if wallening is enabled. Otherwise, takes the 2nd choice
#ifdef WALLENING
#define GET_WALL_PATH_CHOICE(wall1, wall2) ##wall1
#else
#define GET_WALL_PATH_CHOICE(wall1, wall2) ##wall2
#endif

#ifdef WALLENING
#define IS_WALLENING TRUE
#else
#define IS_WALLENING FALSE
#endif
