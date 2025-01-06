extends Camera2D

var target_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = Globals.spawn_position
	make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 16))

func acquire_target():
	var player = Globals.get_player_reference()
	if player != null:
		target_position = player.global_position
