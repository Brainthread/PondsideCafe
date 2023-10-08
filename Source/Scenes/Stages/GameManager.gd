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
	$SceneCam/GameOver.hide()
	
func increse_score(i):
	score += i


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time -= delta
	displayTime = round(time)
	if(displayTime<0):
		displayTime = round(0+0.1)
	$SceneCam/Time.text = str(displayTime)
	$SceneCam/Score.text = str(score)

	if(time <= 0):
		$SceneCam/Time.hide()
		$SceneCam/Score.hide()	
		time = 0
		displayScoreTime -= delta
		$SceneCam/GameOver.show()
		$SceneCam/GameOver/GameOver.text = "Final Score: " + str(score)
	if(displayScoreTime < 0):
		get_tree().change_scene_to_file("res://Scenes/main-menu.tscn")
