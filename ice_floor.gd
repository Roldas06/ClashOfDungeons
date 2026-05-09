extends Area2D

# How slippery the ice is (0.0 = no friction, 1.0 = normal)
@export var ice_friction := 0.99

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.set_meta("on_ice", true)
		body.set_meta("ice_friction", ice_friction)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.set_meta("on_ice", false)
