extends Area2D

var damage = 15

func _ready():
	$AnimationPlayer.play("RockAttack")
	await $AnimationPlayer.animation_finished
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("players"):
		body.TakeDamage(damage)
