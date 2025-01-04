class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum = 0

func add_item(item, weight: int):
	items.append({"item": item, "weight": weight})
	weight_sum += weight
	
func remove_item(item_to_remove):
	items = items.filter( func(item): return item["item"] != item_to_remove )
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]
	
func pick_item(exclude: Array = []):
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	# this is not optimized, with too many items and/or exlude there will be performance problems
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for item in items:
			if item["item"] in exclude:
				continue # goes to the next iteration 
			adjusted_items.append(item)
			adjusted_weight_sum += item["weight"]
	
	var chosen_weight = randi_range(1, adjusted_weight_sum)
	var iteration_sum = 0
	for item in adjusted_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return item["item"]
			
func increase_weight(existing_item, increment: int):
	for item in items:
		if item["item"] == existing_item:
			item["weight"] += increment
			weight_sum += increment
	
