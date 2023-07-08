extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_update_health_value_ui(current_health):
	$healthBar.update_draw(current_health)
	$Face_icon.handle_player_hit(current_health)
	$special_1.update_special(1,current_health)
	await  $Face_icon/AnimatedSprite2D.animation_finished
	$Face_icon.update_draw(current_health)
