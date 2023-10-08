extends Node2D

@onready var guestScene = preload("res://Scenes/Objects/guest.tscn")
var guestList = []
var insectList = ["Worm", "Fly", "Cricket"]
var initialPos = Vector2(0,0)
var waiting = false
var guestCap = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_insect("Worm", "shroom")
	pass # Replace with function body.

func spawn_insect(insect, request):
	var guest = guestScene.instantiate()
	place_guest(guest)
	guest.setup(insect, request)
	add_child(guest)

func place_guest(guest):
	if guestList.is_empty():
		guest.position = initialPos
	else:
		guest.position = guestList.back().position - Vector2(0,24)
	guestList.push_back(guest)

func reorder_guests():
	var waitingList = guestList
	guestList = []
	for guest in waitingList:
		place_guest(guest)
	

func remove_guest(food):
	var satisfiedCustomer
	for n in range(guestList.size()):
		if guestList[n].get_request() == food:
			satisfiedCustomer = n
			break
	if satisfiedCustomer != null:
		guestList[satisfiedCustomer].kill()
		guestList.remove_at(satisfiedCustomer)
		reorder_guests()
		print("delete")

func spawn_timer():
	waiting = true
	var t = randi_range(2,5)
	var type = randi_range(0,2)
	await get_tree().create_timer(t).timeout
	spawn_insect(insectList[type], "shroom")
	waiting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !waiting && guestList.size() < guestCap:
		spawn_timer()
	pass
