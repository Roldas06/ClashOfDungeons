extends Node2D

func spawn(amount: int, pos: Vector2):
	global_position = pos
	
	var label = Label.new()
	label.text = "-" + str(amount)
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color(1, 0.2, 0.2))
	label.position = Vector2(-10, 0)
	add_child(label)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", global_position.y - 40, 0.8)
	tween.tween_property(label, "modulate:a", 0.0, 0.8)
	tween.chain().tween_callback(queue_free)
