extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var progress_bar = $%ProgressBar
@onready var purchase_button = %PurchaseButton
@onready var progress_label = %ProgressLabel
@onready var level_label = %LevelLabel

var upgrade: MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)

#assigns text to the upgrade card
func set_meta_upgrade(upgrade: MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()
	
func update_progress():
	var current_level = 0
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		current_level = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]
	var is_maxed = current_level >= upgrade.max_quantity
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency  / upgrade.experience_cost
	# avoid overflow if percent is higher than 100% 
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	progress_label.text = str(currency) + "/" + str(upgrade.experience_cost)
	if is_maxed:
		level_label.text = "Lvl. MAX" 
		purchase_button.text = "Maxed"
	else: 
		level_label.text = "Lvl. %d" % current_level

func on_purchase_pressed():
	if(upgrade == null):
		return
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.experience_cost
	MetaProgression.save()
	# calls the function for each of the nodes in the group of meta upgrades
	get_tree().call_group("meta_upgrade_card", "update_progress")
	$AnimationPlayer.play("selected")
