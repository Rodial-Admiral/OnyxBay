//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/FUCKYOU = FALSE

/proc/job2mobtype(rank)
	for (var/datum/job/J in job_master.occupations)
		if (J.title == rank)
			if (istype(J, /datum/job/pillarman/pillarman))
				return /mob/living/carbon/human/pillarman
			else if (istype(J, /datum/job/pillarman/vampire))
				return /mob/living/carbon/human/vampire
			else
				return /mob/living/carbon/human

/mob/new_player
	var/ready = FALSE
	var/spawning = FALSE//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	var/desired_job = null // job title. This is for join queues.
	var/datum/job/delayed_spawning_as_job = null // job title. Self explanatory.
	universal_speak = TRUE

	invisibility = 101

	density = FALSE
	stat = 2
	canmove = FALSE

	anchored = TRUE	//  don't get pushed around

	var/on_welcome_popup = FALSE


/mob/new_player/New()
	mob_list += src
	new_player_mob_list += src

	spawn (1)
		if (client)
			client.remove_ghost_only_admin_verbs()

	spawn (10)
		if (client)
			movementMachine_clients -= client

proc/AutoBalanceRepair()
	FUCKYOU = TRUE

/mob/new_player/Destroy()
	..()
	new_player_mob_list -= src

/mob/new_player/say(var/message)
	return

/mob/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()

/mob/new_player/proc/new_player_panel_proc()
	loc = null // so sometimes when people serverswap (tm) they get this window despite not being on the title screen - Kachnov
	// don't know if the above actually works

	var/output_stylized = {"
	<br>
	<html>
	<head>
	<style>
	[common_browser_style]
	</style>
	</head>
	<body><center>
	PLACEHOLDER
	</body></html>
	"}

	var/output = "<div align='center'><b>Welcome, [key]!</b>"
	output +="<hr>"
	output += "<p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character & Preferences</A></p>"

	if (!ticker || ticker.current_state <= GAME_STATE_PREGAME)
		output += "<p><a href='byond://?src=\ref[src];ready=0'>The game has not started yet.</a></p>"
	else
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</a></p>"

	var/height = 300
	if (reinforcements_master && reinforcements_master.is_ready() && client && !client.quickBan_isbanned("Penal"))
		height = 350
		if (!reinforcements_master.has(src))
			output += "<p><a href='byond://?src=\ref[src];re_german=1'>Join as an Axis reinforcement!</A></p>"
			output += "<p><a href='byond://?src=\ref[src];re_russian=1'>Join as an Allied reinforcement!</A></p>"
		else
			if (reinforcements_master.has(src, GERMAN))
				output += "<p><a href='byond://?src=\ref[src];unre_german=1'>Leave the Axis reinforcement pool.</A></p>"
			else if (reinforcements_master.has(src, SOVIET))
				output += "<p><a href='byond://?src=\ref[src];unre_russian=1'>Leave the Allies reinforcement pool.</A></p>"
	else
		output += "<p><i>Reinforcements are not available yet.</i></p>"

	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

	output += "</div>"

	src << browse(null, "window=playersetup;")
	src << browse(replacetext(output_stylized, "PLACEHOLDER", output), "window=playersetup;size=275x[height];can_close=0;can_resize=0")
	return

/mob/new_player/Stat()

	if (client.status_tabs && statpanel("Status") && ticker)
		stat("")
		stat(stat_header("Lobby"))
		stat("")

		// by counting observers, our playercount now looks more impressive - Kachnov
		if (ticker.current_state == GAME_STATE_PREGAME)
			stat("Time Until Joining Allowed:", "[ticker.pregame_timeleft][round_progressing ? "" : " (DELAYED)"]")

		stat("Players in lobby:", totalPlayers)
		stat("")
		stat("")

		totalPlayers = 0

		for (var/player in new_player_mob_list)
			if (reinforcements_master)
				if (reinforcements_master.reinforcement_pool[GERMAN]:Find(player))
					stat("[player:key] - joining as Axis")
				else if (reinforcements_master.reinforcement_pool[SOVIET]:Find(player))
					stat("[player:key] - joining as Allies")
				else
					stat(player:key)
			else
				stat(player:key)
			++totalPlayers

		stat("")

	if (reinforcements_master && reinforcements_master.is_ready())
		stat("")
		stat(stat_header("Reinforcements"))
		stat("")
		var/list/reinforcements_info = reinforcements_master.get_status_addendums()
		for (var/v in reinforcements_info)
			if (findtext(v, ":")) // because apparently splittext doesn't work how I thought it did, this failed when we didn't have a ":" anywhere
				var/split = splittext(v, ":")
				if (split[2])
					stat(split[1], split[2])
				else
					stat(split[1])
			else if (findtext(v, ";"))
				var/split = splittext(v, ";")
				if (split[2])
					stat("[split[1]];", split[2])
				else
					stat(split[1])
			else
				stat(v, "")
	..()


/mob/new_player/Topic(href, href_list[])
	if (!client)	return FALSE

	if (href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return TRUE

	if (href_list["ready"])
		if (!ticker || ticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			ready = text2num(href_list["ready"])
		else
			ready = FALSE

	if (href_list["refresh"])
		src << browse(null, "window=playersetup") //closes the player setup window
		new_player_panel_proc()

	if (href_list["observe"])

		if (client && client.quickBan_isbanned("Observe"))
			src << "<span class = 'danger'>You're banned from observing.</span>"
			return TRUE

		if (WWinput(src, "Are you sure you wish to observe?", "Player Setup", "Yes", list("Yes","No")) == "Yes")
			if (!client)	return TRUE
			var/mob/observer/ghost/observer = new(150, 317, 1)

			spawning = TRUE
			src << sound(null, repeat = FALSE, wait = FALSE, volume = 85, channel = TRUE) // MAD JAMS cant last forever yo

			observer.started_as_observer = TRUE
			close_spawn_windows()
			var/obj/O = locate("landmark*Observer-Start")
			if (istype(O))
				src << "<span class='notice'>Now teleporting.</span>"
				observer.loc = O.loc
			else
				src << "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the station map.</span>"
			observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

			announce_ghost_joinleave(src)
			client.prefs.update_preview_icons()

			if (client.prefs.preview_icons.len)
				observer.icon = client.prefs.preview_icons[1]

			observer.alpha = 127

			if (client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.gender)

			observer.real_name = capitalize(key)
			observer.name = observer.real_name
		//	if (!client.holder && !config.antag_hud_allowed)           // For new ghosts we remove the verb from even showing up if it's not allowed.
				//observer.verbs -= /mob/observer/ghost/verb/toggle_antagHUD        // Poor guys, don't know what they are missing!
			observer.key = key
			observer.overlays += icon('icons/mob/uniform.dmi', "civuni[rand(1,3)]")
			observer.original_icon = observer.icon
			observer.original_overlays = list(icon('icons/mob/uniform.dmi', "civuni[rand(1,3)]"))
			qdel(src)

			return TRUE

	if (href_list["re_german"])

		if (client && client.quickBan_isbanned("Playing"))
			src << "<span class = 'danger'>You're banned from playing.</span>"
			return TRUE

		if (!ticker.players_can_join)
			src << "<span class = 'danger'>You can't join the game yet.</span>"
			return TRUE

		if (!reinforcements_master.is_permalocked(GERMAN))
			if (client.prefs.s_tone < -30)
				usr << "<span class='danger'>You are too dark to be a German soldier.</span>"
				return
			if (client.prefs.german_gender == FEMALE)
				usr << "<span class='danger'>German soldiers must be male.</span>"
				return
			reinforcements_master.add(src, GERMAN)
		else
			src << "<span class = 'danger'>Sorry, this side already has too many reinforcements deployed!</span>"
	if (href_list["re_russian"])

		if (client && client.quickBan_isbanned("Playing"))
			src << "<span class = 'danger'>You're banned from playing.</span>"
			return TRUE

		if (!ticker.players_can_join)
			src << "<span class = 'danger'>You can't join the game yet.</span>"
			return TRUE

		if (!reinforcements_master.is_permalocked(SOVIET))
			reinforcements_master.add(src, SOVIET)
		else
			src << "<span class = 'danger'>Sorry, this side already has too many reinforcements deployed!</span>"
	if (href_list["unre_german"])
		reinforcements_master.remove(src, GERMAN)
	if (href_list["unre_russian"])
		reinforcements_master.remove(src, SOVIET)

	if (href_list["late_join"])

		if (client && client.quickBan_isbanned("Playing"))
			src << "<span class = 'danger'>You're banned from playing.</span>"
			return TRUE

		if (!ticker.players_can_join)
			src << "<span class = 'danger'>You can't join the game yet.</span>"
			return TRUE

		if (!ticker || ticker.current_state != GAME_STATE_PLAYING)
			src << "<span class = 'red'>The round is either not ready, or has already finished.</span>"
			return
		if (client)
			if (client.next_normal_respawn > world.realtime && !config.no_respawn_delays)
				var/wait = ceil((client.next_normal_respawn-world.realtime)/600)
				if (check_rights(R_ADMIN, FALSE, src))
					if ((WWinput(src, "If you were a normal player, you would have to wait [wait] more minutes to respawn. Do you want to bypass this? You can still join as a reinforcement.", "Admin Respawn", "Yes", list("Yes", "No"))) == "Yes")
						var/msg = "[key_name(src)] bypassed a [wait] minute wait to respawn."
						log_admin(msg)
						message_admins(msg)
						LateChoices()
						return TRUE
				WWalert(src, "Because you died in combat, you must wait [wait] more minutes to respawn. You can still join as a reinforcement.", "Error")
				return FALSE
		LateChoices()
		return TRUE


	if (href_list["SelectedJob"])

		var/datum/job/actual_job = null

		for (var/datum/job/j in job_master.occupations)
			if (j.title == href_list["SelectedJob"])
				actual_job = j
				break

		if (!actual_job)
			return

		var/job_flag = actual_job.base_type_flag()

		if (job_flag == GERMAN || job_flag == SOVIET)
			// we're only accepting squad leaders right now
			if (!job_master.squad_leader_check(src, actual_job))
				return
			// we aren't accepting squad leaders right now
			if (!job_master.squad_member_check(src, actual_job))
				return

		if (job_flag == GERMAN)
			if (client.prefs.s_tone < -30)
				usr << "<span class='danger'>You are too dark to be a German soldier.</span>"
				return
			if (client.prefs.german_gender == FEMALE && !actual_job.is_nonmilitary)
				usr << "<span class='danger'>German soldiers must be male.</span>"
				return
		else if (job_flag == SOVIET)
			if (client.prefs.russian_gender == FEMALE && actual_job.is_officer)
				usr << "<span class='danger'>Soviet officers must be male.</span>"
				return

		if (!config.enter_allowed)
			usr << "<span class='notice'>There is an administrative lock on entering the game!</span>"
			return

		if (map && map.has_occupied_base(job_flag))
			usr << "<span class = 'danger'>The enemy is currently occupying your base! You can't be deployed right now."
			return

		if (actual_job.is_officer)
			if ((input(src, "This is an officer position. Are you sure you want to join in as a [actual_job.title]?") in list("Yes", "No")) == "No")
				return

		if (actual_job.spawn_delay)

			if (delayed_spawning_as_job)
				delayed_spawning_as_job.total_positions += 1
				delayed_spawning_as_job = null

			job_master.spawn_with_delay(src, actual_job)
		else
			AttemptLateSpawn(href_list["SelectedJob"])

	if (!ready && href_list["preference"])
		if (client)
			client.prefs.process_link(src, href_list)
	else if (!href_list["late_join"])
		new_player_panel()

/mob/new_player/proc/IsJobAvailable(rank, var/list/restricted_choices = list())
	var/datum/job/job = job_master.GetJob(rank)
	if (!job)	return FALSE
	if (!job.is_position_available(restricted_choices)) return FALSE
//	if (!job.player_old_enough(client))	return FALSE
	return TRUE

/mob/new_player/proc/jobBanned(title)
	if (client && client.quickBan_isbanned("Job", title))
		return TRUE
	return FALSE

/mob/new_player/proc/factionBanned(faction)
	if (client && client.quickBan_isbanned("Faction", faction))
		return TRUE
	return FALSE

/mob/new_player/proc/officerBanned()
	if (client && client.quickBan_isbanned("Officer"))
		return TRUE
	return FALSE

//if the player is "Penal banned", he is reduced to play as a member of a penal battalion
/mob/new_player/proc/penalBanned()
	if (client && client.quickBan_isbanned("Penal"))
		return TRUE
	return FALSE

/mob/new_player/proc/LateSpawnForced(rank, needs_random_name = FALSE, var/reinforcements = FALSE)

	if(spawning)
		return
	spawning = TRUE
	close_spawn_windows()

	var/list/special_reinforcement_choices = list() //Stuff for special reinforcement types.
	var/list/special_reinforcement_list = list()

	if(rank == "Soldat")
		special_reinforcement_list = processes.supply.german_special_reinforcements
	else if(rank == "Sovietsky Soldat")
		special_reinforcement_list = processes.supply.soviet_special_reinforcements

	for(var/special_reinforcement in special_reinforcement_list)
		if(special_reinforcement_list[special_reinforcement] > 0)
			special_reinforcement_choices += special_reinforcement
	special_reinforcement_choices += rank

	if(special_reinforcement_choices.len > 1)
		var/chosen_special_reinforcement = WWinput(src, "You have the potential for special reinforcement. Choose your unit type.", "Special Reinforcement", rank, special_reinforcement_choices)
		if(chosen_special_reinforcement != rank)
			if(rank == "Soldat")
				switch(chosen_special_reinforcement)
					if("Medic")
						rank = "Sanit�ter"
					if("Engineer")
						rank = "Pionier"
					if("Sniper")
						rank = "Scharfsch�tze"
					if("Anti-Tank Soldier")
						rank = "Panzer-Soldat"
					if("Flamethrower Soldier")
						rank = "Flammenwerfersoldat"
					if("Machinegunner")
						rank = "Maschinengewehrsch�tze"
				processes.supply.german_special_reinforcements[chosen_special_reinforcement] -= 1
			if(rank == "Sovietsky Soldat")
				switch(chosen_special_reinforcement)
					if("Medic")
						rank = "Sanitar"
					if("Engineer")
						rank = "Boyevoy Saper"
					if("Sniper")
						rank = "Snaiper"
					if("Anti-Tank Soldier")
						rank = "Protivotankovyy Soldat"
					if("Machinegunner")
						rank = "Pulemetchik"
				processes.supply.soviet_special_reinforcements[chosen_special_reinforcement] -= 1

	job_master.AssignRole(src, rank, TRUE, reinforcements)
	var/mob/living/character = create_character(job2mobtype(rank))	//creates the human and transfers vars and mind
	character = job_master.EquipRank(character, rank, TRUE)					//equips the human

	job_master.relocate(character)

	if (character.buckled && istype(character.buckled, /obj/structure/bed/chair/wheelchair))
		character.buckled.loc = character.loc
		character.buckled.set_dir(character.dir)

	if (character.mind.assigned_role != "Cyborg")
	//	data_core.manifest_inject(character)
		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

	character.lastarea = get_area(loc)

	qdel(src)

/mob/new_player/proc/AttemptLateSpawn(rank, var/nomsg = FALSE)

	if (src != usr)
		return FALSE
	if (!ticker || ticker.current_state != GAME_STATE_PLAYING)
		if (!nomsg)
			usr << "<span class = 'red'>The round is either not ready, or has already finished.</span>"
		return FALSE
	if (!config.enter_allowed)
		if (!nomsg)
			usr << "<span class='notice'>There is an administrative lock on entering the game!</span>"
		return FALSE
	if (jobBanned(rank))
		if (!nomsg)
			usr << "<span class = 'warning'>You're banned from this role!</span>"
		return FALSE
	if (!IsJobAvailable(rank))
		if (!nomsg)
			WWalert(src, "'[rank]' has already been taken by someone else.", "Error")
		return FALSE

	var/datum/job/job = job_master.GetJob(rank)

	if (factionBanned(job.base_type_flag(1)))
		if (!nomsg)
			usr << "<span class = 'warning'>You're banned from this faction!</span>"
		return FALSE

	if (officerBanned() && job.is_officer)
		if (!nomsg)
			usr << "<span class = 'warning'>You're banned from officer positions!</span>"
		return FALSE

	if (penalBanned())
		if (job.blacklisted == FALSE)
			if (!nomsg)
				usr << "<span class = 'warning'>You're under a Penal Battalion ban, you can only play as that role!</span>"
			return FALSE

	else
		if (job.blacklisted == TRUE)
			if (!nomsg)
				usr << "<span class = 'warning'>This job is reserved as a punishment for those who break server rules.</span>"
			return FALSE

	if (job_master.is_side_locked(job.base_type_flag()))
		if (!nomsg)
			src << "<span class = 'red'>Currently this side is locked for joining.</span>"
		return

	if (job.is_paratrooper && !paratroopers_forceEnabled)
		if (map && map.germans_can_cross_blocks() && map.soviets_can_cross_blocks())
			src << "<span class = 'red'>This job is not available for joining after the grace period has ended.</span>"
			return

	spawning = TRUE
	close_spawn_windows()
	job_master.AssignRole(src, rank, TRUE)
	var/mob/living/character = create_character(job2mobtype(rank))	//creates the human and transfers vars and mind
	if (!character)
		return FALSE

	character = job_master.EquipRank(character, rank, TRUE)					//equips the human
	job_master.relocate(character)

	if (character.buckled && istype(character.buckled, /obj/structure/bed/chair/wheelchair))
		character.buckled.loc = character.loc
		character.buckled.set_dir(character.dir)

	if (character.mind && character.mind.assigned_role != "Cyborg")
	//	data_core.manifest_inject(character)
		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

	character.lastarea = get_area(loc)

	if (character.original_job)
		if (character.original_job.base_type_flag() == SOVIET)
			var/obj/item/radio/R = main_radios[SOVIET]
			if (R && R.loc)
				R.announce_after("[character.real_name], [rank], has arrived.", "Arrivals Announcements", 10)
		else if (character.original_job.base_type_flag() == GERMAN)
			var/obj/item/radio/R = main_radios[GERMAN]
			if (R && R.loc)
				R.announce_after("[character.real_name], [rank], has arrived.", "Arrivals Announcements", 10)

	return TRUE

/mob/new_player/proc/LateChoices()

	src << browse(null, "window=latechoices")

	//<body style='background-color:#1D2951; color:#ffffff'>
	var/list/dat = list("<center>")
	dat += "<b><big>Welcome, [key].</big></b>"
	dat += "<br>"
	dat += "Round Duration: [roundduration2text()]"
	dat += "<br>"
	dat += "<b>Current Autobalance Status</b>: [alive_germans.len] Germans, [alive_italians.len] Italians, [alive_russians.len] Soviets, [alive_partisans.len+alive_polish.len] Partisans, [alive_civilians.len] Civilians, [alive_usa.len] Americans, [alive_japan.len] Japanese."
	dat += "<br>"
	dat += "<i>Jobs available for Penal banned players are marked with an *</i>"
	dat += "<br>"

//	var/list/restricted_choices = list()

	var/list/available_jobs_per_side = list(
		GERMAN = FALSE,
		SOVIET = FALSE,
		PARTISAN = FALSE,
		CIVILIAN = FALSE,
		ITALIAN = FALSE,
		UKRAINIAN = FALSE,
		PILLARMEN = FALSE,
		POLISH_INSURGENTS = FALSE,
		USA = FALSE,
		JAPAN = FALSE)

	var/prev_side = FALSE

	dat += "<b>Choose from the following open positions:</b>"

	for (var/datum/job/job in job_master.faction_organized_occupations)

		if (job.faction != "Station")
			continue

		if (job.title == "generic job")
			continue

		if (map && !map.faction_organization.Find(job.base_type_flag()))
			continue

		if (!job.specialcheck())
			continue

		if (job && !job.train_check())
			continue

		var/job_is_available = job && IsJobAvailable(job.title)

		if (!job.validate(src))
			job_is_available = FALSE

		//	unavailable_message = " <span class = 'color: rgb(255,215,0);'>{WHITELISTED}</span> "

		if (job_master.side_is_hardlocked(job.base_type_flag()))
			job_is_available = FALSE

		if (job_master.is_side_locked(job.base_type_flag()))
			job_is_available = FALSE

		//	unavailable_message = " <span class = 'color: rgb(255,215,0);'>{DISABLED BY AUTOBALANCE}</span> "

	//	if (jobBanned(job.title))
	//		job_is_available = FALSE
		//	unavailable_message = " <span class = 'color: rgb(255,0,0);'>{BANNED}</span> "

	//	if (factionBanned(job.base_type_flag(1)))
		//	job_is_available = FALSE
		//	unavailable_message = " <span class = 'color: rgb(255,0,0);'>{BANNED FROM FACTION}</span> "

	//	if (officerBanned() && job.is_officer)
		//	job_is_available = FALSE
		//	unavailable_message = " <span class = 'color: rgb(255,0,0);'>{BANNED FROM OFFICER POSITIONS}</span> "

		// check if the faction is admin-locked

		if (map && !map.job_enabled_specialcheck(job))
			job_is_available = FALSE

		if (istype(job, /datum/job/german/paratrooper) && !paratroopers_toggled)
			job_is_available = FALSE

		if ((istype(job, /datum/job/german/soldier_ss) || istype(job, /datum/job/german/squad_leader_ss)) && !SS_toggled)
			job_is_available = FALSE

		if (istype(job, /datum/job/partisan) && !istype(job, /datum/job/partisan/civilian) && !partisans_toggled)
			job_is_available = FALSE

		if (istype(job, /datum/job/partisan/civilian) && !civilians_toggled)
			job_is_available = FALSE

		if (istype(job, /datum/job/german) && !job.is_SS && !germans_toggled)
			job_is_available = FALSE

		if (istype(job, /datum/job/soviet) && !soviets_toggled)
			job_is_available = FALSE

		// check if the job is admin-locked or disabled codewise

		if (!job.enabled)
			job_is_available = FALSE

		// check if the job is autobalance-locked

		if (job)
			var/active = processes.job_data.get_active_positions(job)
			if (job.base_type_flag() != prev_side)
				prev_side = job.base_type_flag()
				var/side_name = "<b><h1><big>[job.get_side_name()]</big></h1></b>&&[job.base_type_flag()]&&"
				if (side_name)
					dat += "<br><br>[side_name]<br>"

			var/extra_span = ""
			var/end_extra_span = ""

			if (job.is_officer && !job.is_commander)
				extra_span = "<h3>"
				end_extra_span = "</h3>"
			else if (job.is_commander)
				extra_span = "<h2>"
				end_extra_span = "</h2>"

			if (!job.en_meaning)
				if (job_is_available)
					dat += "&[job.base_type_flag()]&[extra_span]<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions]/[job.total_positions]) (Active: [active])</a>[end_extra_span]"
					++available_jobs_per_side[job.base_type_flag()]
			/*	else
					dat += "&[job.base_type_flag()]&[unavailable_message]<span style = 'color:red'><strike>[job.title] ([job.current_positions]/[job.total_positions]) (Active: [active])</strike></span><br>"
				*/
			else
				if (job_is_available)
					dat += "&[job.base_type_flag()]&[extra_span]<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.en_meaning]) ([job.current_positions]/[job.total_positions]) (Active: [active])</a>[end_extra_span]"
					++available_jobs_per_side[job.base_type_flag()]
		/*		else
					dat += "&[job.base_type_flag()]&[unavailable_message]<span style = 'color:red'><strike>[job.title] ([job.en_meaning]) ([job.current_positions]/[job.total_positions]) (Active: [active])</strike></span><br>"
				*/

	dat += "</center>"

	// shitcode to hide jobs that aren't available
	var/any_available_jobs = FALSE
	for (var/key in available_jobs_per_side)
		var/val = available_jobs_per_side[key]
		if (val == 0)
			var/replaced_faction_title = FALSE
			for (var/v in 1 to dat.len)
				if (findtext(dat[v], "&[key]&") && !findtext(dat[v], "&&[key]&&"))
					dat[v] = null
				else if (!replaced_faction_title && findtext(dat[v], "&&[key]&&"))
					dat[v] = "[replacetext(dat[v], "&&[key]&&", "")] (<span style = 'color:red'>FACTION DISABLED BY AUTOBALANCE</span>)"
					replaced_faction_title = TRUE
		else
			any_available_jobs = TRUE
			var/replaced_faction_title = FALSE
			for (var/v in TRUE to dat.len)
				if (findtext(dat[v], "&[key]&") && !findtext(dat[v], "&&[key]&&"))
					dat[v] = replacetext(dat[v], "&[key]&", "")
				else if (!replaced_faction_title && findtext(dat[v], "&&[key]&&"))
					dat[v] = replacetext(dat[v], "&&[key]&&", "")
					replaced_faction_title = TRUE

	if (!any_available_jobs && !FUCKYOU)
		src << "<span class = 'danger'><font size = 3>All roles are disabled by autobalance! Please join a reinforcements queue to play.</font></span>"
		return

	var/data = ""
	for (var/line in dat)
		if (line != null)
			if (line != "<br>")
				data += "<span style = 'font-size:2.0rem;'>[line]</span>"
			data += "<br>"

	//<link rel='stylesheet' type='text/css' href='html/browser/common.css'>
	data = {"
		<br>
		<html>
		<head>
		<style>
		[common_browser_style]
		</style>
		</head>
		<body>
		[data]
		</body>
		</html>
		<br>
	"}

	spawn (1)
		src << browse(data, "window=latechoices;size=600x640;can_close=1")

/mob/new_player/proc/create_character(mobtype)


	if (delayed_spawning_as_job)
		delayed_spawning_as_job.total_positions += 1
		delayed_spawning_as_job = null

	spawning = TRUE
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/use_species_name
	var/datum/species/chosen_species
	if (client && client.prefs.species)
		chosen_species = all_species[client.prefs.species]
		use_species_name = chosen_species.get_station_variant() //Only used by pariahs atm.

	if (chosen_species && use_species_name)
		// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
		if (is_species_whitelisted(chosen_species) || has_admin_rights())
			new_character = new mobtype(loc, use_species_name)

	if (!new_character)
		new_character = new mobtype(loc)

	new_character.stopDumbDamage = TRUE
	new_character.lastarea = get_area(loc)

	if (client)
		for (var/lang in client.prefs.alternate_languages)
			var/datum/language/chosen_language = all_languages[lang]
			if (chosen_language)
				if (has_admin_rights() \
					|| (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
					new_character.add_language(lang)

		if (ticker.random_players)
			new_character.gender = pick(MALE, FEMALE)
			client.prefs.real_name = random_name(new_character.gender)
			client.prefs.randomize_appearance_for (new_character)
		else
			// no more traps - Kachnov
			var/client_prefs_original_gender = client.prefs.gender

			// traps came back, this should fix them for good - Kachnov
			new_character.gender = client.prefs.gender
			client.prefs.copy_to(new_character)
			client.prefs.gender = client_prefs_original_gender

	src << sound(null, repeat = FALSE, wait = FALSE, volume = 85, channel = TRUE) // MAD JAMS cant last forever yo

	if (mind)
		mind.active = FALSE					//we wish to transfer the key manually
		mind.original = new_character
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.original_job = original_job
	new_character.name = real_name
	new_character.dna.ready_dna(new_character)

	if (client)
		new_character.dna.b_type = client.prefs.b_type

	new_character.sync_organ_dna()

	if (client && client.prefs.disabilities)
		// Set defer to TRUE if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLASSESBLOCK,1,0)
		new_character.disabilities |= NEARSIGHTED

	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()
	new_character.key = key		//Manually transfer the key to log them in

	return new_character
/*
/mob/new_player/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4>Show Crew Manifest</h4>"
	dat += data_core.get_manifest(OOC = TRUE)
	src << browse(dat, "window=manifest;size=370x420;can_close=1")
*/
/mob/new_player/Move()
	return FALSE

/mob/new_player/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window

/mob/new_player/proc/has_admin_rights()
	return check_rights(R_ADMIN, FALSE, src)

/mob/new_player/proc/is_species_whitelisted(datum/species/S)
	return FALSE

/mob/new_player/get_species()
	var/datum/species/chosen_species
	if (client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if (!chosen_species)
		return "Human"

	if (is_species_whitelisted(chosen_species) || has_admin_rights())
		return chosen_species.name

	return "Human"

/mob/new_player/get_gender()
	if (!client || !client.prefs)
		return ..()
	return client.prefs.gender

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = FALSE, var/mob/speaker = null)
	return

/mob/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = FALSE)
	return

/mob/new_player/MayRespawn()
	return TRUE

/mob/new_player/verb/see_battle_report()
	set category = "OOC"
	set name = "See Battle Report"
	show_global_battle_report(src, TRUE)