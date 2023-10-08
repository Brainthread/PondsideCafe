extends StaticBody2D
var requestNode
var insectType = ""
var requestType = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(insect, request):
	var requestScene = preload("res://Scenes/Objects/request.tscn")
	var anim = get_node("InsectAnim")
	requestNode = requestScene.instantiate()
	insectType = insect
	requestType = request
	
	requestNode.setup(requestType)
	requestNode.position.x -= 30
	add_child(requestNode)
	
	anim.play(insect)

func get_request():
	return requestType

func satisfy():
	requestNode.pop()

func kill():
	queue_free() #:(

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
