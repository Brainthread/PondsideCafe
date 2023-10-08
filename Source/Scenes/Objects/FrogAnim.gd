extends AnimatedSprite2D

var ground_zone
var anim_player
var frog
var playing 
var prevY


# Called when the node enters the scene tree for the first time.
func _ready():
	frog = get_node("../../Frog")
	frog.jumping.connect(_on_jump)
	ground_zone = get_node("../Groundcheck")
	pass # Replace with function body.

func _eval_anim():
	# If the frog is currently jumping in an upwards direction
	if animation == "Jump-start":
		if frog.position.y > prevY:
			play("Down")
			playing = "Down"
		else:
			prevY = frog.position.y
	# If the frog is currently jumping in a downwards direction	
	if animation == "Down" && ground_zone._is_on_ground():
		play("Land")

func _on_frog_anim_animation_finished():
	print("eyo")
	if animation == "Land":
		play("Idle")
	
func _on_jump():
	play("Jump-start")
	playing = "Jump-start"
	prevY = frog.position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_eval_anim()
	pass
