extends Node

const SPAWN_RADIUS = 360

@export_group("Main enemy 1")
@export var basic_enemy_scene: PackedScene
@export var basic_enemy_base_spawn_rate: int
@export var basic_enemy_spawn_time: int
@export_group("Main enemy 2")
@export var wizard_enemy_scene: PackedScene
@export var wizard_enemy_base_spawn_rate: int
@export var wizard_enemy_spawn_time: int
@export_group("Secondary enemy 1")
@export var bat_enemy_scene: PackedScene
@export var bat_enemy_base_spawn_rate: int
@export var bat_enemy_spawn_time: int
@export_group("Secondary enemy 2")
@export var ghost_enemy_scene: PackedScene
@export var ghost_enemy_base_spawn_rate: int
@export var ghost_enemy_spawn_time: int

@export_group("")
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()
var spawn_count = 1

func _ready():
	base_spawn_time = timer.wait_time
	enemy_table.add_item(basic_enemy_scene, 10)
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
		
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	
	#rotate the spawn position by 90º if is invalid, return if valid
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		#adds 20 more pixels for cheking collisions so that enemies dont spawn and get stuck on walls
		var additional_check_offset = random_direction * 20
	
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters) #returns a dictionary
	
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90)) #needs radians	
	return spawn_position

func on_timer_timeout():
	# we enable one shot to the timer and restart it every timeout for one reaseon:
	# this allows us to change the wait time during the game 
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	for i in spawn_count:
		var enemy_scene = enemy_table.pick_item()
		var enemy = enemy_scene.instantiate() as Node2D
		
		var entities_layer = get_tree().get_first_node_in_group("entities_layer")
		entities_layer.add_child(enemy)
		enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	# the change of wait time wont be visible until the next restart of the timer
	var time_off = (.1/12) * arena_difficulty
	time_off = min(time_off, .7)
	timer.wait_time = base_spawn_time - time_off
	# arena difficulty is arena_difficulty * 5 seconds
	if arena_difficulty == 4:
		enemy_table.add_item(bat_enemy_scene, 2)
	if arena_difficulty == 8:
		enemy_table.add_item(wizard_enemy_scene, 20)
		enemy_table.increase_weight(bat_enemy_scene, 4)
		enemy_table.add_item(ghost_enemy_scene, 4)
	
	# spawns additional more enemy every 30 seconds
	if (arena_difficulty % 12) == 0:
		spawn_count += 1

