extends CharacterBody2D

@onready var player_detection_area = $PlayerDetection
@onready var animation_player = $AnimationPlayer
@onready var finite_state_machine = $FiniteStateMachine
@onready var sprite_2d = $Sprite2D
@onready var ray_cast_right = $RayCast/RayCastRight
@onready var ray_cast_left = $RayCast/RayCastLeft
@onready var attack_area_1 = $AttackArea2D_1
#@onready var attack_area_2 = $AttackArea2D_2
@export var rock_scene: PackedScene
@export var ranged_attack_range : float = 170.0
@export var shockwave_scene: PackedScene
#@onready var attack_area_3 = $AttackArea2D_3

var player: CharacterBody2D
var mandatory_idle_active = false
var is_player_in_range = false
var is_close_to_player_1 = false
var is_close_to_player_2 = false
var is_close_to_player_3 = false
var direction = Vector2.RIGHT
var is_attacking = false
var is_dead = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")	

@export var change_direction : float = 4.0
@export var stop_distance : float = 8.0
@export var attack_range : float = 110.0
@export var damage_dealt : int = 1
@export var move_speed = 28
@export var chase_speed = 60
@export var health = 50
@export var knockback_force = Vector2(300, -100)

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		return
		
	var distance_to_player = global_position.distance_to(player.global_position)
	var player_position = player.global_position
	var direction_to_player_x = player_position.x - global_position.x

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
	velocity.y = max(velocity.y, 0)

	if is_player_in_range:
		if abs(direction_to_player_x) > change_direction:
			direction.x = sign(direction_to_player_x)
			sprite_2d.flip_h = direction.x > 0

	if is_player_in_range == false:
		check_wall_collision()

	if distance_to_player <= attack_range and mandatory_idle_active == false and not is_attacking:
		is_attacking = true
		is_close_to_player_1 = true

	if distance_to_player > 150.0 and distance_to_player <= ranged_attack_range and mandatory_idle_active == false and not is_attacking:
		is_attacking = true
		is_close_to_player_2 = true

	if is_player_in_range and ray_cast_right.is_colliding() and direction == Vector2.RIGHT:
		mandatory_transition()

	if is_player_in_range and ray_cast_left.is_colliding() and direction == Vector2.LEFT:
		mandatory_transition()

	if is_player_in_range and finite_state_machine.check_if_can_move():
		if abs(direction_to_player_x) > stop_distance:
			velocity.x = direction.x * chase_speed
		else:
			velocity.x = 0
	else:
		if finite_state_machine.check_if_can_move():
			velocity.x = direction.x * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)

	update_attack_area_direction()
	if not finite_state_machine.check_if_can_move():
		velocity.x = 0
	move_and_slide()
	velocity.y = max(velocity.y, 0)

func mandatory_transition():
	mandatory_idle_active = true

func update_attack_area_direction():
	if direction == Vector2.RIGHT:
		attack_area_1.scale.x = 1
		#attack_area_2.scale.x = 1
		#attack_area_3.scale.x = 1
	else:
		attack_area_1.scale.x = -1
		#attack_area_2.scale.x = -1
		#attack_area_3.scale.x = -1

func check_wall_collision():
	if ray_cast_right.is_colliding():
		direction = Vector2.LEFT
		sprite_2d.flip_h = true

	if ray_cast_left.is_colliding():
		direction = Vector2.RIGHT
		sprite_2d.flip_h = false

func start_attack_animation():
	is_attacking = true
	var distance = global_position.distance_to(player.global_position)
	if distance <= attack_range:
		is_close_to_player_1 = true
	else:
		is_close_to_player_2 = true


func reset_attack_state():
	is_close_to_player_1 = false
	is_close_to_player_2 = false
	is_close_to_player_3 = false
	is_attacking = false  

func _on_player_detected(body):
	print("Kas įėjo: ", body.name)
	if body.is_in_group("players"):
		is_player_in_range = true
		print("Player rastas!")


func _on_player_lost(body):
	if body.is_in_group("players"):
		is_player_in_range = false

func _on_attack1_entered(body):
	if body.is_in_group("players"):
		body.TakeDamage(damage_dealt)
		var knockback_dir = (body.global_position - global_position).normalized()
		body.ApplyKnockback(knockback_dir * 800) 

func _on_attack2_entered(body):
	if body.is_in_group("players"):
		body.TakeDamage(damage_dealt * 0.7)

func _on_attack3_entered(body):
	if body.is_in_group("players"):
		body.take_damage(damage_dealt * 2.0)

func take_damage(damage):
	if is_dead:
		return

	health -= damage
	print(health)

	var knockback_direction = (player.global_position - global_position).normalized()
	player.ApplyKnockback(knockback_direction * 400)  # ← tiesiogiai ant playerio

	if health <= 0:
		die()
	else:
		finite_state_machine.change_state("Hurt State")

func apply_knockback(force: Vector2):
	player.ApplyKnockback(force)

func spawn_shockwave():
	var shockwave = shockwave_scene.instantiate()
	get_parent().add_child(shockwave)
	shockwave.global_position = global_position
	
func die():
	is_dead = true
	set_physics_process(false)
	finite_state_machine.change_state("Dead State")
