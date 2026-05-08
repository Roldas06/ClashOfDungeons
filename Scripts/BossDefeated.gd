extends CanvasLayer

func _ready():
	$ColorRect.modulate.a = 0.0
	$ColorRect/Label.modulate.a = 0.0
	$ColorRect/TextureRect.modulate.a = 0.0 
	$ColorRect/Label.pivot_offset = $ColorRect/Label.size / 2
	$ColorRect/Label.add_theme_constant_override("outline_size", 3)

	
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 1.0, 1.5)
	tween.tween_property($ColorRect/TextureRect, "modulate:a", 1.0, 1.0)
	tween.tween_property($ColorRect/Label, "modulate:a", 1.0, 1.0)
	await tween.finished
	_start_pulse()
	
	# Po 4 sekundžių dingsta
	await get_tree().create_timer(4.0).timeout
	var fade_out = create_tween()
	fade_out.tween_property($ColorRect, "modulate:a", 0.0, 1.5)
	await fade_out.finished
	queue_free()

func _start_pulse():
	while true:
		var pulse = create_tween()
		pulse.tween_property($ColorRect/Label, "scale", Vector2(1.05, 1.05), 0.8)
		pulse.tween_property($ColorRect/Label, "scale", Vector2(1.0, 1.0), 0.8)
		await pulse.finished
