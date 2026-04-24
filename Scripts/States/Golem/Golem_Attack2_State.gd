extends "res://Scripts/States/base_state_1_0.gd"

var can_transition = false

func enter():
	super.enter()
	can_transition = false
	animation_player.play("Attack_2")
	await get_tree().create_timer(0.5).timeout  # ← pakeisk laiką
	spawn_rock()
	await animation_player.animation_finished
	can_transition = true
	owner.reset_attack_state()

func spawn_rock():  # ← be pabraukimo
	var rock = owner.rock_scene.instantiate()
	owner.get_parent().add_child(rock)
	rock.global_position = owner.global_position + Vector2(owner.direction.x * 130, 10)

func transition():
	if can_transition:
		if owner.is_player_in_range:
			get_parent().change_state("Chase State")
		else:
			get_parent().change_state("Idle State")
