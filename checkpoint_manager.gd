extends Node
var last_location
var player

func _ready() -> void:
	player = get_tree().get_root().find_child("Player", true, false)
	
	if Global.start_at_checkpoint and Global.checkpoint_pos != null:
		last_location = Global.checkpoint_pos
		player.global_position = last_location
		
		# Keep start_at_checkpoint false so you don't accidentally spawn there 
		# on a completely new playthrough, but DON'T set checkpoint_pos to null!
		Global.start_at_checkpoint = false 
	else:
		last_location = player.global_position
