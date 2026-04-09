extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.collected_keys += 1
		print(body.collected_keys)
		self.queue_free()

func _ready():
	$AnimatedSprite2D.play("key")
