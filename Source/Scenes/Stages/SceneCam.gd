extends Camera2D

var frog 


# Called when the node enters the scene tree for the first time.
func _ready():
	frog = get_node("../Frog")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if frog != null && frog.position.x > -1 && frog.position.x < 400:
		position.x = frog.position.x
		#position.y -= 100
