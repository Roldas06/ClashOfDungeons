extends Control

func _ready():
	# Pradžioje meniu turi būti paslėptas
	hide()

func _process(_delta):
	# Tikriname ESC (ar tavo "pause" action) kiekvieną kadrą
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func resume():
	get_tree().paused = false
	hide() # Paslepiame meniu

func pause():
	get_tree().paused = true
	show() # Parodome meniu

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume() # Svarbu atšaukti pauzę prieš perkraunant sceną!
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
