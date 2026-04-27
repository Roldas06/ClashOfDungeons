extends Area2D
@export var label_path: NodePath = "../CanvasLayer/Panel/tutorialJump"

var label: Control

func _ready():
	label = get_node(label_path)
	label.modulate.a = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.3)

func _on_body_exited(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.3)
