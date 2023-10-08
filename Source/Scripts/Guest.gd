extends StaticBody2D
var requestNode
var insectType = ""
var requestType = ""
var timer 
var inc_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(insect, request):
	var requestScene = preload("res://Scenes/Objects/request.tscn")
	var anim = get_node("InsectAnim")
	requestNode = requestScene.instantiate()
	insectType = insect
	requestType = request
	inc_timer = true
	
	requestNode.setup(requestType)
	requestNode.position.x -= 30
	add_child(requestNode)
	
	anim.play(insect)
	timer = 0
	
	
func _get_angry():
	requestNode.angry()
	
func _get_pissed():
	requestNode.pop()
	get_parent().remove_dissatisfied_guest(self)
	
func get_request():
	return requestType

func satisfy():
	timer = 0
	inc_timer = false
	requestNode.pop()

func kill():
	queue_free() #:(

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > 20:
		_get_angry()
	if timer > 30:
		_get_pissed()
		timer = 0
		inc_timer = false
		
	pass
