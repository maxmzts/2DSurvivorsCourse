extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene
@onready var card_container: HBoxContainer = $%CardContainer

func _ready():
	#pauses all the branches except those with Node/Mode/Always
	get_tree().paused = true
	

#receives an array of upgrades to display
func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(delay)
		card_instance.selected.connect(on_selected.bind(upgrade))
		delay += .2

#when an upgrade is selected, unpauses de game
#and emits a signal for the upgrade_manager to
#store the selected upgrade
func on_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	$ColorRect/AnimationPlayer.play("out")
	await $ColorRect/AnimationPlayer.animation_finished
	get_tree().paused = false
	queue_free()
	
