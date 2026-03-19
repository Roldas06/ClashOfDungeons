extends CharacterBody2D
@export var knockback_strength = 500
@export var speed := 60
@export var max_hp := 4
var hp := 4

func _ready():
	hp = max_hp

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		die()

func die():
	queue_free()
