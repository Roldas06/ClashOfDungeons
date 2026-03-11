extends Area2D

@export var target: Node2D

func _on_body_entered(body):
	if body is CharacterBody2D and target:
		body.global_position = target.global_position
