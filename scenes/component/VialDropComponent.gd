extends Node

@export_range(0, 1) var drop_percent: float = .5
#scene from the health of the entity
#it is assigned in the VialDropComponent node
#from the entity so that every enemy has different
#health management#scene from the vial for instantiating
#it is assigned in the VialDropComponent scene root
#so that is a vial always
@export var health_component: Node
#scene from the vial for instantiating
#it is assigned in the VialDropComponent scene root
#so that is a vial always
@export var vial_scene: PackedScene

func _ready():
	(health_component as HealthComponent).died.connect(on_died)

func on_died():
	var adjusted_drop_percent = drop_percent
	# increase probability if the upgrade is purchased
	var experience_gain_upgrade_count = MetaProgression.get_upgrade_count("experience_gain")
	if experience_gain_upgrade_count > 0:
		adjusted_drop_percent += .1
	if randf() > adjusted_drop_percent:
		return
	
	if vial_scene == null:
		return
	
	#checks if the owner of this node is a Node2D (an enemy node)
	if not owner is Node2D:
		return
	
	#position from the enemy
	var spawn_position = (owner as Node2D).global_position
	#instantiates the scene of the vial and adds it to where the
	#enemy exists (main in this case) in the position of the 
	#killed enemy
	var vial_instance = vial_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(vial_instance)
	vial_instance.global_position = spawn_position


