extends RigidBody2D

@export var jumpForce:int = 300
@export var groundCheckDistance:int = 10
@export var fullMouseDistance:int = 150
var groundRay
var groundZone


# Called when the node enters the scene tree for the first time.
func _ready():
	groundRay = get_node("Groundray")
	groundZone = get_node("Area2D")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_handleInput(delta)
	pass


func _handleInput(delta):
	var mouseposition = get_global_mouse_position()
	var relativeMouseposition = position - mouseposition
	var relativeMagnitude = relativeMouseposition.length()/fullMouseDistance
	if(relativeMagnitude>1):
		relativeMagnitude = 1
	var jumpVelocity = Vector2(0,0) 
	jumpVelocity = -relativeMouseposition.normalized() * jumpForce * relativeMagnitude
	
	var jumpAllowed = _jumpAllowed();
	if(Input.is_action_just_pressed("jump")&&jumpAllowed):
		linear_velocity = jumpVelocity;
	pass

func _jumpAllowed():
	if(groundZone._is_on_ground()):
		return true
	return false
