extends Node2D

var time = 120.0
var displayTime = 120
var displayScoreTime = 10
var score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	time = 120.0
	displayTime = 120
	displayScoreTime = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time -= delta
	displayTime = round(time)
	if(displayTime<0):
		displayTime = 0
	$SceneCam/Label.text = str(displayTime)
	$SceneCam/Label2.text = str(score)
	if(time <= 0):
		time = 0
		displayScoreTime -= delta
	if(displayScoreTime < 0):
		get_tree().change_scene_to_file("")
