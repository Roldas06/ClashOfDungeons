extends Node2D

@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	heartsContainer.SetMaxHearts(player.maxHealthPoints)
	heartsContainer.UpdateHearts(player.currentHealthPoints)
	player.healthChanged.connect(heartsContainer.UpdateHearts)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
