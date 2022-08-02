# Author Kamyab Nazari - 2021

extends Spatial

export(PackedScene) var Projectile

export var projectile_speed = 20
export var millis_between_shots = 200

onready var rof_timer = $Timer
var can_shoot = true

func _ready():
	rof_timer.wait_time = millis_between_shots / 1000.0

func shoot():
	if can_shoot:
		ScSound.get_node("FireSound").play()
		var new_projectile = Projectile.instance()
		new_projectile.global_transform = $Muzzle.global_transform
		new_projectile.speed = projectile_speed
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_projectile)
		can_shoot = false
		rof_timer.start()

func _on_Timer_timeout():
	can_shoot = true
