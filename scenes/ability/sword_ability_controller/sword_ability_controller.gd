extends Node

const MAX_RANGE = 150
@export var sword_ability: PackedScene

var base_damage = 5
var additional_damage_percent = 1
var base_wait_time

# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	#connects the signal timeout of the Timer to the function
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

#what the sword ability should do when the timeout signal occurs
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	#we only take the enemies inside the MAX_RANGE
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	#function that sorts the array of enemies
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	#we isntantiate the ability to this controller
	var sword_instance = sword_ability.instantiate() as SwordAbility
	#we add a child to foreground layer
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance) 
	sword_instance.hitbox_component.damage = base_damage * additional_damage_percent
	#by default the position of the child is 0,0
	#it's neccesary to spawn it to the position of CLOSEST enemy
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "sword_rate":
		#calculate new wait time
		var reduction = current_upgrades["sword_rate"]["quantity"] * .1
		$Timer.wait_time = base_wait_time * (1 - reduction)
		$Timer.start() #DISCLAIMER it resets the wait time (no worries for us)
	elif upgrade.id == "sword_damage":
		additional_damage_percent = 1 + (current_upgrades["sword_damage"]["quantity"] * .15)
		
	
	
	
	
	
	
	
	
	
