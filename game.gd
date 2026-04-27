extends Node2D

@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $Player
@onready var key_counter_label: Label = $CanvasLayer/KeyCounter/KeyCount
@onready var key_counter_icon: TextureRect = $CanvasLayer/KeyCounter/KeyIcon

const KEY_ICON_ATLAS := preload("res://assets/key-white.png")
const KEY_ICON_REGION := Rect2(0, 0, 32, 32)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	heartsContainer.SetMaxHearts(player.maxHealthPoints)
	heartsContainer.UpdateHearts(player.currentHealthPoints)
	player.healthChanged.connect(heartsContainer.UpdateHearts)
	var key_icon := AtlasTexture.new()
	key_icon.atlas = KEY_ICON_ATLAS
	key_icon.region = KEY_ICON_REGION
	key_counter_icon.texture = key_icon
	_update_key_counter()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_update_key_counter()

func _update_key_counter() -> void:
	if player == null:
		return
	if not ("collected_keys" in player):
		return
	key_counter_label.text = str(player.collected_keys)


func _on_tutorial_help_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
