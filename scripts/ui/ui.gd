extends Control

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
