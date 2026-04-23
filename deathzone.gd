extends Area2D

var checkpoint_manager
var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_manager = get_tree().get_root().find_child("CheckpointManager", true, false) 
	player = get_tree().get_root().find_child("Player", true, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("Deathzone palietė: ", body.name, "grupes", body.get_groups())
	if body.is_in_group("player"):
		killPlayer();

func killPlayer():
	print("Player position before: ", player.global_position)
	print("Last location: " , checkpoint_manager.last_location)
	player.global_position = checkpoint_manager.last_location
	print("Player position after: ", player.global_position)
