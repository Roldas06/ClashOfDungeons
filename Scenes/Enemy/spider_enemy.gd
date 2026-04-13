extends "res://base_enemy.gd"

## =============================================================================
## APEX CRAWLER - IDLE VERSION
## Handles: Staying in place when out of range, Box LOS, and Overshoot Climbing.
## =============================================================================

# --- Signals ---
signal state_changed(old_state, new_state)

# --- Enums ---
enum State { IDLE, PATROL, CHASE, CLIMB, ATTACK, STUNNED }

# --- Exported Variables ---
@export_group("Locomotion")
@export var walk_speed: float = 45.0      
@export var chase_speed: float = 55.0     
@export var climb_speed: float = 60.0     
@export var acceleration: float = 15.0
@export var friction: float = 10.0
@export var gravity_scale: float = 1.0

@export_group("Wall Climbing")
@export var magnetism_force: float = 70.0 
@export var rotation_speed: float = 12.0

@export_group("Detection & AI")
@export var detection_range: float = 150.0
@export var lose_interest_range: float = 150.0
@export var prediction_weight: float = 0.2

# --- Internal Variables ---
var current_state: State = State.IDLE # Default to IDLE
var direction := 1
var player_inside := false
var damage_cooldown := 0.0
var state_timer := 0.0
var _flip_cooldown := 0.0
var _player: Node2D = null
var _last_player_pos := Vector2.ZERO
var _current_normal := Vector2.UP
var _wall_check_rays: Array[RayCast2D] = []

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_r: RayCast2D = $RayCastRight
@onready var ray_l: RayCast2D = $RayCastLeft
@onready var ray_f: RayCast2D = $FloorAheadRay
@onready var sfx_damage: AudioStreamPlayer = $sfx_damage

## =============================================================================
## LIFECYCLE
## =============================================================================

func _ready() -> void:
	super()
	_player = get_tree().get_first_node_in_group("player")
	_wall_check_rays = [ray_r, ray_l]
	_setup_nodes()
	change_state(State.IDLE)

func _setup_nodes() -> void:
	for ray in _wall_check_rays:
		ray.add_exception(self)
		ray.enabled = true
	ray_f.add_exception(self)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(_player):
		_find_player()
	
	_update_timers(delta)
	_update_state_logic(delta)
	_apply_visuals(delta)
	
	move_and_slide()

## =============================================================================
## STATE MACHINE
## =============================================================================

func change_state(new_state: State) -> void:
	if current_state == new_state: return
	var old_state = current_state
	current_state = new_state
	state_timer = 0.0
	
	# Stop movement when entering IDLE
	if new_state == State.IDLE:
		velocity = Vector2.ZERO
		
	state_changed.emit(old_state, new_state)

func _update_state_logic(delta: float) -> void:
	match current_state:
		State.IDLE: _handle_idle_state(delta)
		State.CHASE: _handle_chase_state(delta)
		State.CLIMB: _handle_climb_state(delta)
		State.STUNNED: _handle_stunned_state(delta)

## =============================================================================
## BEHAVIORS
## =============================================================================

func _handle_idle_state(delta: float) -> void:
	# Keep gravity active so it doesn't float
	if not is_on_floor():
		velocity.y += 900.0 * gravity_scale * delta
	
	# Friction to bring it to a full stop
	velocity.x = move_toward(velocity.x, 0, friction)
	
	# Check for player
	if _can_see_player():
		change_state(State.CHASE)

func _handle_chase_state(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 900.0 * gravity_scale * delta
		
	# RETURN TO IDLE if player leaves radius
	if not is_instance_valid(_player) or global_position.distance_to(_player.global_position) > lose_interest_range: 
		change_state(State.IDLE)
		return
		
	var target_x = _player.global_position.x
	
	if _flip_cooldown <= 0:
		var new_dir = sign(target_x - global_position.x)
		if new_dir != 0 and new_dir != direction:
			direction = new_dir
			_flip_cooldown = 0.15 
			
	velocity.x = move_toward(velocity.x, direction * chase_speed, acceleration * 1.5)

	if _is_touching_wall():
		velocity.y = -climb_speed * 0.5 
		change_state(State.CLIMB)

func _handle_climb_state(_delta: float) -> void:
	var normal = _get_combined_wall_normal()
	
	# RETURN TO IDLE if player leaves radius or wall is gone
	if not is_instance_valid(_player) or global_position.distance_to(_player.global_position) > lose_interest_range or normal == Vector2.ZERO:
		change_state(State.IDLE)
		return

	_current_normal = normal
	var v_dir = 0.0
	
	# Overshoot target
	var target_y = _player.global_position.y - 45.0
	var y_diff = target_y - global_position.y
	
	if abs(y_diff) > 10:
		v_dir = sign(y_diff)

	velocity.y = v_dir * climb_speed
	velocity.x = -normal.x * magnetism_force 

	if is_on_floor() and v_dir > 0.1 and state_timer > 0.2:
		change_state(State.IDLE)

func _handle_stunned_state(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, friction)
	velocity.y += 900.0 * delta
	if state_timer > 1.5:
		change_state(State.IDLE)

## =============================================================================
## HELPERS
## =============================================================================

func _can_see_player() -> bool:
	if not is_instance_valid(_player): return false
	if global_position.distance_to(_player.global_position) > detection_range:
		return false
		
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position + Vector2(0, -18), 
		_player.global_position + Vector2(0, -10)
	)
	query.exclude = [get_rid()]
	var result = space.intersect_ray(query)
	
	return result.is_empty() or result.collider == _player

func _get_combined_wall_normal() -> Vector2:
	var avg_normal := Vector2.ZERO
	var count := 0
	for ray in _wall_check_rays:
		if ray.is_colliding():
			avg_normal += ray.get_collision_normal()
			count += 1
	if is_on_wall():
		avg_normal += get_wall_normal()
		count += 1
	return avg_normal.normalized() if count > 0 else Vector2.ZERO

func _is_touching_wall() -> bool:
	return ray_r.is_colliding() or ray_l.is_colliding() or is_on_wall()

func _find_player() -> void:
	_player = get_tree().get_first_node_in_group("player")

func _update_timers(delta: float) -> void:
	state_timer += delta
	_flip_cooldown = max(0.0, _flip_cooldown - delta)
	damage_cooldown = max(0.0, damage_cooldown - delta)
	if player_inside: _process_damage_tick()

func _apply_visuals(delta: float) -> void:
	var target_angle := 0.0
	if current_state == State.CLIMB:
		target_angle = _current_normal.angle() + (PI/2)
		sprite.flip_h = (_current_normal.x > 0)
	else:
		target_angle = 0.0
		sprite.flip_h = (direction < 0)
	
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, delta * rotation_speed)

func _process_damage_tick() -> void:
	if damage_cooldown <= 0:
		_deal_damage()
		damage_cooldown = 0.8

func _deal_damage() -> void:
	var area = $Area2D
	if not area: return
	for body in area.get_overlapping_bodies():
		if body.has_method("TakeDamage") and body.is_in_group("player"):
			body.TakeDamage(8)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): player_inside = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): player_inside = false

func on_hurt() -> void:
	if sfx_damage: sfx_damage.play()
	sprite.modulate = Color.RED
	get_tree().create_timer(0.1).timeout.connect(func(): sprite.modulate = Color.WHITE)

func on_death() -> void:
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
