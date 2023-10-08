extends Node2D

@export var max_berries:int = 5
@export var max_shrooms:int = 4
@export var max_leaves:int = 4

@export var itemSpawnTime:int = 3
@export var berrySpawnArea:Vector4
@export var leafSpawnArea:Vector4
@export var shroomSpawnArea:Vector4

var berryTimer = 3
var shroomTimer = 3
var leafTimer = 2

var berries = 0
var shrooms = 0
var leaves = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	berryTimer -= delta
	shroomTimer -= delta
	leafTimer -= delta
	if(berryTimer < 0):
		berryTimer = itemSpawnTime
		if berries < max_berries:
			_spawn_item(1)
	if(shroomTimer < 0):
		shroomTimer = itemSpawnTime
		if shrooms < max_shrooms:
			_spawn_item(2)
	if(leafTimer < 0):
		leafTimer = itemSpawnTime
		if leaves < max_leaves:
			_spawn_item(3)
	pass
	
func _on_item_was_destroyed(food_type):
	print("Food was destroyed: " + str(food_type))
	if food_type == 1:
		berries -= 1
	if food_type == 2:
		shrooms -= 1
	if food_type == 3:
		leaves -= 1
	
	
func _spawn_item(type):
	var spawnPosition = Vector2()
	var spawnRange
	var foodinstance = load("res://Scenes/Objects/food.tscn").instantiate()
	if type == 1:
		berries += 1
		spawnRange = berrySpawnArea
	if type == 2:
		shrooms += 1
		spawnRange = shroomSpawnArea
	if type == 3:
		leaves += 1
		spawnRange = leafSpawnArea
	spawnPosition = Vector2(randi_range(spawnRange.x, spawnRange.y), randi_range(spawnRange.z, spawnRange.w))
	add_child(foodinstance)
	foodinstance.set_name("Food " + str(type) + "-")
	foodinstance.position = spawnPosition
	foodinstance.destroyed.connect(_on_item_was_destroyed)
	foodinstance._set_foodtype(type)

