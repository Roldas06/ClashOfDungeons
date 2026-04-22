extends "res://base_enemy.gd"

var direction = 1
var player_inside = false
var damage_cooldown = 0.0
const DAMAGE_INTERVAL = 0.8  

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

@onready var ray_cast_ground_right: RayCast2D = $RayCastDownRight
@onready var ray_cast_ground_left: RayCast2D = $RayCastDownLeft


func _process(delta):
	# Wall collision — flip direction
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	elif ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true

	# Edge detection — flip if no ground ahead
	if direction == 1 and not ray_cast_ground_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	elif direction == -1 and not ray_cast_ground_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	velocity.y = 0
	velocity.x = direction * speed
	move_and_slide()
	animated_sprite.play("walk")
	if player_inside and damage_cooldown <= 0.0:
		_deal_damage_to_player()
		damage_cooldown = DAMAGE_INTERVAL
	elif damage_cooldown > 0.0:
		damage_cooldown -= delta

func _calculate_knockback_dir(body: Node2D) -> Vector2:
	var delta_vec = body.global_position - global_position
	var dir = Vector2.ZERO


	if abs(delta_vec.x) >= abs(delta_vec.y):
	
		dir.x = sign(delta_vec.x)
		dir.y = 0.0
	else:
		
		dir.x = sign(delta_vec.x) if delta_vec.x != 0 else 1.0
		dir.y = 0.5  

	return dir.normalized() * knockback_strength

func _deal_damage_to_player():
	var area = $Area2D
	for body in area.get_overlapping_bodies():
		if body.has_method("TakeDamage"):
			body.TakeDamage(8)
			if body.has_method("ApplyKnockback"):
				body.ApplyKnockback(_calculate_knockback_dir(body))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("TakeDamage"):
		player_inside = true
	
