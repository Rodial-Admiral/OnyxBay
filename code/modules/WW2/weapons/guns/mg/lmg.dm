/obj/item/weapon/gun/projectile/automatic
	force = 15
	throwforce = 30
	// not accurate at all
	accuracy_list = list(

		// small body parts: head, hand, feet
		"small" = list(
			SHORT_RANGE_STILL = 30,
			SHORT_RANGE_MOVING = 27,

			MEDIUM_RANGE_STILL = 21,
			MEDIUM_RANGE_MOVING = 19,

			LONG_RANGE_STILL = 11,
			LONG_RANGE_MOVING = 10,

			VERY_LONG_RANGE_STILL = 8,
			VERY_LONG_RANGE_MOVING = 7),

		// medium body parts: limbs
		"medium" = list(
			SHORT_RANGE_STILL = 38,
			SHORT_RANGE_MOVING = 34,

			MEDIUM_RANGE_STILL = 30,
			MEDIUM_RANGE_MOVING = 27,

			LONG_RANGE_STILL = 23,
			LONG_RANGE_MOVING = 21,

			VERY_LONG_RANGE_STILL = 11,
			VERY_LONG_RANGE_MOVING = 10),

		// large body parts: chest, groin
		"large" = list(
			SHORT_RANGE_STILL = 45,
			SHORT_RANGE_MOVING = 41,

			MEDIUM_RANGE_STILL = 38,
			MEDIUM_RANGE_MOVING = 34,

			LONG_RANGE_STILL = 30,
			LONG_RANGE_MOVING = 27,

			VERY_LONG_RANGE_STILL = 15,
			VERY_LONG_RANGE_MOVING = 14),
	)

	accuracy_increase_mod = 2.00
	accuracy_decrease_mod = 6.00
	KD_chance = KD_CHANCE_VERY_LOW
	stat = "MG"
	full_auto = TRUE
	handle_casings = EJECT_CASINGS

/obj/item/weapon/gun/projectile/automatic/dp
	name = "DP-28"
	desc = "Soviet light machine gun with a odd disk-shaped magazine on top. Chambered in 7.62x54mmR, in 41 round magazines."
	icon_state = "dp"
	item_state = "dp"
	load_method = MAGAZINE
	w_class = 5
	heavy = TRUE
	caliber = "a762x39"
	magazine_type = /obj/item/ammo_magazine/a762/dp
	weight = 9.12
	slot_flags = SLOT_BACK

	firemodes = list(
		list(name="full auto",	burst=1, burst_delay=1.2, recoil=1.5, move_delay=8, dispersion = list(1.2, 1.4, 1.4, 1.4, 1.6)),
		)

	sel_mode = 1
	force = 20
	throwforce = 30

/obj/item/weapon/gun/projectile/automatic/dp/update_icon()
	if (ammo_magazine)
		icon_state = "dp"
	/*	if (wielded)
			item_state = "dp-w"
		else
			item_state = "dp"*/
	else
		icon_state = "dp0"
	/*	if (wielded)
			item_state = "dp-w"
		else
			item_state = "dp0"*/
	update_held_icon()
	return

/obj/item/weapon/gun/projectile/automatic/bren
	name = "Bren light machine gun"
	desc = "The Bren gun, usually called simply the Bren, are a series of light machine guns (LMG) made by Britain in the 1930s and used in various roles until 1992."
	icon_state = "bren"
	item_state = "bren"
	load_method = MAGAZINE
	w_class = 5
	heavy = TRUE
	caliber = ".303"
	magazine_type = /obj/item/ammo_magazine/bren
	weight = 9.12
	slot_flags = SLOT_BACK

	firemodes = list(
		list(name="full auto",	burst=1, burst_delay=1.2, recoil=1.3, move_delay=6, dispersion = list(1.1, 1.2, 1.3, 1.4, 1.5)),
		)

	sel_mode = 1
	force = 20
	throwforce = 30

/obj/item/weapon/gun/projectile/automatic/bren/update_icon()
	if (ammo_magazine)
		icon_state = "bren"
	/*	if (wielded)
			item_state = "dp-w"
		else
			item_state = "dp"*/
	else
		icon_state = "bren0"
	/*	if (wielded)
			item_state = "dp-w"
		else
			item_state = "dp0"*/
	update_held_icon()
	return
/obj/item/weapon/gun/projectile/automatic/zb30
	name = "ZB vz. 30"
	desc = "ZB-30 and ZB-30J are Czechoslovakian light machine guns."
	icon_state = "zb30"
	item_state = "zb30"
	load_method = MAGAZINE
	w_class = 5
	heavy = TRUE
	caliber = "7.92x57mm"
	magazine_type = /obj/item/ammo_magazine/c792x57_fg42
	weight = 9.12
	slot_flags = SLOT_BACK

	firemodes = list(
		list(name="full auto",	burst=1, burst_delay=1.2, recoil=6, move_delay=2, dispersion = list(0.8, 1.0, 1.2, 1.4, 1.6)),
		)

	sel_mode = 1
	force = 20
	throwforce = 30

/obj/item/weapon/gun/projectile/automatic/zb30/update_icon()
	if (ammo_magazine)
		icon_state = "zb30"
	/*	if (wielded)
			item_state = "dp-w"
		else
			item_state = "dp"*/
	else
		icon_state = "zb300"
	/*	if (wielded)
			item_state = "dp-w"
		else
			item_state = "dp0"*/
	update_held_icon()
	return

/obj/item/weapon/gun/projectile/automatic/mg34
	name = "MG-34"
	desc = "German light machinegun chambered in 7.92x57mm Mauser. An utterly devastating support weapon."
	icon_state = "l6closed100"
	item_state = "l6closedmag"
	w_class = 5
	heavy = TRUE
	max_shells = 50
	caliber = "a792x57"
	weight = 12.1
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a792x57_weaker
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a792
	bad_magazine_types = list(/obj/item/ammo_magazine/maxim/mg34_belt)
	unload_sound 	= 'sound/weapons/guns/interact/lmg_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/lmg_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/lmg_cock.ogg'
	fire_sound = 'sound/weapons/guns/fire/mg34_firing.ogg'
	requires_two_hands = FALSE
	wielded_icon = "assault-wielded"

	firemodes = list(
		list(name="full auto",	burst=1, burst_delay=1.2, recoil=1.5, move_delay=8, dispersion = list(1.2, 1.4, 1.5, 1.6, 1.7)),
	)

	fire_delay = 3
	force = 20
	throwforce = 30
	var/cover_open = FALSE

/obj/item/weapon/gun/projectile/automatic/mg34/special_check(mob/user)
	if (cover_open)
		user << "<span class='warning'>[src]'s cover is open! Close it before firing!</span>"
		return FALSE
	return ..()

/obj/item/weapon/gun/projectile/automatic/mg34/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	user << "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>"
	update_icon()

/obj/item/weapon/gun/projectile/automatic/mg34/attack_self(mob/user as mob)
	if (cover_open)
		toggle_cover(user) //close the cover
		playsound(loc, 'sound/weapons/guns/interact/lmg_close.ogg', 100, TRUE)
	else
		return ..() //once closed, behave like normal

/obj/item/weapon/gun/projectile/automatic/mg34/attack_hand(mob/user as mob)
	if (!cover_open && user.get_inactive_hand() == src)
		toggle_cover(user) //open the cover
		playsound(loc, 'sound/weapons/guns/interact/lmg_open.ogg', 100, TRUE)
	else
		return ..() //once open, behave like normal

/obj/item/weapon/gun/projectile/automatic/mg34/update_icon()
	icon_state = "l6[cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len, 25) : "-empty"]"

/obj/item/weapon/gun/projectile/automatic/mg34/load_ammo(var/obj/item/A, mob/user)
	if (!cover_open)
		user << "<span class='warning'>You need to open the cover to load [src].</span>"
		return
	..()

/obj/item/weapon/gun/projectile/automatic/mg34/unload_ammo(mob/user, var/allow_dump=1)
	if (!cover_open)
		user << "<span class='warning'>You need to open the cover to unload [src].</span>"
		return
	..()