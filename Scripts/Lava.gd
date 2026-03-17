extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.is_in_lava = true
		body.speed_multiplier = 5.0
		body.lava_damage_timer = body.lava_damage_interval  # first hit is instant
		body.modulate = Color(1, 0.4, 0)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.is_in_lava = false
		body.speed_multiplier = 300.0
		body.lava_damage_timer = 0.0
		body.modulate = Color(1, 1, 1)
