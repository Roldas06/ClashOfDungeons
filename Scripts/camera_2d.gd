extends Camera2D

var zoom_speed := 0.3
var min_zoom := 4   # maximum zoom in
var max_zoom := 8   # maximum zoom out

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoom_speed, zoom_speed) # zoom in
			
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoom_speed, zoom_speed) # zoom out

		# apply limits
		zoom.x = clamp(zoom.x, min_zoom, max_zoom)
		zoom.y = clamp(zoom.y, min_zoom, max_zoom)
