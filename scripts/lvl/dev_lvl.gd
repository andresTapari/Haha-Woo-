extends Node2D

func _ready():
	connect_enemys_to_score_ui()
	conect_lvls_to_lvls_transitions()

func connect_enemys_to_score_ui():
	var children_list: Array = get_children()
	for element in children_list:
		if element.is_in_group("enemy"):
			element.update_score.connect(handle_enemy_score_update_signal)

func conect_lvls_to_lvls_transitions():
	var children_list: Array = get_children()
	for element in children_list:
		if element.is_in_group("level"):
			element.change_lvl.connect(handle_change_lvl_signal)

func handle_enemy_score_update_signal(new_score):
	$uiHeadder._update_score(new_score)

func handle_change_lvl_signal(direction):
	pass
