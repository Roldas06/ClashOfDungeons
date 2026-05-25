extends Control

@onready var levels_popup: PopupMenu = $LevelsPopup
@onready var levels_button = $LevelsButton

var level2_unlocked = false
var level3_unlocked = false
var level4_unlocked = false
var level5_unlocked = false
var checkpoint_pos_2 = null
var checkpoint_pos_3 = null
var checkpoint_pos_4 = null
var checkpoint_pos_5 = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	_load_levels_data()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func resume():
	get_tree().paused = false
	hide()

func pause():
	_load_levels_data()
	get_tree().paused = true
	show()

func _load_levels_data():
	if FileAccess.file_exists("user://save.dat"):
		var save = FileAccess.open("user://save.dat", FileAccess.READ)
		var data = save.get_var()
		save.close()
		level2_unlocked = data.get("level2_unlocked", false)
		level3_unlocked = data.get("level3_unlocked", false)
		level4_unlocked = data.get("level4_unlocked", false)
		level5_unlocked = data.get("level5_unlocked", false)
		checkpoint_pos_2 = data.get("checkpoint_pos_2", null)
		checkpoint_pos_3 = data.get("checkpoint_pos_3", null)
		checkpoint_pos_4 = data.get("checkpoint_pos_4", null)
		checkpoint_pos_5 = data.get("checkpoint_pos_5", null)
	
	if levels_popup:
		levels_popup.clear()
		levels_popup.add_item("Level 1")
		
		if level2_unlocked:
			levels_popup.add_item("Level 2")
		else:
			levels_popup.add_item("Level 2 (Locked)")
			levels_popup.set_item_disabled(1, true)
		
		if level3_unlocked:
			levels_popup.add_item("Level 3")
		else:
			levels_popup.add_item("Level 3 (Locked)")
			levels_popup.set_item_disabled(2, true)
		
		if level4_unlocked:
			levels_popup.add_item("Level 4")
		else:
			levels_popup.add_item("Level 4 (Locked)")
			levels_popup.set_item_disabled(3, true)
		
		if level5_unlocked:
			levels_popup.add_item("Level 5")
		else:
			levels_popup.add_item("Level 5 (Locked)")
			levels_popup.set_item_disabled(4, true)

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_levels_button_pressed() -> void:
	if levels_button and levels_popup:
		var rect = levels_button.get_global_rect()
		levels_popup.popup(Rect2(rect.position, Vector2(200, 0)))

func _on_levels_popup_index_pressed(index: int) -> void:
	resume()
	
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
	elif index == 3 and level4_unlocked:
		Global.start_at_checkpoint = true
		Global.checkpoint_pos = checkpoint_pos_4
		get_tree().change_scene_to_file("res://game.tscn")
	elif index == 4 and level5_unlocked:
		Global.start_at_checkpoint = true
		Global.checkpoint_pos = checkpoint_pos_5
		get_tree().change_scene_to_file("res://game.tscn")
