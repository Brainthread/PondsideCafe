extends CanvasLayer

@onready var credits = $Credits
@onready var main = $Main
@onready var settings = $"../Settings"

func _on_credit_pressed():
	main.visible = false
	credits.visible = true

func _on_new_game_pressed():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/Stages/café.tscn")

func _on_return_pressed():
	main.visible = true
	credits.visible = false

func _on_return_pressed2():
	main.visible = true
	settings.visible = false


func _on_settings_pressed():
	main.visible = false
	settings.visible = true
