extends CanvasLayer

var options_scene = preload("res://scenes/UI/options_menu.tscn")

func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%QuickPlayButton.pressed.connect(on_quick_play_pressed)
	%MetaButton.pressed.connect(on_meta_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)

func on_play_pressed():
	#autoload node
	ScreenTransition.transition_to_scene("res://scenes/levels/lobby.tscn")

func on_quick_play_pressed():
	#autoload node
	ScreenTransition.transition_to_scene("res://scenes/levels/arena2.tscn")
	
func on_meta_pressed():
	ScreenTransition.transition_to_scene("res://scenes/UI/meta_menu.tscn")

func on_options_pressed():
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))
	
func on_quit_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().quit()
	
func on_options_closed(options_instance: Node):
	options_instance.queue_free()
	
