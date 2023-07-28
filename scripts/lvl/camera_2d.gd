extends Camera2D

# Nodos:
@export_category("Parametros de nivel")
@export var lvl_path: NodePath

@export_category("Parametros de temblor")
@export var shake_duration: float =   .5
@export var shake_amplitude: float = 10.0

var rng = RandomNumberGenerator.new()

# Variables:
var current_lvl: TileMap					# Nivel
var shake_timer = 0.0						# Timer del temblor
var initial_camera_position = Vector2()		# Posición inicial de la camara

func _ready():
	if not lvl_path.is_empty():
		current_lvl = get_node(lvl_path)
		position = current_lvl.get_camera_position()

func travel_to_next_lvl(new_position: Vector2)->void:
	var tween = create_tween()
	tween.tween_property(self,"global_position",new_position,.75)

func start_shake():
	initial_camera_position = offset
	shake_timer = shake_duration

func _process(delta):
	if shake_timer > 0:
		offset.x = rng.randf_range(-shake_amplitude, shake_amplitude)
		offset.y = rng.randf_range(-shake_amplitude, shake_amplitude)
		shake_timer -= delta
	else:
		offset = initial_camera_position

func _on_player_dammage():
	start_shake()
