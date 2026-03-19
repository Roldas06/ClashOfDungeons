extends Node2D

@export var player_controller : CharacterBody2D  
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D


func _process(delta):
	if player_controller.direction == 1:
		sprite.flip_h = false
		$"../AttackArea".position.x = abs($"../AttackArea".position.x)
	elif player_controller.direction == -1:
		sprite.flip_h = true
		$"../AttackArea".position.x = -abs($"../AttackArea".position.x)
	
	if player_controller.is_dashing:
		animation_player.play("dash")
		return
	
	if player_controller.is_attacking:
		animation_player.play("attack1")
		return
	
	if abs(player_controller.velocity.x) > 0.0:
		animation_player.play("move")
	else:
		animation_player.play("Idle")
	
	if player_controller.velocity.y < 0.0:
		animation_player.play("jump")
	elif player_controller.velocity.y > 0.0:
		animation_player.play("fall")
	
	
