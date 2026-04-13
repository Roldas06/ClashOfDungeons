extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_buttons.visible = true
	options.visible = false




func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_button_options_pressed() -> void:
	main_buttons.visible = false
	options.visible = true


func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_back_options_pressed() -> void:
	_ready()


func _on_full_screen_control_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
