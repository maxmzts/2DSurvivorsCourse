extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D

func _ready():
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_died)
	
func on_died():
	#check for getting the spawn position
	if owner == null || not owner is Node2D:
		return
	#we get the position of the enemy when dies
	var spawn_position = owner.global_position
	# we need this reference to the tree before the node is removed, otherwise it will not accesible through get_tree()
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	
	# play animation
	global_position = spawn_position
	$AnimationPlayer.play("default")
	$HitRandomAudioPlayer2DComponent.play_random()
