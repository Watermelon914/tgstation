/datum/antagonist/blob
	name = "Blob"
	roundend_category = "blobs"
	antagpanel_category = "Biohazards"
	show_to_ghosts = TRUE
	job_rank = ROLE_BLOB

	var/datum/action/innate/blobpop/pop_action
	var/starting_points_human_blob = OVERMIND_STARTING_POINTS

/datum/antagonist/blob/roundend_report()
	var/basic_report = ..()
	//Display max blobpoints for blebs that lost
	if(isovermind(owner.current)) //embarrasing if not
		var/mob/camera/blob/overmind = owner.current
		if(!overmind.victory_in_progress) //if it won this doesn't really matter
			var/point_report = "<br><b>[owner.name]</b> took over [overmind.max_count] tiles at the height of its growth."
			return basic_report+point_report
	return basic_report

/datum/antagonist/blob/greet()
	to_chat(owner.current, "<span class='alertsyndie'><font color=\"#EE4000\">You are the [owner.special_role].</font></span>")
	owner.announce_objectives()
	if(!isovermind(owner.current))
		to_chat(owner.current, "<span class='notice'>Use the pop ability to place your blob core! It is recommended you do this away from anyone else as you'll be taking on the entire crew!</span>")

/datum/antagonist/blob/on_gain()
	create_objectives()
	. = ..()

/datum/antagonist/blob/remove_innate_effects()
	QDEL_NULL(pop_action)
	return ..()

/datum/antagonist/blob/farewell()
	to_chat(owner.current, "<span class='alertsyndie'><font color=\"#EE4000\">You are no longer the [owner.special_role].</font></span>")
	return ..()

/datum/antagonist/blob/proc/create_objectives()
	var/datum/objective/blob_takeover/main = new
	main.owner = owner
	objectives += main

/datum/antagonist/blob/apply_innate_effects(mob/living/mob_override)
	if(!isovermind(owner.current))
		if(!pop_action)
			pop_action = new
		pop_action.Grant(owner.current)

/datum/objective/blob_takeover
	explanation_text = "Reach critical mass!"

//Non-overminds get this on blob antag assignment
/datum/action/innate/blobpop
	name = "Pop"
	desc = "Unleash the blob"
	icon_icon = 'icons/mob/blob.dmi'
	button_icon_state = "blob"

	var/autoplace_time = OVERMIND_STARTING_AUTO_PLACE_TIME

/datum/action/innate/blobpop/Grant(Target)
	. = ..()
	if(owner)
		addtimer(CALLBACK(src, /datum/action/innate.proc/Activate), autoplace_time, TIMER_UNIQUE|TIMER_OVERRIDE)
		to_chat(owner, "<span class='big'><font color=\"#EE4000\">You will automatically pop and place your blob core in [DisplayTimeText(autoplace_time)].</font></span>")

/datum/action/innate/blobpop/Activate()
	var/mob/living/old_body = owner
	if(!owner)
		return

	var/datum/antagonist/blob/blobtag = owner.mind.has_antag_datum(/datum/antagonist/blob)
	if(!blobtag)
		Remove(owner)
		return
	var/mob/camera/blob/B = new /mob/camera/blob(get_turf(old_body), blobtag.starting_points_human_blob)
	owner.mind.transfer_to(B)
	old_body.gib()
	B.place_blob_core(placement_override = BLOB_FORCE_PLACEMENT, pop_override = TRUE)

/datum/antagonist/blob/antag_listing_status()
	. = ..()
	if(owner?.current)
		var/mob/camera/blob/B = owner.current
		if(istype(B))
			. += "(Progress: [B.blobs_legit.len]/[B.blobwincount])"
