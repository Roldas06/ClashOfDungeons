extends StaticBody2D

@export var max_health: int = 20
@export var hit_flash_time: float = 0.08
@export_range(0.0, 1.0, 0.01) var drop_chance: float = 0.25
@export var drop_scene: PackedScene = preload("res://Colletable.tscn")
@export var drop_type: String = "heal"

var current_health: int
var _base_modulate: Color
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	current_health = max_health
	_base_modulate = modulate
	_rng.randomize()

func take_damage(amount: int) -> void:
	if amount <= 0:
		return
	current_health -= amount
	_flash_hit()
	if current_health <= 0:
		_try_drop()
		queue_free()

func _flash_hit() -> void:
	modulate = Color(1.0, 0.65, 0.65, 1.0)
	var tween := create_tween()
	tween.tween_property(self, "modulate", _base_modulate, hit_flash_time)

func _try_drop() -> void:
	if drop_scene == null:
		return
	if drop_chance <= 0.0:
		return
	if _rng.randf() >= drop_chance:
		return

	var drop := drop_scene.instantiate()
	if drop == null:
		return

	if drop is Node2D:
		drop.global_position = global_position

	if drop is Collectable:
		drop.type = drop_type

	var root := get_tree().current_scene
	if root != null:
		root.call_deferred("add_child", drop)
	else:
		call_deferred("add_sibling", drop)
