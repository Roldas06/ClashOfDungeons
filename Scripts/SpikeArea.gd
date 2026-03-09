extends Area2D

@export var knockback_strength = 300

func _on_Spike_body_entered(body: Node2D) -> void:
	if body.has_method("TakeDamage"):
		body.TakeDamage(2)  # Damage the player
		
		if body.has_method("ApplyKnockback"):
			# Vector from spike center to player
			var delta = body.global_position - global_position
			
			var dir = Vector2.ZERO
			
			# Determine horizontal or vertical knockback based on dominant axis
			if abs(delta.x) > abs(delta.y):
				# Player is more to the left or right
				dir.x = sign(delta.x)
				dir.y = -0.5  # optional small vertical lift
			else:
				# Player is more above or below
				dir.y = sign(delta.y)
				dir.x = 0  # optional small horizontal push
			
			# Normalize and scale
			dir = dir.normalized() * knockback_strength
			body.ApplyKnockback(dir)
