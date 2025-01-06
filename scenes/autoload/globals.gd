extends Node

var spawn_position: Vector2 = Vector2.ZERO

func get_player_reference():
	return get_tree().get_first_node_in_group("player")
