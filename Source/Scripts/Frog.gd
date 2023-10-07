extends RigidBody2D

@export var jump_force:int = 300
@export var ground_check_distance:int = 10
@export var full_mouse_distance:int = 150
@export var tongue_speed:int = 900
@export var frog_lick_force = 300
@export var target_lick_type:int = 0
@export var grapple_termination_threshold:int = 5
var lick_area
var licked_on = false;
var lick_target_distance
var lick_target_interpolation = 0
var lick_target
var tongue_position = Vector2(0,0)
var tongueTarget
var tongueLine  
var ground_ray
var ground_zone

# Called when the node enters the scene tree for the first time.
func _ready():
	ground_ray = get_node("Groundray")
	ground_zone = get_node("Groundcheck")
	tongueTarget = get_node("TongueTarget")
	tongueLine = get_node("Line2D")
	lick_area = get_node("LickCheck")
	tongue_position = Vector2(0, 0)

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_handleLick(delta)
	_handleInput(delta)

func _handleLick(delta):
	if(licked_on):
		var relative_position = lick_target - position
		tongueTarget.position = relative_position
		tongueLine.points[1] = tongue_position
		lick_target_interpolation += delta*tongue_speed/lick_target_distance
		if(lick_target_interpolation > 1):
			lick_target_interpolation = 1
		tongue_position = lerp(Vector2(12, 2), lick_target-position, lick_target_interpolation)
		lick_area.position = tongue_position
		_handle_lick_collision(delta)
		if target_lick_type == 1:
			_handle_lick_draggable(delta, relative_position)
		if target_lick_type == 2:
			_handle_lick_attachment(delta, relative_position)
		if target_lick_type == 0 && lick_target_interpolation == 1:
			_reset_lick()
	else:
		gravity_scale = 0.3
	tongueTarget.visible = licked_on
	tongueLine.visible = licked_on
	lick_area.visible = licked_on

func _handle_lick_attachment(delta, relative_position):
	gravity_scale = 0
	linear_velocity = relative_position.normalized() * frog_lick_force
	if lick_target.distance_to(position) < grapple_termination_threshold:
		_reset_lick()
	
func _handle_lick_draggable(delta, relative_position):
	
	pass

func _handle_lick_collision(delta):
	var lick_type = lick_area._is_licking()
	if(lick_type == 0||target_lick_type != 0):
		return
	target_lick_type = lick_type
	lick_target = tongue_position + position
	if(lick_type == 1):
		print("Lick Draggable")
	if(lick_type == 2):
		print("Lick Attachment")

func _handleInput(delta):
	var mouse_position = get_global_mouse_position()
	var jumpAllowed = _jumpAllowed();
	if(Input.is_action_just_pressed("jump")&&jumpAllowed):
		_jump(mouse_position)
	if(Input.is_action_just_pressed("lick")):
		_lick(mouse_position)

func _lick(mouse_position):
	_reset_lick()
	lick_target = mouse_position
	lick_target_distance = (mouse_position - position).length()
	licked_on = true

func _reset_lick():
	target_lick_type = 0
	licked_on = false
	tongue_position = Vector2(12, 2)
	lick_area.position = tongue_position
	lick_target_interpolation = 0

func _jump(mouse_position):
	var relative_mouse_position = position - mouse_position
	var relative_magnitude = relative_mouse_position.length()/full_mouse_distance
	if(relative_magnitude>1):
		relative_magnitude = 1
	var jump_velocity = Vector2(0,0) 
	jump_velocity = -relative_mouse_position.normalized() * jump_force * relative_magnitude
	linear_velocity = jump_velocity;

func _jumpAllowed():
	if(ground_zone._is_on_ground()):
		return true
	return false
