extends CharacterBody2D

@export var speed: int

var direction: Vector2

func _process(_delta):
	velocity = direction * speed
	move_and_slide()

func set_direction(new_direction: Vector2):
	direction = new_direction

func _on_timer_timeout():
	queue_free()
