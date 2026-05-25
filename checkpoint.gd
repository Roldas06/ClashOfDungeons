extends Area2D
var checkpoint_manager
@export var level_number: int = 2

func _ready() -> void:
	checkpoint_manager = get_parent()

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var spawn_pos = $RespawnPoint.global_position
		
		# 1. Update the local manager
		checkpoint_manager.last_location = spawn_pos
		
		# 2. FIX: Update the Global Autoload so it survives a scene reload!
		Global.checkpoint_pos = spawn_pos
		Global.start_at_checkpoint = true 
		
		print("Checkpoint issaugotas: ", spawn_pos)
		
		var save = FileAccess.open("user://save.dat", FileAccess.WRITE)
		save.store_var({
			"level2_unlocked": level_number >= 2,
			"level3_unlocked": level_number >= 3,
			"checkpoint_pos_2": spawn_pos if level_number == 2 else null,
			"checkpoint_pos_3": spawn_pos if level_number == 3 else null,
		})
		save.close()
		print("Issaugota! Lygis: ", level_number)		
