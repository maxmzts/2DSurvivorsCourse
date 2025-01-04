extends Node

var pause_menu_scene = preload("res://scenes/UI/pause_menu.tscn")

func _unhandled_input(event):
	# as pause is not handled we need this function
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		# we need to mark it as handled so that it stops its propagation
		get_tree().root.set_input_as_handled()
