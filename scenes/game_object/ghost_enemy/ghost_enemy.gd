extends CharacterBody2D

@onready var visuals = $Visuals
@onready var animation_player = $AnimationPlayer
@onready var hurtbox = $HurtboxComponent/CollisionShape2D
@export var bullet: PackedScene
@onready var hit_random_audio_player_2d_component = $HitRandomAudioPlayer2DComponent

var player: Node2D
var direction: Vector2

func _ready():
	$HurtboxComponent.hit.connect(on_hit)
	$AttackTimer.timeout.connect(on_attack_timeout)
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if player == null:
		return
	# to know which direction to look
	direction = (player.global_position - global_position).normalized()
	# invert x if needed
	if sign(direction[0]) != 0:
		visuals.scale = Vector2(sign(direction[0]), 1)
	
func on_hit():
	hit_random_audio_player_2d_component.play_random()
	
func on_attack_timeout():
	if player == null:
		return
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	var spawn_position = player.global_position + (random_direction * 150)
	global_position = spawn_position
	animation_player.play("walk")
	await animation_player.animation_finished
	#for not being targeteable
	global_position = Vector2(-10000,-10000)
	
func shoot():
	var bullet_instance = bullet.instantiate() as Node2D
	bullet_instance.global_position = global_position
	bullet_instance.set_direction(direction)
	var bullets_layer = get_tree().get_first_node_in_group("entities_layer")
	bullets_layer.add_child(bullet_instance)
