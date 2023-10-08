extends Node2D
var orderRequest = ""
var orderComplete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func pop():
	remove_child($Order) 
	$SpeechBubble.play("Pop")

func angry():
	$SpeechBubble.play("Angry")

func setup(request):
	orderRequest = request
	$Order.position.x -= 2
	$Order.texture = load("res://Sprites/" + orderRequest + ".png")
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
