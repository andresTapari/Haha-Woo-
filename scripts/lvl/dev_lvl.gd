extends Node2D

var enemy_on_screen_list: Array = []			#Lista de enemigos en pantalla

func _ready():
	connect_enemys_to_score_ui()
	connect_enemys_to_lvl()
	connect_lvls_to_lvls_transitions()

func connect_enemys_to_score_ui():
	var children_list: Array = get_children()
	for element in children_list:
		if element.is_in_group("enemy"):
			element.update_score.connect(handle_enemy_score_update_signal)

func connect_lvls_to_lvls_transitions():
	var children_list: Array = get_children()
	for element in children_list:
		if element.is_in_group("level"):
			element.change_lvl.connect(handle_change_lvl_signal)

# Conectamos los enmigos con lvl
func connect_enemys_to_lvl():
	var enemy_lst: Array = get_tree().get_nodes_in_group("enemy")
	for enemy in enemy_lst:
		enemy.screen_update.connect(handle_enemy_screen_update)


func handle_enemy_score_update_signal(new_score):
	$uiHeadder._update_score(new_score)

func handle_change_lvl_signal(direction,camera_position):
	if direction == 1:
		$Camera2D.travel_to_next_lvl(camera_position)
		reset_doors()

# Esta función permite abrir y cerrar puertas
# cuando los enemigos aparezcan y desaparezcan en pantalla
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

func reset_doors():
	var children_list: Array = get_children()
	for element in children_list:
		if element.is_in_group("level"):
			element.reset_doors()
