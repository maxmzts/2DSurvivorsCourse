extends Node
class_name HealthComponent

#signal to inform nodes inside the individual enemy that it died
signal died

signal health_change
signal health_decreased

@export var max_health: float = 10
var current_health

func _ready():
	current_health = max_health

func hit(damage: float):
	#avoid negative numbers
	current_health = clamp(current_health - damage, 0, max_health)
	health_change.emit()
	if damage > 0:
		health_decreased.emit()
	#we call the checker on the next frame because it produces an error on godot
	Callable(check_death).call_deferred()

func heal(heal_amount: int):
	hit(-heal_amount)

func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1) #protects from having something greater than 100%

func check_death():
	if current_health == 0:
		died.emit()
		# we also emit the global event for stats purposes
		GameEvents.emit_enemy_killed()
		owner.queue_free()
