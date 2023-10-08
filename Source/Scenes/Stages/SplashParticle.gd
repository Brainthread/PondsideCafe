extends RigidBody2D

enum splash_size {small, medium, large}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func setup(size):
	var speed = 0.6 + (float(size)/3)
	var splash_type = randi_range(1,2)
	$ParticleTexture.texture = load("res://Sprites/splash_" + str(splash_type) + ".png")
	var splash_dir_x = randf_range(-1* (speed),speed)
	var splash_dir_y = randf_range(-1 * (speed),0)
	linear_velocity = Vector2(splash_dir_x,splash_dir_y) * 200
	await get_tree().create_timer(size).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
