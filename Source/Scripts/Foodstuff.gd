extends RigidBody2D

@export var berryTexture:Texture2D
@export var shroomTexture:Texture2D
@export var leafTexture:Texture2D

var leaf_gravity = 0.3
var leaf_max_velocity = 10
var leaf_dampening = 20

var growthFactor = 1;

enum foodtype {none, berry, shroom, leaf}
#				0	  1	      2	    3
var my_foodtype = foodtype.none
var plate
var water
var my_foodtype_string
signal destroyed(my_type)
signal was_eaten(my_type)
# Called when the node enters the scene tree for the first time.
func _ready():
	#berryTexture = load("res://Sprites/Blueberry.png")
	#shroomTexture = load("res://Sprites/shroom.png")
	#leafTexture = load("res://Sprites/Leaf.png")
	scale = Vector2(0, 0)
	plate = get_node("/root/Café").get_node("Areas/Furniture")
	water = get_node("/root/Café").get_node("Areas/Water")
	plate.body_entered.connect(_on_enter_plate_range)
	water.body_entered.connect(_on_enter_water)

func _set_foodtype(my_type):
	my_foodtype = my_type
	var texturenode = $Sprite2D
	if my_foodtype == 1:
		texturenode.texture = berryTexture
		my_foodtype_string = "Blueberry"
		freeze = true
	if my_foodtype == 2:
		texturenode.texture = shroomTexture
		my_foodtype_string = "Shroom"
		freeze = true
	if my_foodtype == 3:
		gravity_scale = 0.2
		texturenode.texture = leafTexture
		my_foodtype_string = "Leaf"
		freeze = false

func _get_licked():
	freeze = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var scaleVector = scale + Vector2(delta, delta) * growthFactor
	scaleVector.x = clamp(scaleVector.x, 0, 1)
	scaleVector.y = clamp(scaleVector.y, 0, 1)
	scale = scaleVector
	

func _on_enter_plate_range(body):
	print(body)
	if(body != self):
		return
	was_eaten.emit(my_foodtype_string)
	destroyed.emit(my_foodtype)
	queue_free()

func _on_enter_water(body):
	print(body)
	if(body != self):
		return
	destroyed.emit(my_foodtype)
	queue_free()
