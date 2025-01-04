extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite = $Sprite2D

func _ready():
	$Area2D.area_entered.connect(on_area_entered)
	
func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	# we use percent because we need to interpolate with a moving object
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))
	
func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()
	
func disable_collision():
	collision_shape_2d.disabled = true

func on_area_entered(other_area: Area2D):
	# we call the function on the next frame to prevent physics errors
	# godot would print an error otherwise
	Callable(disable_collision).call_deferred()
	# time to tween baby
	var tween = create_tween()
	tween.set_parallel()
	#calls method to tween with method.bind(its parameters), from, to, time. 
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, .5)\
	#here we use BackIn easing so that the vial firstly goes away and then to the player
	#easings.net
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, .15).set_delay(.35) #delay to be syncronized
	# tween chain makes that the next tween call waits to the other being executed on parallel to dinidh
	tween.chain()
	tween.tween_callback(collect)
	
	#play audio
	$RandomAudioStreamPlayer2DComponent.play_random()

