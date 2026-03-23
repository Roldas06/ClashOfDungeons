extends Panel

func _process(delta: float) -> void:
	# Tikriname, ar žaidėjas paspaudė mūsų sukurtą "toggle_help" mygtuką (H raidę)
	if Input.is_action_just_pressed("toggle_help"):
		# Ši eilutė apverčia matomumą: jei buvo nematomas - tampa matomas, ir atvirkščiai
		visible = !visible
