extends "res://base_enemy.gd"

@onready var sfx_damage: AudioStreamPlayer2D = $sfx_damage


const chase_radius = 120
const speed_multiplier = 2.5
var home_position: Vector2
var direction: Vector2
var is_bat_chase: bool
var player: CharacterBody2D
var player_inside = false
var damage_cooldown = 0.0
const DAMAGE_INTERVAL = 0.8
func _ready():
	super()
	is_bat_chase = false
	player = get_tree().get_first_node_in_group("player")
	home_position = global_position

func _process(delta):
	move(delta)
	if hp <= 0:
		return
	if player_inside and damage_cooldown <= 0.0:
		_deal_damage_to_player()
		damage_cooldown = DAMAGE_INTERVAL
	elif damage_cooldown > 0.0:
		damage_cooldown -= delta
	
	var animated_sprite = $AnimatedSprite2D
	handle_animation()
	
func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 0.8])
	if !is_bat_chase:
		direction = choose([Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT])
		
func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player < chase_radius:
		is_bat_chase = true

	if is_bat_chase:
		var chase_direction = (player.global_position - global_position).normalized()
		velocity += chase_direction * speed * speed_multiplier * delta
	else:
		velocity += direction * speed * delta

	velocity *= 0.85
	move_and_slide()

	
func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	

	if animated_sprite.animation == "death":
		return
	if animated_sprite.animation == "hurt" and animated_sprite.is_playing():
		return
		

	if animated_sprite.animation != "fly":
		animated_sprite.play("fly")
	

	if velocity.x < 0:
		animated_sprite.flip_h = true
	elif velocity.x > 0:
		animated_sprite.flip_h = false
func on_hurt():
	sfx_damage.play()
	$AnimatedSprite2D.play("hurt")
func on_death():
	sfx_damage.play()
	$AnimatedSprite2D.play("death")

		
		
func _deal_damage_to_player():
	var area = $Area2D
	var hit_something = false
	for body in area.get_overlapping_bodies():
		if body.has_method("TakeDamage"):
			body.TakeDamage(8)
			hit_something = true
			if body.has_method("ApplyKnockback"):
				var delta_vec = body.global_position - global_position
				var dir = delta_vec.normalized()
			
				
				dir.y = 0
				if dir.x == 0:
					dir.x = 1.0  
				dir = dir.normalized()
				body.ApplyKnockback(dir * knockback_strength)
	if hit_something:
		var bounce_dir = (global_position - player.global_position).normalized()
		velocity = bounce_dir * 200
func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.has_method("TakeDamage"):
		player_inside = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("TakeDamage"):
		player_inside = false
		damage_cooldown = 0.0
