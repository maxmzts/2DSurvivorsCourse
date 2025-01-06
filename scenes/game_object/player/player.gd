extends CharacterBody2D

@export var arena_time_manager: Node

@onready var damage_timer = $DamageTimer
@onready var health_component = $HealthComponent
#add new abilities
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent

var colliding_bodies = 0
var base_speed = 0

var can_move: bool

func _ready():
	global_position = Globals.spawn_position
	can_move = true
	base_speed = velocity_component.max_speed
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_timer.timeout.connect(on_damage_timer_timeout)
	health_component.health_decreased.connect(on_health_decreased)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	# we reuse the arena difficulty because it has a signal every 5 seconds
	if arena_time_manager != null:
		arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	GameEvents.dialog_started.connect(on_dialog_started)
	GameEvents.dialog_finished.connect(on_dialog_finished)
	GameEvents.shop_started.connect(on_shop_started)

func _process(delta):
	if can_move:
		move()
	
func move():
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	# sign returns 1 for positive, -1 for negative and 0 for 0
	var move_sign = sign(movement_vector.x) 
	if move_sign != 0:
		visuals.scale = Vector2(move_sign,1)

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)

func check_deal_damage():
	if colliding_bodies == 0 || !damage_timer.is_stopped():
		return
	health_component.hit(1)
	damage_timer.start()

func on_body_entered(other_body: Node2D):
	colliding_bodies += 1
	check_deal_damage()
	
func on_body_exited(other_body: Node2D):
	colliding_bodies -= 1 

func on_damage_timer_timeout():
	check_deal_damage()

func on_health_decreased():
	GameEvents.emit_player_damaged()
	$HitRandomStreamPlayer.play_random()

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	# if the upgrade is a new ability (new atack)
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	# if the upgrade is the speed
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .1)

func on_arena_difficulty_increased(difficulty: int):
	var health_regeneration_quantity = MetaProgression.get_upgrade_count("health_regeneration")
	var time_span = 6 - (health_regeneration_quantity-1) * 2 # (30s) 6 for level 1, (20s) 4 for 2 and (10s) 2 for 3 
	if health_regeneration_quantity && (difficulty % time_span) == 0 :
		health_component.heal(1)

func on_dialog_started(_a, _b):
	can_move = false

func on_shop_started():
	can_move = false

func on_dialog_finished(_a):
	can_move = true
