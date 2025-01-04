extends Control

@export var experience_manager: Node
@onready var progress_bar = $VBoxContainer/ProgressBar
@onready var label = $VBoxContainer/Label

func _ready():
	experience_manager.experience_updated.connect(on_experience_updated)
	experience_manager.level_up.connect(on_level_up)
	label.text = "Lvl. %d" % experience_manager.current_level

func on_level_up(level):
	label.text = "Lvl. %d" % level

func on_experience_updated(current: float, target: float):
	if target != 0:
		var percent = current / target
		progress_bar.value = percent
	
