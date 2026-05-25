extends Area2D

var is_transitioning := false
var overlay: ColorRect
var text_label: Label
var sub_label: Label

func _ready():
	_build_overlay()
	stat_boost_ui = get_tree().current_scene.get_node("StatBoostUI")
	stat_boost_ui.boost_selected.connect(_on_boost_selected)

func _build_overlay():
	var canvas = CanvasLayer.new()
	canvas.layer = 10
	canvas.name = "TransitionCanvas"
	add_child(canvas)

	overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(overlay)

	text_label = Label.new()
	text_label.text = "Entering Boss Room"
	text_label.set_anchors_preset(Control.PRESET_CENTER)
	text_label.offset_left = -300
	text_label.offset_right = 300
	text_label.offset_top = -40
	text_label.offset_bottom = 20
	text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text_label.add_theme_font_size_override("font_size", 32)
	text_label.add_theme_color_override("font_color", Color(0.78, 0.66, 0.43))
	text_label.modulate.a = 0.0
	canvas.add_child(text_label)

	sub_label = Label.new()
	sub_label.text = "good luck..."
	sub_label.set_anchors_preset(Control.PRESET_CENTER)
	sub_label.offset_left = -200
	sub_label.offset_right = 200
	sub_label.offset_top = 20
	sub_label.offset_bottom = 50
	sub_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_label.add_theme_font_size_override("font_size", 14)
	sub_label.add_theme_color_override("font_color", Color(0.42, 0.31, 0.19))
	sub_label.modulate.a = 0.0
	canvas.add_child(sub_label)

	canvas.hide()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not is_transitioning:
		if body.collected_keys == 3:
			is_transitioning = true
			$AnimatedSprite2D.play("opening")
			_start_transition(body)
			Global.unlocked_levels = 4
			body.collected_keys = 0
			SaveGame.save_game()


func _start_transition(body):
	var canvas = get_node("TransitionCanvas")
	canvas.show()

	var tween = create_tween()

	# Darken from edges
	tween.tween_property(overlay, "color", Color(0, 0, 0, 0.5), 0.6)

	# Full black
	tween.tween_property(overlay, "color", Color(0, 0, 0, 1.0), 0.4)

	# Show text
	tween.tween_property(text_label, "modulate:a", 1.0, 0.4)
	tween.parallel().tween_property(sub_label, "modulate:a", 1.0, 0.4)

	# Teleport while dark
	tween.tween_callback(func():
		body.global_position = Vector2(1550, -930)
	)

	# Hold
	tween.tween_interval(1.2)

	# Fade text out
	tween.tween_property(text_label, "modulate:a", 0.0, 0.3)
	tween.parallel().tween_property(sub_label, "modulate:a", 0.0, 0.3)

	# Fade back in
	tween.tween_property(overlay, "color", Color(0, 0, 0, 0.0), 0.8)

	# Done
	tween.tween_callback(func():
		canvas.hide()
		body.set_physics_process(true)
		is_transitioning = false
	);
