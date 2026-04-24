extends Control
@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options
@onready var levels_popup: PopupMenu = $LevelsPopup
@onready var levels_button = $Options/LevelsButton

var level2_unlocked = false
var level3_unlocked = false
var checkpoint_pos_2 = null
var checkpoint_pos_3 = null

func _ready() -> void:
	# Istrina sena issaugojima jei senos strukturos
	if FileAccess.file_exists("user://save.dat"):
		var save = FileAccess.open("user://save.dat", FileAccess.READ)
		var data = save.get_var()
		save.close()
		if not data.has("checkpoint_pos_2"):
			DirAccess.remove_absolute("user://save.dat")
	
	main_buttons.visible = true
	options.visible = false
	
	if FileAccess.file_exists("user://save.dat"):
		var save = FileAccess.open("user://save.dat", FileAccess.READ)
		var data = save.get_var()
		save.close()
		level2_unlocked = data.get("level2_unlocked", false)
		level3_unlocked = data.get("level3_unlocked", false)
		checkpoint_pos_2 = data.get("checkpoint_pos_2", null)
		checkpoint_pos_3 = data.get("checkpoint_pos_3", null)
	
	levels_popup.clear()
	levels_popup.add_item("Level 1")
	
	if level2_unlocked:
		levels_popup.add_item("Level 2")
	else:
		levels_popup.add_item("Level 2 (Užrakinta)")
		levels_popup.set_item_disabled(1, true)
	
	if level3_unlocked:
		levels_popup.add_item("Level 3")
	else:
		levels_popup.add_item("Level 3 (Užrakinta)")
		levels_popup.set_item_disabled(2, true)

func _on_levels_button_pressed() -> void:
	var rect = levels_button.get_global_rect()
	levels_popup.popup(Rect2(rect.position, Vector2(200, 0)))

func _on_levels_popup_index_pressed(index: int) -> void:
	if index == 0:
		Global.start_at_checkpoint = false
		Global.checkpoint_pos = null
		get_tree().change_scene_to_file("res://game.tscn")
	elif index == 1 and level2_unlocked:
		Global.start_at_checkpoint = true
		Global.checkpoint_pos = checkpoint_pos_2
		get_tree().change_scene_to_file("res://game.tscn")
	elif index == 2 and level3_unlocked:
		Global.start_at_checkpoint = true
		Global.checkpoint_pos = checkpoint_pos_3
		get_tree().change_scene_to_file("res://game.tscn")

func _on_start_pressed() -> void:
	Global.start_at_checkpoint = false
	Global.checkpoint_pos = null
	get_tree().change_scene_to_file("res://game.tscn")

func _on_button_options_pressed() -> void:
	main_buttons.visible = false
	options.visible = true

func _on_button_quit_pressed() -> void:
	get_tree().quit()

func _on_back_options_pressed() -> void:
	_ready()

func _on_full_screen_control_toggled(_toggled_on: bool) -> void:
	pass
