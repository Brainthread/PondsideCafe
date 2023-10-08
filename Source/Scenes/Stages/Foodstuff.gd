extends RigidBody2D

@export var berryTexture:Texture2D
@export var shroomTexture:Texture2D
@export var leafTexture:Texture2D

@export var leaf_gravity:int = 0.3
@export var leaf_max_velocity: int = 10
@export var leaf_dampening:int = 20

@export var growthFactor = 1;

enum foodtype {none, berry, shroom, leaf}
#				0	  1	      2	    3
var my_foodtype = foodtype.none
var plate
var water
signal destroyed
signal was_eaten(my_type)
# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(0, 0)
	freeze = true;
	plate = get_node("/root/Café").get_node("Areas/Furniture")
	water = get_node("/root/Café").get_node("Areas/Water")
	plate.body_entered.connect(_on_enter_plate_range)
	water.body_entered.connect(_on_enter_water)

func _set_foodtype(my_type):
	my_foodtype = my_type
	var texturenode = $Sprite2D
	if my_foodtype == 1:
		texturenode.texture = berryTexture
	if my_foodtype == 2:
		texturenode.texture = shroomTexture
	if my_foodtype == 3:
		texturenode.texture = leafTexture

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
	var my_foodtype_string = ""
	
	was_eaten.emit(my_foodtype)
	destroyed.emit()
	queue_free()

func _on_enter_water(body):
	print(body)
	if(body != self):
		return
	destroyed.emit()
	queue_free()
