extends CanvasLayer

@onready var panel_container = %PanelContainer

var options_scene = preload("res://scenes/UI/options_menu.tscn")
var is_closing: bool

func _ready():
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	
	$%ResumeButton.pressed.connect(on_resume_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)
	
	$AnimationPlayer.play("in")
	
	#popup panel
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
func _unhandled_input(event):
	# as pause is not handled we need this function
	if event.is_action_pressed("pause"):
		# wont close pause if options is opened
		var options_menu = get_node_or_null("OptionsMenu")
		if options_menu == null:
			close()
		get_tree().root.set_input_as_handled()
		
		
func close():
	if is_closing:
		return
	
	is_closing = true
	$AnimationPlayer.play("out")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	get_tree().paused = false
	queue_free()
	
	
func on_resume_pressed():
	close()
	
func on_options_pressed():
	var options_instance = options_scene.instantiate()
	add_child(options_instance)	
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))
	
func on_quit_pressed():
	ScreenTransition.transition_to_scene("res://scenes/UI/main_menu.tscn")
	
func on_options_closed(options_menu: Node):
	var tween = create_tween()
	tween.tween_property(options_menu, "scale", Vector2.ONE, 0)
	tween.tween_property(options_menu, "scale", Vector2.ZERO, .3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	options_menu.queue_free()
	
	
