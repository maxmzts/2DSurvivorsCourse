extends CanvasLayer

@onready var panel_container = $%PanelContainer

func _ready():
	#tween animation to show the panels
	tween_panel(panel_container)
	tween_panel(%StatsCard)
	
	get_tree().paused = true
	$%RestartButton.pressed.connect(on_restart_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)
	
func tween_panel(panel: Node):
	# we adjust the pivot to the center so that the scale is correct
	panel.pivot_offset = panel.size / 2
	var tween =  create_tween()
	tween.tween_property(panel, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

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
