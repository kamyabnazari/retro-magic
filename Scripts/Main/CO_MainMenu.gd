# Author Kamyab Nazari - 2021

extends Control

# MainMenu of the Game
onready var _transition = $SceneTransition;

func ready():
	_transition.fade_out()

func _on_PlayButton_pressed():
	var a_player = _transition.fade_in()
	yield(a_player, "animation_finished")
	CoSceneManager.goto_scene("res://Scenes/Main/SC_Battle.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()
