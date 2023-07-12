extends Area2D

# Señal
signal lvl_transition(dir)

enum direction {up_lvl, down_lvl}
@export var set_direction: direction

func _on_body_entered(body):
	if(body.is_in_group("player")):
		emit_signal("lvl_transition",set_direction)
