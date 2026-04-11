extends "res://base_enemy.gd"

var direction: Vector2
var is_bat_chase: bool
var player: CharacterBody2D
var player_inside = false
var damage_cooldown = 0.0
const DAMAGE_INTERVAL = 0.8
func _ready():
	super()
	is_bat_chase = true
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	move(delta)
	
	if player_inside and damage_cooldown <= 0.0:
		_deal_damage_to_player()
		damage_cooldown = DAMAGE_INTERVAL
	elif damage_cooldown > 0.0:
		damage_cooldown -= delta
	
	var animated_sprite = $AnimatedSprite2D
	if animated_sprite.animation == "hurt" or animated_sprite.animation == "death":
		return
	handle_animation()
	
func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 0.8])
	if !is_bat_chase:
		direction = choose([Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT])
		
func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	if is_bat_chase:
		var chase_direction = (player.global_position - global_position).normalized()
		velocity += chase_direction * speed * delta
		
	elif !is_bat_chase:
		velocity += direction * speed * delta
	move_and_slide()
	
func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	animated_sprite.play("fly")
	
	var current_direction = velocity.normalized()
	if current_direction.x < 0:
		animated_sprite.flip_h = true
	elif current_direction.x > 0:
		animated_sprite.flip_h = false
func on_hurt():
	$AnimatedSprite2D.play("hurt")
	
func on_death():
	$AnimatedSprite2D.play("death")

		
		
func _deal_damage_to_player():
	var area = $Area2D
	for body in area.get_overlapping_bodies():
		if body.has_method("TakeDamage"):
			body.TakeDamage(8)
			if body.has_method("ApplyKnockback"):
				var delta_vec = body.global_position - global_position
				var dir = (delta_vec.normalized()) * knockback_strength
				body.ApplyKnockback(dir)

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.has_method("TakeDamage"):
		player_inside = true



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("TakeDamage"):
		player_inside = false
		damage_cooldown = 0.0
