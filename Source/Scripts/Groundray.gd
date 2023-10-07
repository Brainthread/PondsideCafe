extends RayCast2D

var isOnGround = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	isOnGround = false
	if(is_colliding()):
		var collider = get_collider()
		isOnGround = true


func _is_on_ground ():
	return isOnGround
