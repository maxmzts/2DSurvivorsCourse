extends CanvasLayer

# warns the program that the transition has fully covered the screen
signal transition_halfway
#check for using the same animation inverted
var skip_emit = false

func transition():
	$AnimationPlayer.play("default")
	await transition_halfway
	skip_emit = true
	$AnimationPlayer.play_backwards("default")
	
func transition_to_scene(scene_path: String):
	transition()
	await transition_halfway
	if get_tree().paused:
		get_tree().paused = false
	get_tree().change_scene_to_file(scene_path)
	
# func to be called on the animation player
func emit_transition_halfway():
	# use case inverted animation, does nothing
	if skip_emit:
		skip_emit = false
		return
	transition_halfway.emit()
