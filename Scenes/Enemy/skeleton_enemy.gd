class_name Skeleton
extends CharacterBody2D

@export var knockback_strength = 500
@export var max_hp := 20
var hp := 20
var damage_number_scene = preload("res://DamageNumber.tscn")
var arrow_scene = preload("res://Scenes/Enemy/arrow.tscn")
@onready var animated_sprite = $AnimatedSprite2D

const SHOOT_RADIUS = 250.0
const SHOOT_INTERVAL = 0.1
var player: CharacterBody2D
var shoot_cooldown := 0.0
var is_shooting := false

func _ready():
	hp = max_hp
	player = get_tree().get_first_node_in_group("player")
	# Show frame 0 of attack without playing
	animated_sprite.animation = "attack"
	animated_sprite.frame = 0
	animated_sprite.stop()


func _process(delta):
	if hp <= 0:
		return
	if shoot_cooldown > 0.0:
		shoot_cooldown -= delta

	animated_sprite.flip_h = player.global_position.x < global_position.x

	var dist_to_player = global_position.distance_to(player.global_position)
	
	if dist_to_player < SHOOT_RADIUS and shoot_cooldown <= 0.0 and not is_shooting:
	
		is_shooting = true
		_shoot()
	handle_animation()


func _shoot():
	animated_sprite.play("attack")
	await animated_sprite.animation_finished
	if hp <= 0:
		is_shooting = false
		return
	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)
	arrow.global_position = global_position + Vector2(0, -10)
	arrow.projectile_owner = self
	
	
	var target = player.global_position + Vector2(0, 4)
	var dir = (target - global_position).normalized()
	arrow.direction = dir
	
	shoot_cooldown = SHOOT_INTERVAL
	is_shooting = false
	animated_sprite.animation = "attack"
	animated_sprite.frame = 0
	animated_sprite.stop()
func take_damage(amount):
	if hp <= 0:
		return
	hp -= amount
	var dmg = damage_number_scene.instantiate()
	get_parent().add_child(dmg)
	dmg.spawn(amount, global_position + Vector2(0, -20))
	if hp <= 0:
		die()
	else:
		on_hurt()

func die():
	animated_sprite.play("death")
	if animated_sprite.sprite_frames.has_animation("death"):
		await animated_sprite.animation_finished
	queue_free()

func on_hurt():
	if is_shooting:
		return
	animated_sprite.play("hurt")
	await animated_sprite.animation_finished
	if hp > 0:
		animated_sprite.play("idle")

func handle_animation():
	if animated_sprite.animation in ["death", "hurt"]:
		return
	# Don't interfere if we're stopped on attack frame 0 or actively attacking
	if animated_sprite.animation == "attack":
		return

func ApplyKnockback(force: Vector2) -> void:
	pass
