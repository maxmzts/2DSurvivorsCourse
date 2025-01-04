extends Area2D

@export var level: PackedScene

func _ready():
	area_entered.connect(on_area_entered)

func on_area_entered(_area):
	MetaProgression.save()
	ScreenTransition.transition_to_scene(level.resource_path)
