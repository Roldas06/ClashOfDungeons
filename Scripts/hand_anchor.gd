class_name HandAnchor
extends Node2D
#Main script for handling aiming via mouse position

@export var defaultDirection = Vector2.RIGHT

func _process(_delta: float) -> void:
	var cursorPosition = get_global_mouse_position()
	var rotationAngle = global_position.angle_to_point(cursorPosition)
	rotation = rotationAngle
