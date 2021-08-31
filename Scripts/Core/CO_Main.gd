# Author Kamyab Nazari - 2021

extends Node

onready var _transition = $SceneTransition

# Main Menu that handles the run and setup before entering MainMenu
func _ready():
	_transition.fade_out()
	CoSceneManager.goto_scene("res://Scenes/Main/SC_MainMenu.tscn")
