extends Node

const BASE_RANGE = 100
const BASE_DAMAGE = 20

@export var anvil_ability_scene: PackedScene

var anvil_amount = 0
var player

func _ready():
	$Timer.timeout.connect(_on_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	player = Globals.get_player_reference() as Node

func _on_timeout():
	if player == null:
		return
	for i in anvil_amount+1:
		spawn_anvil()
		
func spawn_anvil():
	var direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	var spawn_position = player.global_position + (direction * randf_range(0,BASE_RANGE))
	
	var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
	var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters) #returns a dictionary
	if !result.is_empty():
		spawn_position = result["position"]
	
	var anvil_ability = anvil_ability_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
	anvil_ability.global_position = spawn_position
	anvil_ability.hitbox_component.damage = BASE_DAMAGE

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "anvil_amount":
		anvil_amount = current_upgrades["anvil_amount"]["quantity"]
		

