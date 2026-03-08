extends Panel

@onready var sprite = $Sprite2D


func _ready():
	pass

#Širdučių atnaujinimo funkcija 
#HeartState - Širdutės stadija (pilna/tuščia/pusė)
#Pilna - 0
#Pusė - 2
#Tuščia - 4
func Update(state: int):
	sprite.frame = state 
