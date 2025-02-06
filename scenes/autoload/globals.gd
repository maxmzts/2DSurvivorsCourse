extends Node

var spawn_position: Vector2 = Vector2.ZERO

# variables for the current game's statistics
var current_game_enemies_killed: int = 0
var current_game_experience_collected: int = 0

func get_player_reference():
	return get_tree().get_first_node_in_group("player")
