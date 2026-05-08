extends Area2D

@export var speed := 150.0
var direction := Vector2.ZERO
var projectile_owner = null
var has_hit := false
var damage
var rotation_set := false

func _ready() -> void:
	damage = Global.projectile_damage
	$AnimatedSprite2D.play("arrow")

	await get_tree().create_timer(2.0).timeout
	if not has_hit:
		queue_free()

func _physics_process(delta) -> void:
	if has_hit:
		return
	if not rotation_set and direction != Vector2.ZERO:
		rotation = direction.angle()
		rotation_set = true
	position += direction * speed * delta

func _on_body_entered(body):
	print("GAVAI DAMAGE")
	if body == projectile_owner:
		return
	if body.has_method("TakeDamage"):
		body.TakeDamage(12)
	has_hit = true
	speed = 0
	queue_free()
