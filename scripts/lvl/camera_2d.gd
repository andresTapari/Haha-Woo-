extends Camera2D

# Nodos:
@export var lvl_path: NodePath

# Lvl:
var current_lvl: TileMap

func _ready():
	if not lvl_path.is_empty():
		current_lvl = get_node(lvl_path)
		position = current_lvl.get_camera_position()

func travel_to_next_lvl(new_position: Vector2)->void:
	var tween = create_tween()
	tween.tween_property(self,"global_position",new_position,.75)

