# Author Kamyab Nazari - 2021

extends Spatial

export(PackedScene) var Enemy
onready var timer = $Timer

var enemies_remaining_to_spawn
var enemies_killed_this_wave

var waves # list of all the Wave nodes: [Wave1, Wave2, ...]
var current_wave: Wave  # Wave node 
var current_wave_number = -1

func _ready():
	waves = $Waves.get_children()
	start_next_wave()

func start_next_wave():
	enemies_killed_this_wave = 0
	current_wave_number += 1
	if current_wave_number < waves.size():
		current_wave = waves[current_wave_number]
		enemies_remaining_to_spawn = current_wave.num_enemies
		timer.wait_time = current_wave.second_between_spawns
		timer.start()

func connect_to_enemy_signals(enemy: Enemy):
	var stats = enemy.get_node("Stats") as Stats
	stats.connect("died_signal", self, "_on_enemy_stats_died_signal")

func _on_enemy_stats_died_signal():
	enemies_killed_this_wave += 1

func _on_Timer_timeout():
	# put TO 0 so it will not spawn
	if enemies_remaining_to_spawn != 0:
		# Spawn Enemies!
		var enemy = Enemy.instance()
		connect_to_enemy_signals(enemy)
		var scene_root = get_parent()
		scene_root.add_child(enemy)
		enemies_remaining_to_spawn -= 1
	else:
		if enemies_killed_this_wave == current_wave.num_enemies:
			start_next_wave()
	
