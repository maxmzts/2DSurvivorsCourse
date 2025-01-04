extends Node2D

@onready var interact_label: Label = $Label
var current_interactions:= []
var can_interact := true

func _input(event):
	if event.is_action_pressed("interact") and can_interact:
		if current_interactions:
			can_interact = false
			interact_label.hide()
			
			await current_interactions[0].interact.call()
			
			can_interact = true

# sort by nearest (if possible) if is not interacting 
# hides if not posible
func _process(_delta):
	if current_interactions and can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable:
			interact_label.text = current_interactions[0].interact_label
			interact_label.show()
	else:
		interact_label.hide()

func _sort_by_nearest(area1, area2):
	var area1_distance = global_position.distance_to(area1.global_position)
	var area2_distance = global_position.distance_to(area2.global_position)
	
	return area1_distance < area2_distance
	

func _on_interaction_area_area_entered(area):
	current_interactions.push_back(area)


func _on_interaction_area_area_exited(area):
	current_interactions.erase(area)
