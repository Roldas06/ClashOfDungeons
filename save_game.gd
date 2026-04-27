extends Node

func save_game():
	var save_data = {
		"unlocked_levels": Global.unlocked_levels,
		"maxHealthPoints": Global.maxHealthPoints,
		"attack_damage": Global.attack_damage,
		"projectile_damage": Global.projectile_damage
	}
	
	var file = FileAccess.open("user://save_game.json", FileAccess.WRITE)
	
	if file == null:  # add this check
		print("ERROR: Could not open file! Error: ", FileAccess.get_open_error())
		return
	
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Saved to: ", ProjectSettings.globalize_path("user://save_game.json"))  # prints exact path
	print("game saved")
	
func load_game():
	if not FileAccess.file_exists("user://save_game.json"):
		print("No save file found")
		return
		
	var file = FileAccess.open("user://save_game.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	
	Global.unlocked_levels = data["unlocked_levels"]
	Global.maxHealthPoints = data["maxHealthPoints"]
	Global.attack_damage = data["attack_damage"]
	Global.projectile_damage = data["projectile_damage"]
	print("game loaded")
