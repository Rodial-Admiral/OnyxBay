/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = TRUE

/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()
	pref.UI_style		= sanitize_inlist(pref.UI_style, all_ui_styles, initial(pref.UI_style))
	pref.UI_style_color	= sanitize_hexcolor(pref.UI_style_color, initial(pref.UI_style_color))
	pref.UI_style_alpha	= sanitize_integer(pref.UI_style_alpha, 0, 255, initial(pref.UI_style_alpha))
	pref.ooccolor		= sanitize_hexcolor(pref.ooccolor, initial(pref.ooccolor))
	pref.lobby_music_volume		= sanitize_integer(pref.ooccolor, 1, 100, initial(pref.ooccolor))

/datum/category_item/player_setup_item/player_global/ui/content(var/mob/user)
	. += "<b>UI Settings</b><br><br>"
	. += "<b>UI Style:</b> <a href='?src=\ref[src];select_style=1'><b>[pref.UI_style]</b></a><br>"
	. += "<b>Custom UI</b>:<br>"
	. += "- Color: <a href='?src=\ref[src];select_color=1'><b>[pref.UI_style_color]</b></a>�<table style='display:inline;' bgcolor='[pref.UI_style_color]'><tr><td>__</td></tr></table>�<a href='?src=\ref[src];reset=ui'>reset</a><br>"
	. += "- Alpha(transparency): <a href='?src=\ref[src];select_alpha=1'><b>[pref.UI_style_alpha]</b></a>�<a href='?src=\ref[src];reset=alpha'>reset</a><br><br>"
	if (can_select_ooc_color(user))
		. += "<b>OOC Color:</b>�"
		if (pref.ooccolor == initial(pref.ooccolor))
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>Using Default</b></a><br><br>"
		else
			. += "<a href='?src=\ref[src];select_ooc_color=1'><b>[pref.ooccolor]</b></a> <table style='display:inline;' bgcolor='[pref.ooccolor]'><tr><td>__</td></tr></table>�<a href='?src=\ref[src];reset=ooc'>reset</a><br>" // only one linebreak needed here
	. += "<b>Lobby Music Volume:</b> <a href='?src=\ref[src];change_lobby_music_volume=1'><b>[pref.lobby_music_volume]%</b></a><br>"
	. += "<b>Scream Type:</b> <a href='?src=\ref[src];change_scream_type=1'><b>[pref.scream_type]</b></a><br>"
	. += "<br>"

/datum/category_item/player_setup_item/player_global/ui/OnTopic(var/href,var/list/href_list, var/mob/user)
	if (href_list["select_style"])
		var/UI_style_new = input(user, "Choose UI style.", "Character Preference", pref.UI_style) as null|anything in all_ui_styles
		if (!UI_style_new || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style = UI_style_new
		return TOPIC_REFRESH

	else if (href_list["select_color"])
		var/UI_style_color_new = input(user, "Choose UI color, dark colors are not recommended!", "Global Preference", pref.UI_style_color) as color|null
		if (isnull(UI_style_color_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_color = UI_style_color_new
		return TOPIC_REFRESH

	else if (href_list["select_alpha"])
		var/UI_style_alpha_new = input(user, "Select UI alpha (transparency) level, between 50 and 255.", "Global Preference", pref.UI_style_alpha) as num|null
		if (isnull(UI_style_alpha_new) || (UI_style_alpha_new < 50 || UI_style_alpha_new > 255) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_alpha = UI_style_alpha_new
		return TOPIC_REFRESH

	else if (href_list["select_ooc_color"])
		var/new_ooccolor = input(user, "Choose OOC color:", "Global Preference") as color|null
		if (new_ooccolor && can_select_ooc_color(user) && CanUseTopic(user))
			pref.ooccolor = new_ooccolor
			return TOPIC_REFRESH

	else if (href_list["change_lobby_music_volume"])
		pref.lobby_music_volume = input(user, "Select a new volume (1 - 100)", "Lobby Music Volume", pref.lobby_music_volume) as num
		pref.lobby_music_volume = Clamp(pref.lobby_music_volume, 1, 100)
		if (pref.client)
			pref.client.onload_preferences("SOUND_LOBBY")
		return TOPIC_REFRESH

	else if (href_list["change_scream_type"])
		var/input_ = input(user, "Select new scream type.", "SCREAM!!!") in list("1", "2")
		switch(input_)
			if("1")
				pref.scream_type = 1
			if("2")
				pref.scream_type = 2
		return TOPIC_REFRESH


	else if (href_list["reset"])
		switch(href_list["reset"])
			if ("ui")
				pref.UI_style_color = initial(pref.UI_style_color)
			if ("alpha")
				pref.UI_style_alpha = initial(pref.UI_style_alpha)
			if ("ooc")
				pref.ooccolor = initial(pref.ooccolor)
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/player_global/ui/proc/can_select_ooc_color(var/mob/user)
	return ((config.allow_admin_ooccolor && check_rights(R_ADMIN, FALSE, user)) || (user.client && user.client.isPatron("$3+")))
