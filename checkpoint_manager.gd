extends Node
var last_location
var player

func _ready() -> void:
	player = get_tree().get_root().find_child("Player", true, false)
	
	if Global.start_at_checkpoint and Global.checkpoint_pos != null:
		last_location = Global.checkpoint_pos
		player.global_position = last_location
		Global.start_at_checkpoint = false
		Global.checkpoint_pos = null
	else:
		last_location = player.global_position
