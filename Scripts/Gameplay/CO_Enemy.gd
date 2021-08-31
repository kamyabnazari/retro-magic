# Author Kamyab Nazari - 2021

extends KinematicBody

class_name Enemy

var path = []
var path_node = 0

export var speed = 5
export var attack_speed_multiplier = 5

var attack_target: Vector3
var return_target: Vector3

onready var nav : Navigation = get_node("../Navigation")
onready var player : KinematicBody = get_node("../Player")

onready var attack_timer = $AttackTimer
onready var enemy_mesh = $MeshInstance

var default_material = load("res://Materials/EnemyMaterial/MT_Enemy_Default.tres")
var attack_material = load("res://Materials/EnemyMaterial/MT_Enemy_Attack.tres")
var resting_material = load("res://Materials/EnemyMaterial/MT_Enemy_Resting.tres")

enum state {
	SEEKING,
	ATTACKING,
	RETURNING
	RESTING,
}

var current_state = state.SEEKING

func _ready():
	enemy_mesh.set_surface_material(0, default_material)

func _physics_process(_delta):
	if is_instance_valid(player):
		match current_state:
			state.SEEKING:
				if path_node < path.size():
					var direction: Vector3 = (path[path_node] - global_transform.origin)
					if direction.length() < 1:
						path_node += 1
					else:
						# warning-ignore:return_value_discarded
						move_and_slide(direction.normalized() * speed, Vector3.UP)
			state.ATTACKING:
				move_and_attack()
			state.RETURNING:
				move_and_attack()
			state.RESTING:
				pass

func move_and_attack():
	var attack_vector: Vector3 = (attack_target - global_transform.origin)
	var direction: Vector3 = attack_vector.normalized()
	var distance = attack_vector.length()

	# warning-ignore:return_value_discarded
	move_and_slide(direction * speed * attack_speed_multiplier, Vector3.UP)
	
	if distance < 1:
		match current_state:
			state.ATTACKING:
				# Do Damage To The Player
				var player_stats: Stats = player.get_node("Stats")
				player_stats.take_hit(1)
				current_state = state.RETURNING
				attack_target = return_target
			state.RETURNING:
				current_state = state.RESTING
				enemy_mesh.set_surface_material(0, resting_material)
				collide_with_other_enemies(false)
				# warning-ignore:return_value_discarded
				move_and_slide(Vector3.ZERO)
				attack_timer.start()

func collide_with_other_enemies(should_we_collide):
	set_collision_mask_bit(2, should_we_collide)
	set_collision_layer_bit(2, should_we_collide)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_PathUpdateTimer_timeout():
	if is_instance_valid(player):
		move_to(player.global_transform.origin) 

func _on_Stats_died_signal():
	ScSound.get_node("HitSound").play()
	queue_free()

func _on_AttackRadius_body_entered(body):
	if body == player:
		attack_target = player.global_transform.origin
		return_target = global_transform.origin
		current_state = state.ATTACKING
		enemy_mesh.set_surface_material(0, attack_material)
		collide_with_other_enemies(false)

func _on_AttackTimer_timeout():
	current_state = state.SEEKING
	enemy_mesh.set_surface_material(0, default_material)
	collide_with_other_enemies(true)
