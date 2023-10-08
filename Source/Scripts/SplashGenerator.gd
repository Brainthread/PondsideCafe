extends Node2D
var splash

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func setup(size):
	splash = preload("res://Scenes/Objects/splash_particle.tscn")
	for n in range(size*6):
		var splashy = splash.instantiate()
		add_child(splashy)
		splashy.setup(size)
		splashy.position = Vector2(0,0)
	await get_tree().create_timer(size).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
