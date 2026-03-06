extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.global_position = Vector2(401, 74)
