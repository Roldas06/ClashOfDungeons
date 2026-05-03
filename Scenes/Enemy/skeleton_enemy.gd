class_name Skeleton
extends CharacterBody2D

@export var knockback_strength = 500
@export var max_hp := 20
var hp := 20
var damage_number_scene = preload("res://DamageNumber.tscn")
var arrow_scene = preload("res://Scenes/Enemy/arrow.tscn")

@onready var animated_sprite = $AnimatedSprite2D

const SHOOT_RADIUS = 250.0
const SHOOT_INTERVAL = 2.0

var player: CharacterBody2D
var shoot_cooldown := 0.0
var is_shooting := false

func _ready():
	hp = max_hp
	player = get_tree().get_first_node_in_group("player")
	animated_sprite.play("idle")

func _process(delta):
	if hp <= 0:
		return

	if shoot_cooldown > 0.0:
		shoot_cooldown -= delta

	var dist_to_player = global_position.distance_to(player.global_position)

	if dist_to_player < SHOOT_RADIUS and shoot_cooldown <= 0.0 and not is_shooting:
		_shoot()

	handle_animation()

func _shoot():
	is_shooting = true
	shoot_cooldown = SHOOT_INTERVAL
	animated_sprite.play("attack")
	animated_sprite.flip_h = player.global_position.x < global_position.x

	await animated_sprite.animation_finished

	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)
	arrow.global_position = global_position + Vector2(0, -10)
	arrow.projectile_owner = self
	var dir = (player.global_position - global_position).normalized()
	arrow.direction = dir
	arrow.rotation = dir.angle()

	is_shooting = false
	animated_sprite.play("idle")

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
	if animated_sprite and animated_sprite.sprite_frames.has_animation("death"):
		await animated_sprite.animation_finished
	queue_free()

func on_hurt():
	if is_shooting:
		return
	animated_sprite.play("hurt")
	await animated_sprite.animation_finished
	animated_sprite.play("idle")

func on_death():
	animated_sprite.play("death")

func handle_animation():
	if animated_sprite.animation in ["death", "attack"]:
		return
	if animated_sprite.animation == "hurt" and animated_sprite.is_playing():
		return
	if animated_sprite.animation != "idle":
		animated_sprite.play("idle")

func ApplyKnockback(force: Vector2) -> void:
	pass 
