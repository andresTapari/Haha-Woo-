extends Node2D

# Señal
signal lvl_transition(dir)

# Parametros
enum dir {player_out = 0, player_in = 1}
var direction: dir

var flag_A: bool = false
var flag_B: bool = false

func _on_body_entered(body):
	if(body.is_in_group("player")):
		emit_signal("lvl_transition",direction)

func _on_first_area_body_entered(body):
	if not body.is_in_group("player"):
		return
	flag_A = true
	check_direction()

func _on_second_area_body_entered(body):
	if not body.is_in_group("player"):
		return
	flag_B = true
	check_direction()

func check_direction():
	if flag_A and flag_B:
		return

	if flag_A and not flag_B:
		emit_signal("lvl_transition",dir.player_out)

	if flag_B and not flag_A:
		emit_signal("lvl_transition",dir.player_in)

func reset():
	flag_A = false
	flag_B = false
