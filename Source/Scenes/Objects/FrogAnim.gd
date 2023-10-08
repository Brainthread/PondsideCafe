extends AnimatedSprite2D

var ground_zone
var anim_player
var frog
var playing 
var prevY
var in_water
var landing_bleh 


# Called when the node enters the scene tree for the first time.
func _ready():
	frog = get_node("../../Frog")
	frog.jumping.connect(_on_jump)
	frog.lick_start.connect(_on_lick_start)
	frog.lick_end.connect(_on_lick_end)
	frog.enter_water.connect(_on_water_enter)
	frog.exit_water.connect(_on_water_exit)	
	frog.drag_start.connect(_on_drag_start)	
	ground_zone = get_node("../Groundcheck")
	
	in_water = false
	landing_bleh = false

func _eval_anim():
	# If the frog is currently jumping in an upwards direction
	if animation == "Jump-start" || animation == "Exit-Swim":
		if frog.position.y > prevY:
			play("Down")
			playing = "Down"
		else:
			prevY = frog.position.y
	# If the frog is currently jumping in a downwards direction	
	if (animation == "Down" || landing_bleh ) && ground_zone._is_on_ground():
		landing_bleh = false
		if in_water:
			play("Dive")
		else:
			play("Land")

func _on_frog_anim_animation_finished():
	if animation == "Land":
		play("Idle")
	if animation == "Dive":
		play("Swim")
	if animation == "Bleh":
		landing_bleh = true
	
func _on_jump():
	if(in_water):
		play("Exit-Swim")
	else:
		play("Jump-start")
	prevY = frog.position.y
	
func _on_lick_start():
	if !in_water && animation != "Bleh":
		play("Blem")
	
func _on_lick_end():
	if !in_water && animation != "Bleh":
		play("Idle")

func _on_water_enter():
	in_water = true

func _on_water_exit():
	in_water = false
	
func _on_drag_start():
	print("bleh")
	play("Bleh")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_eval_anim()
	pass
