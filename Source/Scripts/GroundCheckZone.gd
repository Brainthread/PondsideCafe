extends Area2D

signal grounded()
var isOnGround = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	isOnGround = false
	for body in get_overlapping_bodies():
		if(!isOnGround):
			emit_signal("grounded")
			isOnGround = true
			

func _is_on_ground ():
	return isOnGround

func _on_grounded ():
	pass
