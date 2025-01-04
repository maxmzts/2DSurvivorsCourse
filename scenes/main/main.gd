extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/UI/pause_menu.tscn")

func _ready():
	$%Player.health_component.died.connect(on_player_died)

	
func _unhandled_input(event):
	# as pause is not handled we need this function
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		# we need to mark it as handled so that it stops its propagation
		get_tree().root.set_input_as_handled()

func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	#needs to be after being added to the scene-treeO
	#that way it is sure everything is available, no errors
	end_screen_instance.set_defeat()
	MetaProgression.save()
	

