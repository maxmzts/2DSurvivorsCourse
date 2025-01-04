extends CharacterBody2D

@export var npc_name: String = "Undefined name"
@export var npc_shop_statement: String = "Undefined shop statement"
@export var npc_sprite: Texture2D
@export var shop_panel: PackedScene
@export var shop_menu: PackedScene

@onready var interactable: Interactable = $Interactable

func _ready():
	if npc_sprite:
		$Sprite2D.texture = npc_sprite
	interactable.interact = _on_interact
	interactable.interact_label = npc_name
	
func _on_interact():
	if interactable.is_interactable:
		var shop_instance = shop_panel.instantiate() 
		shop_instance.shop_menu = shop_menu
		get_tree().get_first_node_in_group("ui_elements").add_child(shop_instance)
		shop_instance.name_label.text = npc_name
		shop_instance.dialog_label.text = npc_shop_statement
		GameEvents.emit_shop_started()
		interactable.is_interactable = false
		await GameEvents.dialog_finished
		interactable.is_interactable = true
