extends Node

@export var end_screen_scene: PackedScene

func _ready():
	$%Player.health_component.died.connect(on_player_died)

func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	#needs to be after being added to the scene-treeO
	#that way it is sure everything is available, no errors
	end_screen_instance.set_defeat()
	MetaProgression.save()

