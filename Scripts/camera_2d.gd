extends Camera2D

var zoom_speed := 0.5
var min_zoom := 4.0
var max_zoom := 8.0
var target_zoom := 5.0
var shake_strength := 0.0
var shake_decay := 8.0

@export var cave_overlay_layer: int = 20
@export var cave_vignette_max_strength: float = 1.0
@export var cave_ambient_darkness: float = 0.35
@export var cave_radius: float = 0.22
@export var cave_softness: float = 0.55
@export var cave_tint: Color = Color(0.0, 0.0, 0.0, 1.0)

var cave_overlay_canvas: CanvasLayer
var cave_overlay: ColorRect
var cave_material: ShaderMaterial
var cave_vignette_strength: float = 0.0
var cave_ambient_strength: float = 0.0

func _ready():
	zoom = Vector2(target_zoom, target_zoom)
	_build_cave_overlay()

func _build_cave_overlay() -> void:
	cave_overlay_canvas = CanvasLayer.new()
	# High layer so it covers UI (hearts)
	cave_overlay_canvas.layer = cave_overlay_layer
	add_child(cave_overlay_canvas)

	cave_overlay = ColorRect.new()
	cave_overlay.color = Color.WHITE
	cave_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	cave_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var shader := Shader.new()
	shader.code = """
		shader_type canvas_item;

		uniform float strength : hint_range(0.0, 1.0) = 0.0;
		uniform float ambient : hint_range(0.0, 1.0) = 0.0;
		uniform vec2 center = vec2(0.5, 0.5);
		uniform float radius : hint_range(0.0, 1.0) = 0.22;
		uniform float softness : hint_range(0.0, 1.0) = 0.55;
		uniform vec4 tint : source_color = vec4(0.0, 0.0, 0.0, 1.0);

		void fragment() {
			vec2 uv = UV;
			float dist = distance(uv, center);
			// v = 0 at center, 1 at edges
			float v = smoothstep(radius, radius + softness, dist);
			float alpha = clamp(ambient + strength * v, 0.0, 1.0);
			COLOR = vec4(tint.rgb, alpha * tint.a);
		}
	"""

	cave_material = ShaderMaterial.new()
	cave_material.shader = shader
	cave_overlay.material = cave_material

	cave_overlay_canvas.add_child(cave_overlay)
	cave_overlay_canvas.hide()

func set_cave_mode(enabled: bool) -> void:
	var target_strength := (clampf(cave_vignette_max_strength, 0.0, 1.0) if enabled else 0.0)
	var target_ambient := (clampf(cave_ambient_darkness, 0.0, 1.0) if enabled else 0.0)

	if enabled:
		cave_overlay_canvas.show()

	var tween := create_tween()
	tween.tween_property(self, "cave_vignette_strength", target_strength, 0.6)
	tween.parallel().tween_property(self, "cave_ambient_strength", target_ambient, 0.6)
	tween.tween_callback(func():
		if not enabled:
			cave_overlay_canvas.hide()
	)

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

	# Cave effect
	if cave_material:
		cave_material.set_shader_parameter("strength", cave_vignette_strength)
		cave_material.set_shader_parameter("ambient", cave_ambient_strength)
		cave_material.set_shader_parameter("radius", clampf(cave_radius, 0.0, 1.0))
		cave_material.set_shader_parameter("softness", clampf(cave_softness, 0.0, 1.0))
		cave_material.set_shader_parameter("tint", cave_tint)

	# Shake
	if shake_strength > 0.0:
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)
	else:
		offset = Vector2.ZERO
