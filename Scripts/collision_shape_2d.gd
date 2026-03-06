extends CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.position = Vector2(500, 200) # teleport location

# Called every frame.
func _process(delta: float) -> void:
	pass
