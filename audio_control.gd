extends HSlider

@export var audio_bus_name: String
var audio_bus_id

func _ready():
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
