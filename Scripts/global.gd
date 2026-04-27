extends Node

var start_at_checkpoint = false
var checkpoint_pos = null


#Variables
var maxHealthPoints := 40
var unlocked_levels := 1
var attack_damage := 10
var projectile_damage := 10

func _ready():
	SaveGame.load_game()
