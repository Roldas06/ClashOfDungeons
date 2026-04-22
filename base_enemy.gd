class_name BaseEnemy
extends CharacterBody2D
@export var knockback_strength = 500
@export var speed := 200
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
	on_hurt() 
	if hp <= 0:
		die()

func die():
	on_death()

	var animated_sprite = get_node_or_null("AnimatedSprite2D")	
	if animated_sprite and animated_sprite.sprite_frames.has_animation("death"):
		await animated_sprite.animation_finished
	queue_free()
func on_hurt():
	pass 

func on_death():
	pass 
