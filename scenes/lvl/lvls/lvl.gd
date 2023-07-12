extends TileMap

# Señales
signal change_lvl(dir,new_cam_pos)

# Nodos
@export var camera_pos_node: NodePath

# Variables
var camera_posistion: Vector2
var doors: Array = []

func _ready():
	add_to_group("level")
	if not camera_pos_node.is_empty():
		camera_posistion = get_node(camera_pos_node).global_position
	var childrens = get_children()
	for element in childrens:
		if element.is_in_group("door"):
			element.lvl_transition.connect(handle_lvl_transition)
			doors.append(element)

func get_camera_position() -> Vector2:
	return camera_posistion

func handle_lvl_transition(direction: int) -> void:
	emit_signal("change_lvl",direction,camera_posistion)

func reset_doors():
	for element in doors:
		element.reset()
