extends Timer

const BASE_RANGE = 100

@export var anvil_ability_scene: PackedScene

func _on_timeout():
	var direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	var spawn_position = direction * randf_range(0,BASE_RANGE)
	
	var player = get_tree().get_first_node_in_group("player") as Node
	if player == null:
		return
	
	var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
	var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters) #returns a dictionary
	if !result.is_empty():
		spawn_position = result["position"]
	
	var anvil_ability = anvil_ability_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
	anvil_ability.global_position = spawn_position
