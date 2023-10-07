extends RigidBody2D

var jumpForce = 300;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_handleInput(delta)
	pass


func _handleInput(delta):
	var mouseposition = get_global_mouse_position()
	var relativeMouseposition = position - mouseposition
	var jumpVelocity = Vector2(0,0) 
	jumpVelocity = -relativeMouseposition.normalized() * jumpForce
	
	if(Input.is_action_just_pressed("jump")):
		print("Jumped! " + str(jumpVelocity))
		linear_velocity = jumpVelocity;
	
	
	pass


