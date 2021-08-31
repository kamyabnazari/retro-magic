# Author Kamyab Nazari - 2021

extends ColorRect

# Fade in and out animation between scenes
onready var _anim_player = $AnimationPlayer

func fade_in():
	_anim_player.play("fade_in")
	return _anim_player

func fade_out():
	_anim_player.play("fade_out")
	return _anim_player
