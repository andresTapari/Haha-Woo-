extends Control

func _ready():
	%ScoreLabel.text = str(Score.get("score"))

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
