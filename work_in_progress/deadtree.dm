/obj/structure/wildtree
	icon = 'icons/obj/deadtrees.dmi'
	anchored = TRUE
	var/sways = FALSE
/*
/obj/structure/wild/New()
	..()*/
/*
	spawn (50)
		for (var/obj/structure/S in get_turf(src))
			if (S && istype(S) && S != src)
				qdel(src)
				return
*/
/obj/structure/wildtree/Destroy()
	for (var/obj/o in get_turf(src))
		if (o.special_id == "seasons")
			qdel(o)
	..()

/obj/structure/wildtree/fire_act(temperature)
	if (prob(35 * (temperature/500)))
		visible_message("<span class = 'warning'>[src] is burned away.</span>")
		qdel(src)

// it's windy out
/obj/structure/wildtree/proc/sway()
	if (!sways)
		return
	icon_state = "[initial(icon_state)]_swaying_[pick("left", "right")]"

/obj/structure/wildtree/CanPass(var/atom/movable/mover)
	if (istype(mover, /obj/effect/effect/smoke))
		return TRUE
	else if (istype(mover, /obj/item/projectile))
		if (prob(75) && density)
			visible_message("<span class = 'warning'>The [mover.name] hits \the [src]!</span>")
			return FALSE
		else
			return TRUE
	else
		return ..()

/obj/structure/wildtree/bullet_act(var/obj/item/projectile/proj)
	if (prob(proj.damage - 30)) // makes shrapnel unable to take down trees
		visible_message("<span class = 'danger'>[src] collapses!</span>")
		qdel(src)

/obj/structure/wild/tree
	name = "tree"
	icon_state = "tree1"
	opacity = TRUE
	density = TRUE
	sways = TRUE

/obj/structure/wildtree/tree/fire_act(temperature)
	if (prob(15 * (temperature/500)))
		visible_message("<span class = 'warning'>[src] collapses.</span>")
		qdel(src)

/obj/structure/wildtree/tree/anchored

/obj/structure/wildtree/tree/New()
	..()
	if (!istype(src, /obj/structure/wild/tree/anchored))
		pixel_x = rand(-8,8)

