extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

#variable for randomizing the axe loop
var start_rotation = Vector2.RIGHT

func _ready():
	#randf randomizes the start direction
	start_rotation = Vector2.RIGHT.rotated(randf_range(0,TAU))
	
	var tween = create_tween() #creates a new tween for animation
	tween.tween_method(spiral_animation,0.0,2.0,2) #states the start and end of animation
	tween.tween_callback(queue_free) #do not invoke queue_free
	
func spiral_animation(rotations: float):
	var percent = (rotations/2)
	var current_radius = percent * MAX_RADIUS
	var current_direction = start_rotation.rotated(rotations * TAU)

	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
		
	global_position = player.global_position + (current_direction * current_radius)
