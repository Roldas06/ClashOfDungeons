extends Node

var start_at_checkpoint = false
var checkpoint_pos = null


#Variables
var maxHealthPoints := 40
var unlocked_levels := 1
var attack_damage := 10
var projectile_damage := 10
var ui_open := false

func _ready():
	SaveGame.load_game()

func apply_boost(boost_data: Dictionary) -> void:
	match boost_data["stat"]:
		"health":       maxHealthPoints   += int(boost_data["value"])
		"attack":       attack_damage     += int(boost_data["value"])
		"projectile":   projectile_damage += int(boost_data["value"])
	SaveGame.save_game()
