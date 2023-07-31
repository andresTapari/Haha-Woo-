extends Control

func _ready():
	# Reiniciamos puntaje
	Score.set("score",0)

func _on_setting_btn_pressed():
#	get_tree().change_scene_to_file("res://scenes/lvl/dev_lvl.tscn")
	pass

# Esta función se ejecuta cuando se presiona el boton PLAY, inicia el juego 
func _on_play_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/lvl/dev_lvl.tscn")
