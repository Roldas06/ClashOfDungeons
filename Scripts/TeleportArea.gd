extends Area2D

@export var target: Node2D
@export var loading_message: String = "Entering Cave"

var loading_screen: CanvasLayer
var is_transitioning := false

func _ready():
	_build_loading_screen()

func _build_loading_screen():
	loading_screen = CanvasLayer.new()
	loading_screen.layer = 10
	add_child(loading_screen)

	# Black background
	var bg = ColorRect.new()
	bg.color = Color(0.03, 0.03, 0.04)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.name = "BG"
	loading_screen.add_child(bg)

	# Main label
	var label = Label.new()
	label.text = loading_message
	label.set_anchors_preset(Control.PRESET_CENTER)
	label.offset_top = -60
	label.offset_bottom = 20
	label.offset_left = -300
	label.offset_right = 300
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 42)
	label.add_theme_color_override("font_color", Color(0.78, 0.66, 0.43))
	label.name = "Label"
	label.modulate.a = 0.0
	bg.add_child(label)

	# Sub label
	var sub = Label.new()
	sub.text = "Please Wait..."
	sub.set_anchors_preset(Control.PRESET_CENTER)
	sub.offset_top = 30
	sub.offset_bottom = 70
	sub.offset_left = -200
	sub.offset_right = 200
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override("font_size", 16)
	sub.add_theme_color_override("font_color", Color(0.48, 0.38, 0.25))
	sub.name = "Sub"
	sub.modulate.a = 0.0
	bg.add_child(sub)

	# Loading bar background
	var bar_bg = ColorRect.new()
	bar_bg.color = Color(0.1, 0.06, 0.02)
	bar_bg.set_anchors_preset(Control.PRESET_CENTER)
	bar_bg.offset_left = -110
	bar_bg.offset_right = 110
	bar_bg.offset_top = 80
	bar_bg.offset_bottom = 92
	bar_bg.name = "BarBG"
	bar_bg.modulate.a = 0.0
	bg.add_child(bar_bg)

	# Loading bar fill
	var bar = ColorRect.new()
	bar.color = Color(0.78, 0.53, 0.04)
	bar.set_anchors_preset(Control.PRESET_LEFT_WIDE)
	bar.offset_right = 0
	bar.name = "Bar"
	bar_bg.add_child(bar)

	loading_screen.hide()

func _on_body_entered(body):
	if body is CharacterBody2D and target and not is_transitioning:
		is_transitioning = true
		body.set_physics_process(false)
		_start_transition(body)

func _start_transition(body: CharacterBody2D):
	loading_screen.show()

	var bg = loading_screen.get_node("BG")
	var label = bg.get_node("Label")
	var sub = bg.get_node("Sub")
	var bar_bg = bg.get_node("BarBG")
	var bar = bar_bg.get_node("Bar")

	bg.modulate.a = 0.0

	var tween = create_tween()

	# Fade in bg
	tween.tween_property(bg, "modulate:a", 1.0, 0.5)

	# Fade in text & bar
	tween.tween_property(label, "modulate:a", 1.0, 0.4)
	tween.parallel().tween_property(sub, "modulate:a", 1.0, 0.4)
	tween.parallel().tween_property(bar_bg, "modulate:a", 1.0, 0.4)

	# Fill loading bar
	tween.tween_property(bar, "offset_right", 220.0, 2.0)

	# Teleport
	tween.tween_callback(func():
		body.global_position = target.global_position
	)

	# Hold
	tween.tween_interval(0.3)

	# Fade out
	tween.tween_property(bg, "modulate:a", 0.0, 0.6)

	# Done
	tween.tween_callback(func():
		loading_screen.hide()
		body.set_physics_process(true)
		is_transitioning = false
		# Reset bar for next use
		bar.offset_right = 0
	)
