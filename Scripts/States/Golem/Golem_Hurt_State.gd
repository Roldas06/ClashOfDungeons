extends "res://Scripts/States/base_state_1_0.gd"

var can_transition = false


func enter():
	super.enter()
	can_transition = false
	animation_player.play("Hurt")
	await animation_player.animation_finished
	can_transition = true


func transition():
	if can_transition and owner.is_player_in_range:
		get_parent().change_state("Chase State")
	elif not owner.is_player_in_range:
		get_parent().change_state("Idle State")
