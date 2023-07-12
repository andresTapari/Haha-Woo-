extends Camera2D

# Nodos:
@export var lvl_path: NodePath

# Lvl:
var current_lvl: TileMap

func _ready():
	if not lvl_path.is_empty():
		current_lvl = get_node(lvl_path)
		position = current_lvl.get_camera_position()
