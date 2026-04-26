extends Area2D
@onready var tutorial_panel = $"../CanvasLayer/Panel"

func _on_body_entered(body):
	print("Iėjo")
	if body.name == "Player":
		tutorial_panel.show()
		await get_tree().create_timer(3.0).timeout
		tutorial_panel.hide()
