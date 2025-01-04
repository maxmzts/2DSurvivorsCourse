extends Node2D

func _ready():
	pass
	
func start(text: String):
	$Label.text = text
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "global_position", global_position+(Vector2.UP * 16), .3)\
	.set_ease(tween.EASE_OUT).set_trans(tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_property(self, "global_position", global_position+(Vector2.UP * 32), .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ZERO, .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_callback(queue_free)
	
	# althoug this is after queue free, because of set_parallel it is executed at the same time as 
	# the previous global position tween
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE * 2, .15)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	scale_tween.tween_property(self, "scale", Vector2.ONE, .15)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
