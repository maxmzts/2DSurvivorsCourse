extends CharacterBody2D

@export var npc_name:  = ""
@export_multiline var npc_dialog: Dictionary = {
	"dialog": "Which is the meaning of existence if I'm just a node, a bunch of code inside your computer?",
	"answers": {
		"Being part of a Godot game": {
			"dialog": "Oh, cool."
		},
		"I don't know": {
			"dialog": "So why are you here?",
			"answers": {
				"Testing bro": {
					"dialog": "Fair."
				},
				"I don't know": {
					"dialog": "Neither do I."
				}
			}
		}
	}
}

@onready var interactable: Interactable = $Interactable

func _ready():
	interactable.interact = _on_interact
	interactable.interact_label = "Talk to " + npc_name
	
func _on_interact():
	if interactable.is_interactable:
		GameEvents.emit_dialog_started(npc_name, npc_dialog)
		interactable.is_interactable = false
		await GameEvents.dialog_finished
		interactable.is_interactable = true
