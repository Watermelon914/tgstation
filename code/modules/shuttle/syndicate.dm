#define SYNDICATE_CHALLENGE_TIMER 20 MINUTES

/obj/machinery/computer/shuttle/syndicate
	name = "syndicate shuttle terminal"
	desc = "The terminal used to control the syndicate transport shuttle."
	circuit = /obj/item/circuitboard/computer/syndicate_shuttle
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	req_access = list(ACCESS_SYNDICATE)
	shuttleId = "syndicate"
	possible_destinations = "syndicate_away;syndicate_z5;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s;syndicate_custom"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	flags_1 = NODECONSTRUCT_1

/obj/machinery/computer/shuttle/syndicate/allowed(mob/M)
	if(issilicon(M) && !(ROLE_SYNDICATE in M.faction))
		return FALSE
	return ..()

/obj/machinery/computer/shuttle/syndicate/launch_check(mob/user)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/circuitboard/computer/syndicate_shuttle/board = circuit
	if(board?.challenge && world.time < SYNDICATE_CHALLENGE_TIMER)
		to_chat(user, span_warning("You've issued a combat challenge to the station! You've got to give them at least [DisplayTimeText(SYNDICATE_CHALLENGE_TIMER - world.time)] more to allow them to prepare."))
		return FALSE
	board.moved = TRUE
	return TRUE

/obj/machinery/computer/shuttle/syndicate/recall
	name = "syndicate shuttle recall terminal"
	desc = "Use this if your friends left you behind."
	possible_destinations = "syndicate_away"

/obj/machinery/computer/shuttle/syndicate/drop_pod
	name = "syndicate assault pod control"
	desc = "Controls the drop pod's launch system."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "dorm_available"
	icon_keyboard = null
	light_color = LIGHT_COLOR_BLUE
	req_access = list(ACCESS_SYNDICATE)
	shuttleId = "steel_rain"
	possible_destinations = null

/obj/machinery/computer/shuttle/syndicate/drop_pod/launch_check(mob/user)
	. = ..()
	if(!.)
		return FALSE
	if(!is_centcom_level(z))
		to_chat(user, span_warning("Pods are one way!"))
		return FALSE
	return TRUE

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate
	name = "syndicate shuttle navigation computer"
	desc = "Used to designate a precise transit location for the syndicate shuttle."
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	shuttleId = "syndicate"
	lock_override = CAMERA_LOCK_STATION
	shuttlePortId = "syndicate_custom"
	jumpto_ports = list("syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1)
	view_range = 5.5
	x_offset = -7
	y_offset = -1
	whitelist_turfs = list(/turf/open/space, /turf/open/floor/plating, /turf/open/lava, /turf/closed/mineral, /turf/open/openspace)
	see_hidden = TRUE

// Stationary docking ports for the Starfury.
/obj/docking_port/stationary/starfury
	name = "SBC Starfury"
	id = "SBC_starfury"
	hidden = TRUE
	height = 67
	width = 37
	dwidth = 34
	dheight = 6
	dir = WEST

/obj/docking_port/stationary/starfury/corvette
	name = "SBC Starfury Corvette Bay"
	id = "SBC_corvette_bay"
	width = 14
	height = 7
	dwidth = 7
	dir = NORTH

/obj/docking_port/stationary/starfury/fighter_one
	name = "SBC Starfury Port Fighter Bay"
	id = "SBC_fighter1_bay"
	width = 5
	height = 7
	dwidth = 2
	dir = NORTH

/obj/docking_port/stationary/starfury/fighter_two
	name = "SBC Starfury Center Fighter Bay"
	id = "SBC_fighter2_bay"
	width = 5
	height = 7
	dwidth = 2
	dir = NORTH

/obj/docking_port/stationary/starfury/fighter_three
	name = "SBC Starfury Starboard Fighter Bay"
	id = "SBC_fighter3_bay"
	width = 5
	height = 7
	dwidth = 2
	dir = NORTH

// Mobile docking ports for the Starfury's and her strike shuttles.

/obj/docking_port/mobile/syndicate_starfury
	name = "\improper SBC Starfury"
	id = "SBC_starfury"
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	hidden = TRUE
	height = 67
	width = 37
	dwidth = 34
	dheight = 6
	dir = WEST
	port_direction = EAST

/obj/docking_port/mobile/syndicate_starfury/Initialize(mapload)
	. = ..()
	SSpoints_of_interest.make_point_of_interest(src)

/obj/docking_port/mobile/syndicate_fighter
	name = "syndicate fighter"
	id = "syndicate_fighter"
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	hidden = TRUE
	dir = NORTH
	port_direction = SOUTH
	width = 5
	height = 7
	dwidth = 2

/obj/docking_port/mobile/syndicate_fighter/fighter_one
	name = "syndicate fighter one"
	id = "SBC_fighter1"

/obj/docking_port/mobile/syndicate_fighter/fighter_two
	name = "syndicate fighter two"
	id = "SBC_fighter2"

/obj/docking_port/mobile/syndicate_fighter/fighter_three
	name = "syndicate fighter three"
	id = "SBC_fighter3"

/obj/docking_port/mobile/syndicate_corvette
	name = "syndicate corvette"
	id = "SBC_corvette"
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)
	hidden = TRUE
	dir = NORTH
	port_direction = SOUTH
	preferred_direction = EAST
	width = 14
	height = 7
	dwidth = 7

// Shuttle navigation consoles for the Starfury and her shuttles.
/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/starfury
	name = "\improper SBC Starfury navigation computer"
	desc = "Used to pilot the behemoth syndicate spacecraft known as the SBC Starfury."
	req_access = list(ACCESS_SYNDICATE)
	shuttleId = "SBC_starfury"
	shuttlePortId = "SBC_starfury_custom"

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/fighter
	name = "syndicate fighter navigation computer"
	desc = "Used to pilot syndicate fighters to commence precision strikes."
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/fighter/fighter_one
	shuttleId = "SBC_fighter1"
	shuttlePortId = "SBC_fighter1_custom"
	jumpto_ports = list("SBC_fighter1_bay" = 1, "syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1)

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/fighter/fighter_two
	shuttleId = "SBC_fighter2"
	shuttlePortId = "SBC_fighter2_custom"
	jumpto_ports = list("SBC_fighter2_bay" = 1, "syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1)

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/fighter/fighter_three
	shuttleId = "SBC_fighter3"
	shuttlePortId = "SBC_fighter3_custom"
	jumpto_ports = list("SBC_fighter3_bay" = 1, "syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1)

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/corvette
	name = "syndicate corvette navigation computer"
	desc = "Used to pilot the syndicate corvette to board enemy stations and ships."
	req_access = list(ACCESS_SYNDICATE)
	shuttleId = "SBC_corvette"
	shuttlePortId = "SBC_corvette_custom"
	jumpto_ports = list("SBC_corvette_bay" = 1, "syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1)

// Aaaand shuttle consoles for the Starfury and her shuttles.
/obj/machinery/computer/shuttle/starfury
	name = "\improper SBC Starfury shuttle console"
	desc = "A control computer for a shuttle of the SBC Starfury."
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = "#FA8282"
	req_access = list(ACCESS_SYNDICATE)
	possible_destinations = "SBC_starfury_custom;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s"
	shuttleId = "SBC_starfury"

/obj/machinery/computer/shuttle/starfury/fighter
	name = "syndicate fighter control console"
	desc = "A control computer which controls a shuttle which operates from the SBC Starfury.."

/obj/machinery/computer/shuttle/starfury/fighter/fighter_one
	shuttleId = "SBC_fighter1"
	possible_destinations = "SBC_fighter1_custom;SBC_fighter1;SBC_fighter2;SBC_fighter3;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s"

/obj/machinery/computer/shuttle/starfury/fighter/fighter_two
	shuttleId = "SBC_fighter2"
	possible_destinations = "SBC_fighter2_custom;SBC_fighter1;SBC_fighter2;SBC_fighter3;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s"

/obj/machinery/computer/shuttle/starfury/fighter/fighter_three
	shuttleId = "SBC_fighter3"
	possible_destinations = "SBC_fighter3_custom;SBC_fighter1;SBC_fighter2;SBC_fighter3;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s"

/obj/machinery/computer/shuttle/starfury/corvette
	name = "syndicate corvette control console"
	desc = "A control computer which controls a shuttle which operates from the SBC Starfury.."
	shuttleId = "SBC_corvette"
	possible_destinations = "SBC_corvette_custom;SBC_corvette_bay;syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s"

#undef SYNDICATE_CHALLENGE_TIMER

/proc/test_summon_battlecruiser()
	var/datum/map_template/shuttle/battlecruiser/starfury/ship = new()
	var/x = rand(TRANSITIONEDGE,world.maxx - TRANSITIONEDGE - ship.width)
	var/y = rand(TRANSITIONEDGE,world.maxy - TRANSITIONEDGE - ship.height)
	var/z = SSmapping.empty_space.z_value
	var/turf/battlecruiser_loading_turf = locate(x,y,z)
	if(!battlecruiser_loading_turf)
		CRASH("Battlecruiser found no turf to load in")

	if(!ship.load(battlecruiser_loading_turf))
		CRASH("Loading battlecruiser ship failed!")

	SSshuttle.unload_preview()
	var/datum/map_template/shuttle/battlecruiser/starfury/fighter_one/first_fighter = new()
	var/obj/docking_port/stationary/starfury/fighter_one/fighter_one_spot = locate()
	if(fighter_one_spot)
		SSshuttle.action_load(first_fighter, fighter_one_spot)

	SSshuttle.unload_preview()
	var/datum/map_template/shuttle/battlecruiser/starfury/fighter_two/second_fighter = new()
	var/obj/docking_port/stationary/starfury/fighter_two/fighter_two_spot = locate()
	if(fighter_two_spot)
		SSshuttle.action_load(second_fighter, fighter_two_spot)

	SSshuttle.unload_preview()
	var/datum/map_template/shuttle/battlecruiser/starfury/corvette/corvette = new()
	var/obj/docking_port/stationary/starfury/corvette/corvette_spot = locate()
	if(corvette_spot)
		SSshuttle.action_load(corvette, corvette_spot)

	SSshuttle.unload_preview()
	priority_announce("Unidentified armed ship detected near the station.")
