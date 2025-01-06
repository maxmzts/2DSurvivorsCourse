extends Area2D

#@export var level: PackedScene
@export var level_path: String
@export var spawn_position: Vector2

func _ready():
	area_entered.connect(on_area_entered)

func on_area_entered(_area):
	MetaProgression.save()
	Globals.spawn_position = spawn_position
	ScreenTransition.transition_to_scene(level_path)
