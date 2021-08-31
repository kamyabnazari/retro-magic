# Author Kamyab Nazari - 2021

extends Spatial

func _ready():
	ScSound.get_node("MenuMusic").stop()
	ScSound.get_node("BattleMusic").play()
