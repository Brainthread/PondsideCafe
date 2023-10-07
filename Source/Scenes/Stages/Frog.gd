extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_handleInput(delta)
	pass


func _handleInput(delta):
	var mouseposition = get_viewport().get_mouse_position()
	var relativeMouseposition = position - mouseposition
	if(Input.is_action_just_pressed("jump")):
		print(relativeMouseposition)
	
	
	pass


