extends Node2D

var enemy_on_screen_list: Array = []			#Lista de enemigos en pantalla

func _ready():
	connect_enemys_to_score_ui()
	connect_enemys_to_doors()
	connect_lvls_to_lvls_transitions_and_pause()

# Esta función conecta los enemigos con el hud
func connect_enemys_to_score_ui():
	var enemy_list: Array = get_tree().get_nodes_in_group("enemy")
	for enemy in enemy_list:
		enemy.update_score.connect(handle_enemy_score_update_signal)

# Esta funcón conecta los niveles (rooms) con la cámara
func connect_lvls_to_lvls_transitions_and_pause():
	var lvl_list: Array = get_tree().get_nodes_in_group("level")
	for lvl in lvl_list:
		lvl.change_lvl.connect(handle_change_lvl_signal)
		lvl.pause_request.connect(handle_pause_request)

# Esta función conecta los enemigos con las puertas
func connect_enemys_to_doors():
	var enemy_lst: Array = get_tree().get_nodes_in_group("enemy")
	for enemy in enemy_lst:
		enemy.screen_update.connect(handle_enemy_screen_update)

# Esta función actualiza el puntaje del jugador:   
# Cuando un enemigo se destruye transmite su valor de puntaje
# al puntaje del jugador
func handle_enemy_score_update_signal(new_score):
	$uiHeadder._update_score(new_score)


# Esta funcion toma la señal que envian los niveles de cambiar nivel, 
# y ejecuta la función en la camara, para que se mueve a la siguiente 
# habitación.
func handle_change_lvl_signal(direction,camera_position):
	if direction == 1:
		$Camera2D.travel_to_next_lvl(camera_position)
		reset_doors()

# Esta función permite abrir y cerrar puertas (se cerraran y abriran TODAS
# las puertas de todas las salas) cuando los enemigos aparezcan y desaparezcan
# en pantalla.
func handle_enemy_screen_update(enemy, flag: bool) -> void:
	if flag: # Si enemigos aparecen en pantalla:
		enemy_on_screen_list.append(enemy)
	else:
		enemy_on_screen_list.erase(enemy)
	var doors_lst: Array = get_tree().get_nodes_in_group("door")
	if enemy_on_screen_list.size() > 0:
		for door in doors_lst:
			door.close()
	else:
		for door in doors_lst:
			door.open()

# Esta función pausa el juego, durante la transición de niveles,
# se podria llamar dentro de puertas, quienes son los que solictan
# el evento, pero se ejecuta aqui a fin de sostener la jerarquia de los niveles.
func handle_pause_request():
	get_tree().paused = true

# Esta funcón resetea el estado interno de las puertas
func reset_doors():
	var children_list: Array = get_children()
	for element in children_list:
		if element.is_in_group("level"):
			element.reset_doors()

