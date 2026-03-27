extends Area2D

@export var target: Node2D
@export var loading_message: String = "Entering Cave"
@export var enable_cave_mode: bool = true

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

	# Black overlay
	overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.name = "Overlay"
	canvas.add_child(overlay)

	# Vignette (dark edges)
	var vignette = TextureRect.new()
	vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	vignette.modulate = Color(1, 1, 1, 0)
	vignette.name = "Vignette"
	canvas.add_child(vignette)

	# Main text
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

	# Sub text
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

func _start_transition(body: CharacterBody2D):
	var canvas = get_node("TransitionCanvas")
	canvas.show()

	var tween = create_tween()

	# Step 1 — vignette closes in from edges
	tween.tween_property(overlay, "color", Color(0, 0, 0, 0.4), 0.8)

	# Step 2 — full dark
	tween.tween_property(overlay, "color", Color(0, 0, 0, 1.0), 0.5)

	# Step 3 — show text
	tween.tween_property(text_label, "modulate:a", 1.0, 0.4)
	tween.parallel().tween_property(sub_label, "modulate:a", 1.0, 0.4)

	# Step 4 — teleport while dark
	tween.tween_callback(func():
		body.global_position = target.global_position
		# Resume physics immediately so falling starts while still hidden by black screen.
		body.set_physics_process(true)
	)

	# Step 5 — hold
	tween.tween_interval(1.2)

	# Step 6 — fade text out
	tween.tween_property(text_label, "modulate:a", 0.0, 0.3)
	tween.parallel().tween_property(sub_label, "modulate:a", 0.0, 0.3)

	# Step 7 — fade back in
	tween.tween_property(overlay, "color", Color(0, 0, 0, 0.0), 0.8)

	# Step 8 — done
	tween.tween_callback(func():
		canvas.hide()
		is_transitioning = false
	)
