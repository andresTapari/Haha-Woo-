extends Node2D

# Señal
signal lvl_transition(dir)
signal pause_request()

# Parametros
enum dir {player_out = 0, player_in = 1}
var direction: dir

var flag_A: bool = false
var flag_B: bool = false

var is_open: bool = false				# bandera de la perta

func _on_body_entered(body):
	if(body.is_in_group("player")):
		emit_signal("lvl_transition",direction)

func _on_first_area_body_entered(body):
	if not body.is_in_group("player"):
		return
	flag_A = true
	check_direction(body)

func _on_second_area_body_entered(body):
	if not body.is_in_group("player"):
		return
	flag_B = true
	check_direction(body)

func check_direction(body):
	if flag_A and flag_B:
		return

	if flag_A and not flag_B:
		emit_signal("lvl_transition",dir.player_out)
		%CollisionShape2D.set_deferred("disabled",false)

	if flag_B and not flag_A:
		emit_signal("lvl_transition",dir.player_in)
		# Al entrar a una sala inicio un movimiento automatico hacia la pausa
		body.set_target_to_move($target_to_move.global_position)
		%CollisionShape2D.set_deferred("disabled",false)
		
# Esta funcion reestablece el estado de pase de player 
# por la puerta
func reset():
	flag_A = false
	flag_B = false

# Esta funcion abre la puerta
func open():
	if not is_open:
		is_open = true
		%AnimationPlayer.play("door_open")

# Esta funcion cierra la puerta
func close():
	if is_open:
		is_open = false
		%AnimationPlayer.play("door_close")


# Esta función se ejecuta cuando body entra en la zona.
func _on_pause_area_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("pause_request")
		%CollisionShape2D.set_deferred("disabled",true)
