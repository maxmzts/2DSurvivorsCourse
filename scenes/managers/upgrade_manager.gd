extends Node


@export var experience_manager: Node
#UI for the upgrades to be shown
@export var upgrade_screen_scene: PackedScene

#represents the upgrades the player has already chosen
var current_upgrades = {}
#array of upgrades that can appear 
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")
var upgrade_anvil = preload("res://resources/upgrades/anvil.tres")
var upgrade_anvil_amount = preload("res://resources/upgrades/anvil_amount.tres")

func _ready():
	upgrade_pool.add_item(upgrade_axe, 10)
	upgrade_pool.add_item(upgrade_anvil, 5)
	upgrade_pool.add_item(upgrade_sword_rate, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	upgrade_pool.add_item(upgrade_player_speed, 5)
	
	
	experience_manager.level_up.connect(on_level_up)

#stores the upgrade or increments quantity
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	#manages the max quantity of an upgrade
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		#if the limit is reached, the upgrade is taken out of the pool
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)

func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage,10)
	elif chosen_upgrade.id == upgrade_anvil.id:
		upgrade_pool.add_item(upgrade_anvil_amount, 5)

func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 2:
		#there are no upgrades left
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		#there are upgrades still
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades) as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)

	
	return chosen_upgrades

#when an upgrade has been selected, this func calls the store func
func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)

#manages the level up presenting the upgrades and storing the selected one
func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades =  pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)

