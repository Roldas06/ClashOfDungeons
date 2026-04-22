extends Node2D

var current_state
var previous_state

func _ready():
	current_state = get_child(0)
	previous_state = current_state
	current_state.enter()

func change_state(state):
	if state == previous_state.name:
		return
	current_state = find_child(state)
	current_state.enter()
	previous_state.exit()
	previous_state = current_state

func check_if_can_move():
	return current_state.can_move
