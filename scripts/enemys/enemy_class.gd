extends CharacterBody2D
class_name Enemy_class

# Señales emitidas:
signal update_score(score)			# Señal de actualizar puntaje en hud cuando unidad es destruida
signal screen_update(flag)			# Señal cuando enemy entra en pantalla

# Escenas precargadas:
@onready var BULLET:= preload("res://scenes/enemys/ammo/enemey_bullet.tscn")
@onready var EXPLOSION := preload("res://scenes/enemys/enemy_explosion.tscn")

# Variables:
@export_category("Enemy Propertys")
@export_enum("Movil Enemy","Static Enemy", "Trap Enemy") var enemy_type: int = 0
@export var SCORE: int  = 50
@export var HEATLH: int = 10
@export var SPEED: float = 3000.0
@export var cadence: float = .5

@export_category("Nodos")
@export var player_path: NodePath
@export var CadenceTimer_path: NodePath
@export var TargetTimer_path: NodePath

# en inicio
func _ready() -> void:
	pass
	# precargamos player
#	$CadenceTimer.wait_time = cadence
#	if player_path:
#		player = get_node(player_path)
#	navigation_agent.path_desired_distance  = 4.0
#	navigation_agent.target_desired_distance = 4.0
#	call_deferred("actor_setup")
