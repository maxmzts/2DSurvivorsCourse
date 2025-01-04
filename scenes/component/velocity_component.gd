extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5
var velocity = Vector2.ZERO

func accelerate_to_player():
	var owner_node2D = owner as Node2D
	if owner_node2D == null:
		return
	
	var player = get_tree().get_first_node_in_group("player") as Node2D #typo for intellisense
	if player == null:
		return
	
	var direction = (player.global_position - owner_node2D.global_position).normalized()
	accelerate_in_direction(direction)

# function to accelerate towards the player
func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	# we use FRAMERATE INDEPENDENT LERP
	# we dont give a fixed value because it would be related to de FPS of the game
	# people with 60 FPS would accelerate two times faster than people with 30 fps
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))

func decelerate():
	accelerate_in_direction(Vector2.ZERO)

func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	# move and slide returns the remaining velocity of the last frame in case there are collisions
	# this change is made on the character body, however we want to use this component for movement.
	# It is necessary to take that returned velocity to this component manually:
	velocity = character_body.velocity
	
	
