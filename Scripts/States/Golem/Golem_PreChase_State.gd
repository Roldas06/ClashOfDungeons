extends "res://Scripts/States/base_state_1_0.gd"

var can_transition = false


func enter():
	super.enter()
	can_transition = false
	animation_player.play("Prechase")
	await animation_player.animation_finished
	animation_player.play("Prechase")
	await animation_player.animation_finished
	can_transition = true
	print("PreChase baigtas, is_player_in_range: ", owner.is_player_in_range)

func transition():
	print("transition kviečiamas, can_transition: ", can_transition)
	if can_transition:
		if owner.is_player_in_range:
			get_parent().change_state("Chase State")
		elif not owner.is_player_in_range:
			get_parent().change_state("Idle State")
