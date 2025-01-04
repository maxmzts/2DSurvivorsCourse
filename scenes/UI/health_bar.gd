extends Control

@export var player: Node
@onready var progress_bar = $VBoxContainer/ProgressBar
@onready var label = $VBoxContainer/Label

func _ready():
	player.health_component.health_change.connect(on_health_changed)
	update_health_bar()

func update_health_bar():
	progress_bar.value = player.health_component.current_health / player.health_component.max_health
	label.text = "HP: %d" % player.health_component.current_health

func on_health_changed():
	update_health_bar()

