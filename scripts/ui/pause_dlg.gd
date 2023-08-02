extends MarginContainer

@onready var SETUP_DIALOG = preload("res://scenes/ui/dlg/setup_dlg.tscn")


func _on_setting_btn_pressed():
	var setup_dialog = SETUP_DIALOG.instantiate()
	add_child(setup_dialog)

func _on_exit_btn_pressed():
	get_tree().set("paused",false)
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")

func _on_back_to_game_btn_pressed():
	get_tree().set("paused",false)
	queue_free()

