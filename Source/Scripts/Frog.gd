extends RigidBody2D

@export var horizontal_jump_force:int = 180
@export var vertical_jump_force:int = 400
@export var ground_check_distance:int = 10
@export var full_mouse_distance:int = 20
@export var tongue_speed:int = 900
@export var frog_lick_force = 300
@export var target_lick_type:int = 0
@export var grapple_termination_threshold:int = 5
@export var grapple_drag_speed = 500
var lick_area
var licked_on = false;
var lick_target_distance
var lick_drag_node
var lick_target_interpolation = 0
var lick_target
var tongue_position = Vector2(0,0)
var tongueLine  
var ground_ray
var ground_zone
var direction = -1

#Animation
signal jumping
signal lick_start
signal lick_end
signal enter_water
signal exit_water
signal drag_start


# Called when the node enters the scene tree for the first time.
func _ready():
	ground_ray = get_node("Groundray")
	ground_zone = get_node("Groundcheck")
	tongueLine = get_node("Line2D")
	lick_area = get_node("LickCheck")
	tongue_position = Vector2(0, 0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_handleLick(delta)
	_handleInput(delta)

func _handleLick(delta):
	if(licked_on):
		if(lick_drag_node!=null):
			lick_target = lick_drag_node.position
		var relative_position = lick_target - position
		tongueLine.points[1] = tongue_position
		tongueLine.points[0] = Vector2(12*direction, 2)
		lick_target_interpolation += delta*tongue_speed/lick_target_distance
		if(lick_target_interpolation > 1):
			lick_target_interpolation = 1
		tongue_position = lerp(Vector2(12*direction, 2), lick_target-position, lick_target_interpolation)
		lick_area.position = tongue_position
		_handle_lick_collision(delta)
		if target_lick_type == 1:
			_handle_lick_draggable(delta, relative_position)
		if target_lick_type == 2:
			_handle_lick_attachment(delta, relative_position)
		if target_lick_type == 0 && lick_target_interpolation == 1:
			_reset_lick()
	else:
		gravity_scale = 0.5
	tongueLine.visible = licked_on
	lick_area.visible = licked_on

func _handle_lick_attachment(delta, relative_position):
	gravity_scale = 0.3
	linear_velocity = relative_position.normalized() * frog_lick_force
	if lick_target.distance_to(position) < grapple_termination_threshold:
		_reset_lick()
	
func _handle_lick_draggable(delta, relative_position):
	if lick_drag_node == null || !lick_drag_node.is_in_group("Draggables"):
		_reset_lick()
		return
	lick_drag_node._get_licked()
	var relative_object_position = lick_drag_node.position - position
	var relative_normal = relative_position.normalized()
	lick_drag_node.linear_velocity = grapple_drag_speed * -relative_normal
	if lick_target.distance_to(position) < grapple_termination_threshold:
		_reset_lick()

func _handle_lick_collision(delta):
	var lick_type = lick_area._is_licking()
	if(lick_type == 0||target_lick_type != 0):
		return
	target_lick_type = lick_type
	lick_target = tongue_position + position
	lick_target_interpolation = 1
	if(lick_type == 1):
		print("Lick Draggable")
		lick_drag_node = lick_area._get_licked_body()
	if(lick_type == 2):
		drag_start.emit()

func _handleInput(delta):
	var mouse_position = get_global_mouse_position()
	if((mouse_position - position).x < 0):
		get_node( "FrogAnim" ).set_flip_h(true)
		direction = -1
	if((mouse_position - position).x > 0):
		get_node( "FrogAnim" ).set_flip_h(false)
		direction = 1
	var jumpAllowed = _jumpAllowed();
	if(Input.is_action_just_pressed("jump")&&jumpAllowed):
		_jump(mouse_position)
	if(Input.is_action_just_pressed("lick")):
		_lick(mouse_position)
	if(Input.is_action_just_released("lick")):
		_reset_lick()

func _lick(mouse_position):
	if(licked_on):
		_reset_lick()
		return
	lick_start.emit()
	var target_direction = (mouse_position - position).normalized()
	lick_target = mouse_position + target_direction*64
	lick_target_distance = (mouse_position - position).length()
	licked_on = true

func _reset_lick():
	lick_end.emit()
	lick_drag_node = null
	target_lick_type = 0
	licked_on = false
	tongue_position = Vector2(12, 2)
	lick_area.position = tongue_position
	lick_target_interpolation = 0

func _jump(mouse_position):
	var relative_mouse_position = (position-mouse_position)/full_mouse_distance
	var mousex = relative_mouse_position.x
	var mousey = relative_mouse_position.y
	if mousey < 0.5:
		mousey = 0.5
	mousey = clamp(mousey, -1, 1)
	mousex = clamp(mousex, -1, 1)
	var relative_h_magnitude = mousex
	var relative_v_magnitude = mousey
	var jump_velocity = Vector2(0,0) 
	jump_velocity.x = (-relative_h_magnitude) * horizontal_jump_force
	jump_velocity.y = (-relative_v_magnitude) * vertical_jump_force
	linear_velocity = jump_velocity
	jumping.emit()
	

func _jumpAllowed():
	if(ground_zone._is_on_ground()):
		return true
	return false

func _on_water_area_exited(area):
	exit_water.emit()

func _on_water_area_entered(area):
	enter_water.emit()
	var splash = load("res://Scenes/Objects/splash_generator.tscn").instantiate()
	add_child(splash)
	splash.setup(2)
