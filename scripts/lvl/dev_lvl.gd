extends Node2D

var enemys

func _ready():
	connect_enemys_to_score_ui()

func connect_enemys_to_score_ui():
	var children_list: Array = get_children()
	var enemy_list: Array = []
	for element in children_list:
		if element.is_in_group("enemy"):
			enemy_list.append(element)
			element.update_score.connect(handle_enemy_score_update_signal)

func handle_enemy_score_update_signal(new_score):
	$uiHeadder._update_score(new_score)

