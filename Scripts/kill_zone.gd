extends Area2D

@onready var timer: Timer = $Timer
var checkpoint_manager
var player

func _ready() -> void:
	checkpoint_manager = get_tree().get_root().find_child("CheckpointManager", true, false)
	player = get_tree().get_root().find_child("Player", true, false)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("GAME OVER!")
		timer.start()

func _on_timer_timeout() -> void:
	player.position = checkpoint_manager.last_location
	
