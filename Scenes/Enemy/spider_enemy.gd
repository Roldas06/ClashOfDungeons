extends "res://base_enemy.gd"

var direction = 1
var player_inside = false
var damage_cooldown = 0.0
const DAMAGE_INTERVAL = 0.8  # seconds between damage ticks
@onready var sfx_damage: AudioStreamPlayer = $sfx_damage

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
func _process(delta):
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	elif ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	velocity.y = 0
	velocity.x = direction * speed
	move_and_slide()

	# Tick down cooldown and deal damage while player is overlapping
	if player_inside and damage_cooldown <= 0.0:
		_deal_damage_to_player()
		damage_cooldown = DAMAGE_INTERVAL
	elif damage_cooldown > 0.0:
		damage_cooldown -= delta

func _deal_damage_to_player():
	var area = $Area2D
	for body in area.get_overlapping_bodies():
		if body.has_method("TakeDamage"):
			body.TakeDamage(8)
			if body.has_method("ApplyKnockback"):
				var delta_vec = body.global_position - global_position
				var dir = Vector2.ZERO
				if abs(delta_vec.x) > abs(delta_vec.y):
					dir.x = sign(delta_vec.x)
					dir.y = -0.5
				else:
					dir.y = sign(delta_vec.y)
				dir = dir.normalized() * knockback_strength
				body.ApplyKnockback(dir)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("TakeDamage"):
		player_inside = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("TakeDamage"):
		player_inside = false
		damage_cooldown = 0.0
func on_hurt():
	sfx_damage.play()
	
func on_death():
	sfx_damage.play()
