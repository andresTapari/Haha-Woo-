extends Area2D

@export var heal_amount :int = 1

func _on_body_entered(body):
	if body.is_in_group("player"):
		SoundFx.play_sound("res://assets/soundFx/powerUp_life.wav")
		body.heal(heal_amount)
		queue_free()
