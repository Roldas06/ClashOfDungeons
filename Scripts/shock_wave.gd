extends Area2D

var max_radius = 80.0
var expand_speed = 150.0
var current_radius = 0.0

func _ready():
	_draw_circle(0.0)

func _physics_process(delta):
	current_radius += expand_speed * delta
	current_radius = min(current_radius, max_radius)
	_draw_circle(current_radius)
	
	if current_radius >= max_radius:
		queue_free()

func _draw_circle(radius):
	var line = $Line2D
	line.clear_points()
	var points = 32
	for i in range(points + 1):
		var angle = (float(i) / points) * TAU
		line.add_point(Vector2(cos(angle), sin(angle)) * radius)
	line.width = 3.0
	line.default_color = Color(1, 1, 1, 0.8) 
