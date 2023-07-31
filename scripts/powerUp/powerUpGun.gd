extends Area2D


# Esta funcion se ejecuta cuando el powerUp colisiona con algun cuerpo
func _on_body_entered(body):
	if body.is_in_group("player"):
		SoundFx.play_sound("res://assets/soundFx/powerUp_gun.wav")
		body.upgrade_gun()
		queue_free()
