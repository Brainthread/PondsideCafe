extends CanvasLayer

@onready var credits = $Credits
@onready var main = $Main

func _on_credit_pressed():
	main.visible = false
	credits.visible = true

func _on_new_game_pressed():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/Stages/café.tscn")
