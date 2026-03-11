extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.is_in_lava = true
		body.speed_multiplier = 5.0 
		body.modulate = Color(1, 0.4, 0)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.is_in_lava = false
		body.speed_multiplier = 30.0 
		body.modulate = Color(1, 1, 1)
