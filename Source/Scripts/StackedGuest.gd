extends Node2D

@onready var guestScene = preload("res://Scenes/Objects/guest.tscn")
@onready var audio = get_node("AudioStreamPlayer2D")

var eat = load("res://Audio/eat.wav")
var customer_hates = load("res://Audio/Customer_hates.wav")
var customer_likeys = load("res://Audio/Customer_likeys.wav")

var guestList = []
var insectList = ["Worm", "Fly", "Cricket"]
var requestList = ["Leaf", "Blueberry", "Shroom"]
var initialPos = Vector2(0,0)
var waiting = false
var guestCap = 10
var satisfying

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_insect("Worm", "Shroom")
	satisfying = false
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
	while satisfying:
		await get_tree().create_timer(0.1).timeout
	satisfying = true
	var satisfiedCustomer
	for n in range(guestList.size()):
		if guestList[n].get_request() == food:
			satisfiedCustomer = n
			break
	if satisfiedCustomer != null:
		get_node("../../Café").increse_score(20)
		remove_from_list(satisfiedCustomer)
		audio.stream = customer_likeys
	satisfying = false
	audio.play()

func remove_dissatisfied_guest(guest):
	audio.stream = eat
	audio.play()
	while satisfying:
		await get_tree().create_timer(0.1).timeout
	satisfying = true
	var dissatisfiedCustomer = guestList.find(guest)
	remove_from_list(dissatisfiedCustomer)
	satisfying = false
	audio.stream = customer_hates
	audio.play()

func remove_from_list(guest_no):
	guestList[guest_no].satisfy()
	await get_tree().create_timer(0.4).timeout
	guestList[guest_no].kill()
	guestList.remove_at(guest_no)
	reorder_guests()


func spawn_timer():
	waiting = true
	var t = randi_range(5,20)
	var i_type = randi_range(0,2)
	var r_type = randi_range(0,2)
	await get_tree().create_timer(t).timeout
	spawn_insect(insectList[i_type], requestList[r_type])
	waiting = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !waiting && guestList.size() < guestCap && !satisfying:
		spawn_timer()
	pass

func _on_furniture_body_entered(body):
	var food = body.get_food_name()
	if food == "Blueberry" || food == "Shroom" || food == "Leaf":
		remove_guest(food)
