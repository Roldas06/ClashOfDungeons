extends HBoxContainer

@onready var HeartGuiClass = preload("res://Scenes/heart_gui.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
#Užpildo žaidėjo širdutes pagal žaidėjo gyvybės taškų skaičių. 
#1 gyvybės taškas - pusė širdutės
func SetMaxHearts(maxHealthPoints: int):
	var heartCount = ceil(maxHealthPoints / 4.0)
	for i in range(heartCount):
		var heart = HeartGuiClass.instantiate()
		add_child(heart)
		

#Atnaujina širdučių kiekį pagal dabartinį gyvybių skaičių

func UpdateHearts(currentHealth: int):
	var hearts = get_children()
	
	for i in range(hearts.size()):
		var heartStartHealth = i * 4 #kiekviena širdutė turi 4gyvybės taškus
		
		if currentHealth >= heartStartHealth + 4:
			# Pilna širdutė
			hearts[i].Update(0)
		elif currentHealth >= heartStartHealth + 2:
			# Pusė širdutės
			hearts[i].Update(2)
		else:
			# Tuščia širdutė
			hearts[i].Update(4)
