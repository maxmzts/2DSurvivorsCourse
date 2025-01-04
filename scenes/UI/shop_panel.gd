extends CanvasLayer

@export var shop_menu: PackedScene

@onready var name_label = %NameLabel
@onready var dialog_label = %DialogLabel
@onready var buy_button = %BuyButton
@onready var back_button = %BackButton
@onready var animation_player = $AnimationPlayer

func _ready():
	buy_button.pressed.connect(on_buy_pressed)
	back_button.pressed.connect(on_goodbye_pressed)
	animation_player.play("toogle")

func on_buy_pressed():
	var shop_instance = shop_menu.instantiate()
	add_child(shop_instance)
	self.hide()
	await shop_instance.back_button.pressed
	GameEvents.emit_dialog_finished(false)
	queue_free()

func on_goodbye_pressed():
	GameEvents.emit_dialog_finished(false)
	animation_player.play_backwards("toogle")
	await animation_player.animation_finished
	queue_free()
	
