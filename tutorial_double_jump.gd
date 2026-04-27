extends Area2D


@export var label_path: NodePath = "../CanvasLayer/Panel/tutorialDoubleJump"
var label: Control

func _ready():
	label = get_node(label_path)
	label.modulate.a = 0.0
func _on_body_exited(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.3)


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name != "Player":
		return
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.3)
