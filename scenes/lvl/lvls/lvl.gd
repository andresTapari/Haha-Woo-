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
	open_doors()

# Funcion que retorna la posicion de la camara 
func get_camera_position() -> Vector2:
	return camera_posistion

# Funcion que emite señal para mover la camara de sala a sala
func handle_lvl_transition(direction: int) -> void:
	emit_signal("change_lvl",direction,camera_posistion)

# Funcion que resetea el estado de todas las puertas
func reset_doors():
	for element in doors:
		element.reset()

# Funcion que abre todas las puertas
func open_doors():
	for element in doors:
		element.open()

# Funcion que cierra todas las puertas
func close_doors():
	for element in doors:
		element.close()
