/**
 * # Drone
 *
 * A movable mob that can be fed inputs on which direction to travel.
 */
/mob/living/circuit_drone
	name = "drone"
	icon = 'icons/obj/wiremod.dmi'
	icon_state = "setup_medium_med"
	living_flags = 0
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_on = FALSE

/mob/living/circuit_drone/Initialize()
	. = ..()
	AddComponent(/datum/component/shell, list(
		new /obj/item/circuit_component/bot_circuit()
	), SHELL_CAPACITY_LARGE)

/mob/living/circuit_drone/updatehealth()
	. = ..()
	if(health < 0)
		gib(no_brain = TRUE, no_organs = TRUE, no_bodyparts = TRUE)

/mob/living/circuit_drone/spawn_gibs()
	new /obj/effect/gibspawner/robot(drop_location(), src, get_static_viruses())

/obj/item/circuit_component/bot_circuit
	display_name = "Drone"
	desc = "Used to send movement output signals to the drone shell."

	/// The inputs to allow for the drone to move
	var/datum/port/input/move/north
	var/datum/port/input/move/east
	var/datum/port/input/move/south
	var/datum/port/input/move/west

	/// Delay between each movement
	var/move_delay = 0.2 SECONDS

/datum/port/input/move/
	// Done like this so that travelling diagonally is more simple
	COOLDOWN_DECLARE(delay)
	var/direction

/obj/item/circuit_component/bot_circuit/populate_ports()
	north = add_input_port("Move North", PORT_TYPE_SIGNAL, port_type = /datum/port/input/move)
	north.direction = NORTH
	east = add_input_port("Move East", PORT_TYPE_SIGNAL, port_type = /datum/port/input/move)
	east.direction = EAST
	south = add_input_port("Move South", PORT_TYPE_SIGNAL, port_type = /datum/port/input/move)
	south.direction = SOUTH
	west = add_input_port("Move West", PORT_TYPE_SIGNAL, port_type = /datum/port/input/move)
	west.direction = WEST

/obj/item/circuit_component/bot_circuit/input_received(datum/port/input/move/port)
	var/mob/living/shell = parent.shell
	if(istype(shell) && !shell.stat && COOLDOWN_FINISHED(port, delay))
		COOLDOWN_START(port, delay, move_delay)
		if(shell.Process_Spacemove(port.direction))
			shell.Move(get_step(shell, port.direction), port.direction)
