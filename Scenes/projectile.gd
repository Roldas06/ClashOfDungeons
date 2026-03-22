extends Area2D

@export var speed := 150.0
@export var damage := 10

var direction := Vector2.ZERO
var projectile_owner = null
var has_hit := false

func _ready() -> void:
	rotation = direction.angle()
	
	$AnimatedSprite2D.play("default")
	
	await get_tree().create_timer(2.0).timeout
	if not has_hit:
		queue_free()

func _physics_process(delta) -> void:
	if has_hit:
		return
	
	position += direction * speed * delta

func _on_body_entered(body):
	if body == projectile_owner:
		return
	
	if body.has_method("TakeDamage"):
		body.TakeDamage(damage)
		
	has_hit = true
	speed = 0
	
	queue_free()
