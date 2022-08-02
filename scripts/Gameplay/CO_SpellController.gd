# Author Kamyab Nazari - 2021

extends Node

export(PackedScene) var startingSpell
var hand
var equipped_weapon : Spatial

func _ready():
	hand = get_parent().find_node("Hand")
	
	if startingSpell:
		equip_weapon(startingSpell)

func equip_weapon(weapon_to_equip):
	if equipped_weapon:
		equipped_weapon.queue_free()
	else:
		equipped_weapon = weapon_to_equip.instance()
		hand.add_child(equipped_weapon)

func cast():
	if equipped_weapon:
		equipped_weapon.shoot()
