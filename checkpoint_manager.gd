extends Node
var last_location
var player

func _ready() -> void:
	player = get_tree().get_root().find_child("Player", true, false)
	
	if Global.start_at_checkpoint and FileAccess.file_exists("user://save.dat"):
		var save = FileAccess.open("user://save.dat", FileAccess.READ)
		var data = save.get_var()
		save.close()
		last_location = data.get("checkpoint_pos", player.global_position)
		player.global_position = last_location
		Global.start_at_checkpoint = false
	else:
		last_location = player.global_position
