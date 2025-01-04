extends CanvasLayer

@onready var panel_container = $%PanelContainer

func _ready():
	# we adjust the pivot to the center so that the scale is correct
	panel_container.pivot_offset = panel_container.size / 2
	var tween =  create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	
	get_tree().paused = true
	$%RestartButton.pressed.connect(on_restart_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)

func set_defeat():
	$%Title.text = "Defeat"
	$%Desc.text = "You lost!"
	play_jingle(true)
	
func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatStreamPlayer.play()
	else:
		$VictoryStreamPlayer.play()

func on_restart_pressed():
	ScreenTransition.transition_to_scene("res://scenes/UI/meta_menu.tscn")
	
func on_quit_pressed():
	ScreenTransition.transition_to_scene("res://scenes/UI/main_menu.tscn")
