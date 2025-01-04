extends Node

@export var dialog_panel: PackedScene

func _ready():
	GameEvents.dialog_started.connect(on_dialog_started)
	
func on_dialog_started(npc_name: String, npc_dialog: Dictionary):
	var dialog_instance = dialog_panel.instantiate() as Dialog
	add_child(dialog_instance)
	dialog_instance.name_label.text = npc_name
	dialog_instance.prepare_dialog(npc_dialog)
