extends Area2D
var checkpoint_manager

func _ready() -> void:
	checkpoint_manager = get_parent()

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		checkpoint_manager.last_location = $RespawnPoint.global_position
		print("Checkpoint issaugotas: ", checkpoint_manager.last_location)
		# Išsaugom kad level 2 atrakinta
		var save = FileAccess.open("user://save.dat", FileAccess.WRITE)
		save.store_var({"level2_unlocked": true, "checkpoint_pos": checkpoint_manager.last_location})
		save.close()
		print("Issaugota!")
