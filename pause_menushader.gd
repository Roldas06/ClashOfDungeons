extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

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
	get_tree().paused = true
	show()

func _on_resume_pressed() -> void:
	print("RESUME PASPAUSTAS!")
	resume()

func _on_restart_pressed() -> void:
	print("RESTART PASPAUSTAS!")
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	print("QUIT PASPAUSTAS!")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
