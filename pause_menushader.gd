extends Control

# Svarbu: Pakeisk šiuos kelius pagal tai, kur tiksliai yra tavo mygtukai pauzės scenoje!
@onready var levels_popup: PopupMenu = $LevelsPopup
@onready var levels_button = $LevelsButton # Pvz., gali būti $VBoxContainer/LevelsButton

var level2_unlocked = false
var level3_unlocked = false
var checkpoint_pos_2 = null
var checkpoint_pos_3 = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	# Pasiruošiame lygių duomenis jau užsikrovus
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
	# Kaskart atidarius pauzę, per naujo užkrauname išsaugojimą (jei žaidėjas atrakino lygį žaisdamas)
	_load_levels_data() 
	get_tree().paused = true
	show()

# --- DUOMENŲ UŽKROVIMO LOGIKA IŠ MAIN MENU ---
func _load_levels_data():
	if FileAccess.file_exists("user://save.dat"):
		var save = FileAccess.open("user://save.dat", FileAccess.READ)
		var data = save.get_var()
		save.close()
		level2_unlocked = data.get("level2_unlocked", false)
		level3_unlocked = data.get("level3_unlocked", false)
		checkpoint_pos_2 = data.get("checkpoint_pos_2", null)
		checkpoint_pos_3 = data.get("checkpoint_pos_3", null)
	
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

# --- MYGTUKŲ SIGNALAI ---
func _on_resume_pressed() -> void:
	print("RESUME PASPAUSTAS!")
	resume()

func _on_restart_pressed() -> void:
	print("RESTART PASPAUSTAS!")
	resume() # Būtina atpauzuoti prieš perkraunant sceną!
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	print("QUIT PASPAUSTAS!")
	resume() # Būtina atpauzuoti prieš grįžtant į Main Menu!
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_levels_button_pressed() -> void:
	# Išskleidžiame Popup meniu šalia Levels mygtuko
	if levels_button and levels_popup:
		var rect = levels_button.get_global_rect()
		levels_popup.popup(Rect2(rect.position, Vector2(200, 0)))

func _on_levels_popup_index_pressed(index: int) -> void:
	resume() # SVARBU: Atpauzuojame žaidimą, nes kitaip naujas lygis bus sustingęs!
	
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
