extends TileMap

# Señales
signal change_lvl(dir)

# Nodos
@export var camera_pos_node: NodePath
@export var door_node: NodePath

# Variables
var camera_posistion: Vector2
var door: Area2D

func _ready():
	if not camera_pos_node.is_empty():
		camera_posistion = get_node(camera_pos_node).global_position
	if not door_node.is_empty():
		door = get_node(door_node)
		door.lvl_transition.connect(handle_lvl_transition)

func get_camera_position() -> Vector2:
	return camera_posistion

func handle_lvl_transition(direction: int) -> void:
	emit_signal("change_lvl",direction)
