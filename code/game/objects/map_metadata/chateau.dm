#define NO_WINNER "No one has won."

/obj/map_metadata/chateau
	ID = MAP_CHATEAU
	title = "Chateau"
	prishtina_blocking_area_types = list(/area/prishtina/no_mans_land/invisible_wall,
	/area/prishtina/no_mans_land/invisible_wall/inside) // above and underground
	respawn_delay = TRUE
	squad_spawn_locations = FALSE
	min_autobalance_players = 100 // aparently less that this will fuck autobalance
	reinforcements = FALSE
	faction_organization = list(
		GERMAN,
		USA)
	available_subfactions = list(SCHUTZSTAFFEL = 100)
	no_subfaction_chance = FALSE
	subfaction_is_main_faction = TRUE
	roundend_condition_sides = list(
	       list(GERMAN) = /area/prishtina/german/main_area/inside,
		   list(USA) = /area/prishtina/farm4)
	battle_name = "The battle of Chateau"
	faction_distribution_coeffs = list(GERMAN = 0.5, SOVIET = 0.5)


/obj/map_metadata/chateau/germans_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 1800 || admin_ended_all_grace_periods)

/obj/map_metadata/chateau/soviets_can_cross_blocks()
	return (processes.ticker.playtime_elapsed >= 1800 || admin_ended_all_grace_periods)


/obj/map_metadata/chateau/job_enabled_specialcheck(var/datum/job/J)
	. = TRUE
	if (istype(J, /datum/job/usa))
		if (J.is_prisoner_unique)
			. = FALSE
		else if (istype(J, /datum/job/usa/soldier))
			J.total_positions = 70
		else if (istype(J, /datum/job/usa/squad_leader))
			J.total_positions = 5
		else if (istype(J, /datum/job/usa/medic))
			J.total_positions = 15
		else if (istype(J, /datum/job/usa/MP))
			J.total_positions = 15
		else
			. = FALSE
//	else if (istype(J, /datum/job/partisan/civilian))
//		J.total_positions = max(5, round(clients.len*0.75))
	if (istype(J, /datum/job/german))
		if (istype(J, /datum/job/german/squad_leader_ss))
			J.min_positions = 5
			J.max_positions = 5
			J.total_positions = 5
		else if (istype(J, /datum/job/german/soldier_ss))
			J.min_positions = 50
			J.max_positions = 50
			J.total_positions = 50
		else if (istype(J, /datum/job/german/medic_ss))
			J.min_positions = 15
			J.max_positions = 15
			J.total_positions = 15
		else
			. = FALSE
	return .

/obj/map_metadata/chateau/announce_mission_start(var/preparation_time)
	world << "<font size=4>The Germans must defend the Chateau! </font>"

/obj/map_metadata/chateau/reinforcements_ready()
	return (germans_can_cross_blocks() && soviets_can_cross_blocks())

/obj/map_metadata/chateau/short_win_time(faction)
	return 1200

/obj/map_metadata/chateau/long_win_time(faction)
	return 3000

var/no_loop_c = FALSE

/obj/map_metadata/chateau/update_win_condition()
	if (!win_condition_specialcheck())
		return FALSE
	if (world.time >= 36000)
		if (win_condition_spam_check)
			return FALSE
		ticker.finished = TRUE
		var/message = "The <b>SS</b> has sucessfuly defended the Chateau! The Americans halted the attack!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		return FALSE
	if ((current_winner && current_loser && world.time > next_win) && no_loop_c == FALSE)
		ticker.finished = TRUE
		var/message = "The <b>Americans</b> have captured the Chateau! The battle is over!"
		world << "<font size = 4><span class = 'notice'>[message]</span></font>"
		show_global_battle_report(null)
		win_condition_spam_check = TRUE
		no_loop_c = TRUE
		return FALSE
	// German major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Americans have reached the Chateau! They will win in {time} minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// German minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Americans have captured the Chateau! They will win in {time} minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[1][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[2][1])
	// Soviet major
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.33, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.33))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Americans have reached the Chateau!  They will win in {time} minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	// Soviet minor
	else if (win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[1]]), roundend_condition_sides[2], roundend_condition_sides[1], 1.01, TRUE))
		if (!win_condition.check(typesof(roundend_condition_sides[roundend_condition_sides[2]]), roundend_condition_sides[1], roundend_condition_sides[2], 1.01))
			if (last_win_condition != win_condition.hash)
				current_win_condition = "The Americans have reached the Chateau!  They will win in {time} minutes."
				next_win = world.time + short_win_time(SOVIET)
				announce_current_win_condition()
				current_winner = roundend_condition_def2army(roundend_condition_sides[2][1])
				current_loser = roundend_condition_def2army(roundend_condition_sides[1][1])
	else if (win_condition.check(list("REINFORCEMENTS"), list(), list(), 1.0, TRUE))
		if (last_win_condition != win_condition.hash)

			// let us know why we're changing to this win condition
			if (current_win_condition != NO_WINNER && current_winner && current_loser)
				world << "<font size = 3>The <b>SS</b> has recaptured the Chateau!</font>"

			current_win_condition = "Both sides are out of reinforcements; the round will end in {time} minute{s}."

			if (last_reinforcements_next_win != -1)
				next_win = last_reinforcements_next_win
			else
				next_win = world.time + long_win_time(null)
				last_reinforcements_next_win = next_win

			announce_current_win_condition()
			current_winner = null
			current_loser = null
	else
		if (current_win_condition != NO_WINNER && current_winner && current_loser)
			world << "<font size = 3>The <b>SS</b> has recaptured the Chateau!</font>"
			current_winner = null
			current_loser = null
		next_win = -1
		current_win_condition = NO_WINNER
		win_condition.hash = 0
	last_win_condition = win_condition.hash
	return TRUE


	#undef NO_WINNER

