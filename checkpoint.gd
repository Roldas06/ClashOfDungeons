extends Area2D
var checkpoint_manager
@export var level_number: int = 2

func _ready() -> void:
	checkpoint_manager = get_parent()

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		checkpoint_manager.last_location = $RespawnPoint.global_position
		print("Checkpoint issaugotas: ", checkpoint_manager.last_location)
		
		var save = FileAccess.open("user://save.dat", FileAccess.WRITE)
		save.store_var({
			"level2_unlocked": level_number >= 2,
			"level3_unlocked": level_number >= 3,
			"checkpoint_pos_2": checkpoint_manager.last_location if level_number == 2 else null,
			"checkpoint_pos_3": checkpoint_manager.last_location if level_number == 3 else null,
		})
		save.close()
		print("Issaugota! Lygis: ", level_number)
