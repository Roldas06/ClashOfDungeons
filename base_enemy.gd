extends CharacterBody2D
@export var knockback_strength = 500
@export var speed := 60
@export var max_hp := 4
var hp := 4
var damage_number_scene = preload("res://DamageNumber.tscn")
func _ready():
	hp = max_hp

func take_damage(amount):
	hp -= amount
	var dmg = damage_number_scene.instantiate()
	get_parent().add_child(dmg)
	dmg.spawn(amount, global_position + Vector2(0, -20))
	if hp <= 0:
		die()

func die():
	queue_free()
