extends Control

@onready var levels_popup: PopupMenu = $LevelsPopup
@onready var levels_button = $LevelsButton

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
	# Nuskaitome failą ir ištraukiame checkpointus
	if FileAccess.file_exists("user://save.dat"):
		var save = FileAccess.open("user://save.dat", FileAccess.READ)
		var data = save.get_var()
		save.close()
		
		if data != null and data is Dictionary:
			checkpoint_pos_2 = data.get("checkpoint_pos_2", null)
			checkpoint_pos_3 = data.get("checkpoint_pos_3", null)
			checkpoint_pos_4 = data.get("checkpoint_pos_4", null)
			checkpoint_pos_5 = data.get("checkpoint_pos_5", null)
	
	# Užpildome meniu sąrašą
	if levels_popup:
		levels_popup.clear()
		levels_popup.add_item("Level 1")
		levels_popup.add_item("Level 2")
		levels_popup.add_item("Level 3")
		levels_popup.add_item("Level 4") 
		levels_popup.add_item("Boss Level") # Tavo 5-as lygis

# -- MYGTUKŲ FUNKCIJOS --

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

# -- LYGIŲ UŽKROVIMAS --

func _on_levels_popup_index_pressed(index: int) -> void:
	resume()
	
	match index:
		0: # LEVEL 1
			Global.start_at_checkpoint = false
			Global.checkpoint_pos = null
			get_tree().change_scene_to_file("res://game.tscn")
		1: # LEVEL 2 (Įrašyk tikras 2 lygio koordinates vietoj 0, 0!)
			_load_level(checkpoint_pos_2, Vector2(0, 0))
		2: # LEVEL 3
			_load_level(checkpoint_pos_3, Vector2(4275, -775))
		3: # LEVEL 4
			_load_level(checkpoint_pos_4, Vector2(525, -4760))
		4: # LEVEL 5 (Boss Level)
			_load_level(checkpoint_pos_5, Vector2(1550, -930))

# Pagalbinė funkcija, kuri naudoja arba Checkpointą, arba Durų koordinates
func _load_level(saved_checkpoint_pos, door_coordinates: Vector2):
	Global.start_at_checkpoint = true
	
	if saved_checkpoint_pos != null:
		Global.checkpoint_pos = saved_checkpoint_pos
	else:
		Global.checkpoint_pos = door_coordinates
		
	get_tree().change_scene_to_file("res://game.tscn")
