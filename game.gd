extends Node2D

@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $Player
@onready var key_counter_label: Label = $CanvasLayer/KeyCounter/KeyCount
@onready var key_counter_icon: TextureRect = $CanvasLayer/KeyCounter/KeyIcon
@onready var low_hp_vignette = $CanvasLayer/LowHPVignette  # ← NAUJA

const KEY_ICON_ATLAS := preload("res://assets/key-white.png")
const KEY_ICON_REGION := Rect2(0, 0, 32, 32)
const LOW_HP_THRESHOLD := 0.30  # ← NAUJA

var pulse_time := 0.0  # ← NAUJA
var vignette_tween: Tween  # ← NAUJA

func _ready() -> void:
	heartsContainer.SetMaxHearts(player.maxHealthPoints)
	heartsContainer.UpdateHearts(player.currentHealthPoints)
	player.healthChanged.connect(heartsContainer.UpdateHearts)
	player.healthChanged.connect(_on_player_health_changed)  # ← NAUJA
	low_hp_vignette.material.set_shader_parameter("intensity", 0.0)  # ← NAUJA
	var key_icon := AtlasTexture.new()
	key_icon.atlas = KEY_ICON_ATLAS
	key_icon.region = KEY_ICON_REGION
	key_counter_icon.texture = key_icon
	_update_key_counter()

func _process(delta: float) -> void:
	_update_key_counter()
	_update_vignette_pulse(delta)  # ← NAUJA

# ↓ NAUJA FUNKCIJA
func _update_vignette_pulse(delta: float) -> void:
	var hp_ratio = float(player.currentHealthPoints) / float(player.maxHealthPoints)
	if hp_ratio <= LOW_HP_THRESHOLD and player.currentHealthPoints > 0:
		pulse_time += delta * 2.5
		var pulse = (sin(pulse_time) * 0.15) + 0.45
		low_hp_vignette.material.set_shader_parameter("intensity", pulse)
	else:
		pulse_time = 0.0

# ↓ NAUJA FUNKCIJA
func _on_player_health_changed(new_hp: int) -> void:
	var hp_ratio = float(new_hp) / float(player.maxHealthPoints)
	if vignette_tween:
		vignette_tween.kill()
	vignette_tween = create_tween()
	if hp_ratio <= LOW_HP_THRESHOLD and new_hp > 0:
		vignette_tween.tween_method(
			func(v): low_hp_vignette.material.set_shader_parameter("intensity", v),
			low_hp_vignette.material.get_shader_parameter("intensity"),
			0.75, 0.5
		)
	else:
		vignette_tween.tween_method(
			func(v): low_hp_vignette.material.set_shader_parameter("intensity", v),
			low_hp_vignette.material.get_shader_parameter("intensity"),
			0.0, 0.3
		)

func _update_key_counter() -> void:
	if player == null:
		return
	if not ("collected_keys" in player):
		return
	key_counter_label.text = str(player.collected_keys)

func _on_tutorial_help_body_entered(body: Node2D) -> void:
	pass
