# Author Kamyab Nazari - 2021

extends Node

class_name Stats

export var max_HP = 10

onready var current_HP = max_HP

signal died_signal

func _ready():
	pass

func take_hit(damage):	
	current_HP -= damage
	
	if current_HP <= 0:
		die()
		

func die():
	emit_signal("died_signal")
