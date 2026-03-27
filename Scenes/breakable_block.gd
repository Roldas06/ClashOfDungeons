extends StaticBody2D

@export var max_health: int = 20
@export var hit_flash_time: float = 0.08

var current_health: int
var _base_modulate: Color

func _ready() -> void:
	current_health = max_health
	_base_modulate = modulate

func take_damage(amount: int) -> void:
	if amount <= 0:
		return
	current_health -= amount
	_flash_hit()
	if current_health <= 0:
		queue_free()

func _flash_hit() -> void:
	modulate = Color(1.0, 0.65, 0.65, 1.0)
	var tween := create_tween()
	tween.tween_property(self, "modulate", _base_modulate, hit_flash_time)
