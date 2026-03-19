extends "res://base_enemy.gd"
var direction = 1 
var player_inside = false

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
func _process(delta):

	if ray_cast_left.is_colliding():
		direction = 1
	elif ray_cast_right.is_colliding():
		direction = -1

	
	velocity.x = direction * speed

	



	move_and_slide()
func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("TakeDamage"):
		body.TakeDamage(8)  # Damage the player
		
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
