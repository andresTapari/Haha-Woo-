extends Control

@onready var SETUP_DIALOG = preload("res://scenes/ui/dlg/setup_dlg.tscn")

func _ready():
	# Reiniciamos puntaje
	Score.set("score",0)

# Esta función se ejecuta cuando se presiona el boton PLAY, inicia el juego 
func _on_play_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/lvl/levels/tutorial_level.tscn")

# Esta funcion se ejecuta cuando se presiona el botón, SETTINGS
func _on_setting_btn_pressed():
	var setup_dialog = SETUP_DIALOG.instantiate()
	add_child(setup_dialog)

