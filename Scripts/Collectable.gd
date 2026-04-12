extends Area2D
class_name Collectable

@export var type : String
const HEALING_SPRITE = preload("res://assets/oak_woods_v1.0/heal.png")

func _ready() -> void:
	set_data()
	connect_signals()

func set_data() -> void:
	if type == "heal" :
		$Sprite2D.texture = HEALING_SPRITE
		
func connect_signals() -> void:
	connect("body_entered", collect)

func collect(body: Node2D) -> void:
	if body.is_in_group("player"):
		if type == "heal":
			body.currentHealthPoints = clamp(body.currentHealthPoints + 9, 0, body.maxHealthPoints)
			body.healthChanged.emit(body.currentHealthPoints)
		queue_free()
