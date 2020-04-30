/*
 * Contains:
 *		Security
 *		Detective
 *		Head of Security
 */

/*
 * Security
 */
/obj/item/clothing/under/rank/warden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpsuit"
	icon_state = "warden_red"
	item_state_slots = list(
		slot_hand_str = "red"
		)
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/head/warden 							// TODO: move all head clothing to /head
	name = "warden's hat"
	desc = "It's a special helmet issued to the Warden of a securiy force."
	icon_state = "policehelm"
	body_parts_covered = 0

/obj/item/clothing/head/warden/drill
	name = "warden's drill hat"
	desc = "You've definitely have seen that hat before."
	icon_state = "wardendrill"

/obj/item/clothing/under/rank/security
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "officer_red"
	item_state_slots = list(
		slot_hand_str = "red"
		)
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/dispatch
	name = "dispatcher's uniform"
	desc = "A dress shirt and khakis with a security patch sewn on."
	icon_state = "dispatch"
	item_state_slots = list(
		slot_hand_str = "blue"
		)
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/security2
	name = "security officer's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "redshirt"
	item_state_slots = list(
		slot_hand_str = "red"
		)
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/security/corp
	icon_state = "sec_corp"
	item_state_slots = list(
		slot_hand_str = "black"
		)

/obj/item/clothing/under/rank/warden/corp
	icon_state = "warden_corp"
	item_state_slots = list(
		slot_hand_str = "black"
		)

/obj/item/clothing/under/tactical
	name = "tactical jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "swatunder"
	item_state_slots = list(
		slot_hand_str = "black"
		)
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/*
 * Detective
 */
/obj/item/clothing/under/det
	name = "detective's suit"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks."
	icon_state = "detective"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	starting_accessories = list(/obj/item/clothing/accessory/blue_clip)

/obj/item/clothing/under/det/grey
	icon_state = "det_grey"
	item_state_slots = list(
		slot_hand_str = "detective"
		)
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks."
	starting_accessories = list(/obj/item/clothing/accessory/red_long)

/obj/item/clothing/under/det/black
	icon_state = "det_black"
	item_state_slots = list(
		slot_hand_str = "sl_suit"
		)
	desc = "An immaculate white dress shirt, paired with a pair of dark grey dress pants, a red tie, and a charcoal vest."
	starting_accessories = list(/obj/item/clothing/accessory/red_long, /obj/item/clothing/accessory/toggleable/vest)

/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpsuit"
	icon_state = "hos_red"
	item_state_slots = list(
		slot_hand_str = "red"
		)
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.8

/obj/item/clothing/under/rank/head_of_security/corp
	icon_state = "hos_corp"
	item_state_slots = list(
		slot_hand_str = "black"
		)

/obj/item/clothing/head/HoS
	name = "Head of Security Hat"
	desc = "The hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap"
	body_parts_covered = 0
	siemens_coefficient = 0.8

/obj/item/clothing/head/HoS/german
	name = "ancient cap"
	desc = "An ancient cap, how did it survived to these days?"
	icon_state = "capger"
	body_parts_covered = HEAD
	armor = list(melee = 25, bullet = 10, laser = 10,energy = 10, bomb = 10, bio = 0, rad = 0)
	siemens_coefficient = 0.6

/obj/item/clothing/head/HoS/dermal
	name = "Dermal Armour Patch"
	desc = "You're not quite sure how you manage to take it on and off, but it implants nicely in your head."
	icon_state = "dermal"
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 50, laser = 50,energy = 25, bomb = 30, bio = 0, rad = 0)
	siemens_coefficient = 0.6

/obj/item/clothing/suit/armor/hos
	name = "armored coat"
	desc = "A greatcoat enhanced with a special alloy for some protection and style."
	icon_state = "hos"
	item_state = "hos"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0.6

/obj/item/clothing/suit/armor/hos/german
	name = "ancient trenchcoat"
	desc = "An ancient trenchcoat, how did it survived to these days? There's a label on the neck that reads 'Hergestellt von Hugo Boss'"
	icon_state = "trenchcoatger"
	item_state = "trenchcoatger"
	armor = list(melee = 35, bullet = 15, laser = 15, energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/hos/german/mob_can_equip(mob/user)
	.=..()
	if(user.gender == FEMALE)
		to_chat(user, "<span class='warning'> You aren't sure you'll fit in this men's cloth..</span>")
		return 0

//Jensen cosplay gear
/obj/item/clothing/under/rank/head_of_security/jensen
	desc = "You never asked for anything that stylish."
	name = "head of security's jumpsuit"
	icon_state = "jensen"
	siemens_coefficient = 0.6

/obj/item/clothing/suit/armor/hos/jensen
	name = "armored trenchcoat"
	desc = "A trenchcoat augmented with a special alloy for some protection and style."
	icon_state = "hostrench"
	item_state = "hostrench"
	flags_inv = 0
	siemens_coefficient = 0.6

/obj/item/clothing/suit/armor/hos/jensen/custom
	name = "stylish trenchcoat"
	desc = "A loose, unbelted trenchcoat of military style. Has a \"MILITA\" writen on chest."
	icon_state = "hostrench"
	item_state = "hostrench"
	armor = list(melee = 15, bullet = 10, laser = 10, energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/hos/jensen/fieldcoat
	name = "military trenchcoat"
	desc = "A military trenchcoat with a leather belt and long, custom collar. Looks kinda old, but is kept in a good shape."
	icon_state = "dalek_coat"
	item_state = "dalek_coat"
	armor = list(melee = 45, bullet = 35, laser = 35, energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/hos/jensen/fieldcoat/mob_can_equip(mob/user)
	.=..()
	if(user.gender == FEMALE)
		to_chat(user, "<span class='warning'> You aren't sure you'll fit in this fascist cloth..</span>")
		return 0

/*
 * Navy uniforms
 */

/obj/item/clothing/under/rank/security/navyblue
	name = "security officer's uniform"
	desc = "The latest in fashionable security outfits."
	icon_state = "officer_navy"
	item_state_slots = list(
		slot_hand_str = "black"
		)

/obj/item/clothing/under/rank/head_of_security/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Head of Security."
	name = "head of security's uniform"
	icon_state = "hos_navy"
	item_state_slots = list(
		slot_hand_str = "black"
		)

/obj/item/clothing/under/rank/warden/navyblue
	desc = "The insignia on this uniform tells you that this uniform belongs to the Warden."
	name = "warden's uniform"
	icon_state = "warden_navy"
	item_state_slots = list(
		slot_hand_str = "black"
		)
