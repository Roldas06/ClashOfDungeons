extends Area2D

@export var target: Node2D
@export var loading_message: String = "Entering Cave"
@export var enable_cave_mode: bool = true
@export var post_transition_invincibility: float = 2.0

var is_transitioning := false
var overlay: ColorRect
var text_label: Label
var sub_label: Label

func _ready():
	_build_overlay()

func _build_overlay():
	var canvas = CanvasLayer.new()
	canvas.layer = 10
	add_child(canvas)

	overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.name = "Overlay"
	canvas.add_child(overlay)

	var vignette = TextureRect.new()
	vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	vignette.modulate = Color(1, 1, 1, 0)
	vignette.name = "Vignette"
	canvas.add_child(vignette)

	text_label = Label.new()
	text_label.text = loading_message
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
	sub_label.text = "prepare yourself"
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
	canvas.name = "TransitionCanvas"

func _on_body_entered(body):
	if body is CharacterBody2D and target and not is_transitioning:
		is_transitioning = true
		_apply_cave_mode()
		body.set_physics_process(false)
		_start_transition(body)

func _apply_cave_mode() -> void:
	var camera = get_tree().get_first_node_in_group("camera")
	if camera and camera.has_method("set_cave_mode"):
		camera.set_cave_mode(enable_cave_mode)

func _find_sprite(body: CharacterBody2D) -> Node:
	for child in body.get_children():
		if child is Sprite2D or child is AnimatedSprite2D:
			return child
	return null

func _start_flicker(body: CharacterBody2D) -> void:
	var sprite = _find_sprite(body)
	if not sprite:
		return
	var flicker = create_tween().set_loops()
	flicker.tween_property(sprite, "modulate:a", 0.3, 0.08)
	flicker.tween_property(sprite, "modulate:a", 1.0, 0.08)
	sprite.set_meta("_flicker_tween", flicker)

func _stop_flicker(body: CharacterBody2D) -> void:
	var sprite = _find_sprite(body)
	if not sprite:
		return
	if sprite.has_meta("_flicker_tween"):
		sprite.get_meta("_flicker_tween").kill()
		sprite.remove_meta("_flicker_tween")
	sprite.modulate.a = 1.0

func _start_transition(body: CharacterBody2D):
	# Grant immunity immediately — before ANY physics at the destination
	body.is_invincible = true

	var canvas = get_node("TransitionCanvas")
	canvas.show()

	var tween = create_tween()

	tween.tween_property(overlay, "color", Color(0, 0, 0, 0.4), 0.8)
	tween.tween_property(overlay, "color", Color(0, 0, 0, 1.0), 0.5)
	tween.tween_property(text_label, "modulate:a", 1.0, 0.4)
	tween.parallel().tween_property(sub_label, "modulate:a", 1.0, 0.4)

	tween.tween_callback(func():
		body.global_position = target.global_position
		body.set_physics_process(true)
	)

	tween.tween_interval(1.2)
	tween.tween_property(text_label, "modulate:a", 0.0, 0.3)
	tween.parallel().tween_property(sub_label, "modulate:a", 0.0, 0.3)
	tween.tween_property(overlay, "color", Color(0, 0, 0, 0.0), 0.8)

	tween.tween_callback(func():
		canvas.hide()
		is_transitioning = false
		_start_flicker(body)
	)

	# 5 seconds of immunity after fade-in
	tween.tween_interval(post_transition_invincibility)

	tween.tween_callback(func():
		body.is_invincible = false
		_stop_flicker(body)
	);
