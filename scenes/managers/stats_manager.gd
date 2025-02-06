extends Node

func _ready():
	# a new game resets the "current game" stats
	Globals.current_game_enemies_killed = 0
	Globals.current_game_experience_collected = 0
	GameEvents.enemy_killed.connect(on_enemy_killed)
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)

func on_enemy_killed():
	Globals.current_game_enemies_killed += 1

func on_experience_vial_collected(number: int):
	Globals.current_game_experience_collected += number
