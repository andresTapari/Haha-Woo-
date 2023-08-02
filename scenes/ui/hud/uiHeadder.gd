extends CanvasLayer

var PAUSE_DLG = preload("res://scenes/ui/dlg/pause_dlg.tscn")

var current

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("pause"):
			if not get_tree().get("paused"):
				# Si no esta en pausa
				var newPauseDlg = PAUSE_DLG.instantiate()
				add_child(newPauseDlg)
			get_tree().set("paused",not(get_tree().get("paused")))


func _on_player_update_ui(data: Dictionary):
	var current_health = data["health"]
	var muzzle_stage = data["muzzle_stage"]
	$healthBar.update_draw(current_health)
	$Face_icon.handle_player_hit(current_health)
	$special_1.update_special(muzzle_stage,current_health)
	$special_2.update_special(current_health)
	await  $Face_icon/AnimatedSprite2D.animation_finished
	$Face_icon.update_draw(current_health)

func _update_score(new_score: int) -> void:
	$ScoreLabel.update_score(new_score)
