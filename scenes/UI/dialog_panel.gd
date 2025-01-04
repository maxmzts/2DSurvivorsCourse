class_name Dialog extends CanvasLayer

@onready var name_label = %NameLabel
@onready var dialog_label = %DialogLabel
@onready var answers_container = %AnswersContainer


var dialog: Dictionary = {}
var is_last_interaction: bool

func _input(event):
	if is_last_interaction:
		if event.is_action_pressed("interact"):
			on_goodbye_pressed()

func prepare_dialog(npc_dialog):
	if npc_dialog:
		dialog = npc_dialog
		set_next_dialog(dialog)
		

func set_next_dialog(next_dialog):
	clear_answer_buttons()
	dialog_label.text = next_dialog["dialog"]
	if next_dialog.has("answers"):
		for answer in next_dialog["answers"]:
			var button_instance = Button.new()
			answers_container.add_child(button_instance)
			button_instance.text = answer
			button_instance.pressed.connect(set_next_dialog.bind(next_dialog["answers"][answer]))
	else:
		var button_instance = Button.new()
		answers_container.add_child(button_instance)
		button_instance.text = "Bye"
		button_instance.pressed.connect(on_goodbye_pressed)
		is_last_interaction = true
		
func clear_answer_buttons():
	var children = answers_container.get_children()
	for child in children:
		child.queue_free()

func on_goodbye_pressed():
	GameEvents.emit_dialog_finished(false)
	queue_free()
	
