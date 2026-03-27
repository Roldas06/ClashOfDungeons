extends Node2D

@export var player_damage: int = 6
@onready var _trigger: Area2D = $Trigger
@onready var _rock: RigidBody2D = $Rock
@onready var _damage_area: Area2D = $Rock/DamageArea
var _has_dropped: bool = false
var _damaged_player: bool = false

func _ready() -> void:
	_rock.freeze = true
	_rock.contact_monitor = true
	_rock.max_contacts_reported = 4
	_trigger.body_entered.connect(_on_trigger_body_entered)
	_damage_area.body_entered.connect(_on_damage_body_entered)
	_rock.body_entered.connect(_on_rock_body_entered)

func _on_trigger_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if _has_dropped:
		return
	_has_dropped = true
	_rock.set_deferred("freeze", false)

func _on_rock_body_entered(body: Node2D) -> void:
	print("signal fired: ", body.name)
	if _rock.freeze:
		return
	print("rock hit: ", body.name, " groups: ", body.get_groups())
	if body.is_in_group("ground"):
		queue_free()

func _on_damage_body_entered(body: Node2D) -> void:
	if _rock.freeze:
		return
	if body.is_in_group("player"):
		if not _damaged_player:
			if body.has_method("TakeDamage"):
				body.TakeDamage(player_damage)
			_damaged_player = true
		queue_free()
