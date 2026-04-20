extends Label

func _ready():

	pivot_offset = size / 2
	

	var tween = create_tween().set_loops().set_parallel(true)
	

	tween.tween_property(self, "modulate:a", 0.4, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.chain().tween_property(self, "modulate:a", 1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	

	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_property(self, "scale", Vector2(1.0, 1.0), 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
