extends Node2D

@onready var guestScene = preload("res://Scenes/guest.tscn")
var guestList = []
var initialPos = Vector2(0,0)
var waiting = false
var guestCap = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnInsect("worm", "shroom")
	pass # Replace with function body.

func spawnInsect(insect, request):
	var guest = guestScene.instantiate()
	if guestList.is_empty():
		guest.position = initialPos
	else:
		guest.position = guestList.back().position - Vector2(0,24)
	guest.setup(insect, request)
	add_child(guest)
	
	
	guestList.push_back(guest)

func spawnTimer():
	waiting = true
	var t = randf_range(5,20)
	await get_tree().create_timer(t).timeout
	spawnInsect("worm", "shroom")
	waiting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !waiting && guestList.size() < guestCap:
		spawnTimer()
	pass
