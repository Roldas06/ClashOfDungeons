extends Camera2D

var zoom_speed := 0.5
var min_zoom := 4.0
var max_zoom := 8.0
var target_zoom := 5.0
var shake_strength := 0.0
var shake_decay := 8.0

func _ready():
	zoom = Vector2(target_zoom, target_zoom)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom += zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom -= zoom_speed
		target_zoom = clamp(target_zoom, min_zoom, max_zoom)

func shake(strength: float):
	shake_strength = strength

func _process(delta):
	# Zoom
	zoom = zoom.lerp(Vector2(target_zoom, target_zoom), 10.0 * delta)
	# Shake
	if shake_strength > 0:
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)
	else:
		offset = Vector2.ZERO
