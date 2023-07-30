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
@export var time_betwen_shoots: float = .5

@export_category("Nodos")
@export var player_path: NodePath
@export var NavigationAgent2D_path: NodePath

#@export var CadenceTimer_path: NodePath
@export var TargetTimer_path: NodePath

var player: CharacterBody2D				# Nodo Player 
var navigation_agent: NavigationAgent2D	# Nodo Navigation
var cadenceTimer: Timer					# Timer de espera entre disparos
var shoot_en: bool = true				# Bandera de disparo, si es 1 puede disparar
var current_health: int = HEATLH		# Vida actual del enemigo

# en inicio
func _ready() -> void:
	if not player_path.is_empty():
		player = get_node(player_path)
	
	# Configuramos tiempo de espera entre disparos 
	cadenceTimer = Timer.new()
	cadenceTimer.set("wait_time",time_betwen_shoots)
	cadenceTimer.set("one_shot", true)
	cadenceTimer.timeout.connect(_on_cadence_timer_timeout)

	# Configuramos navegacion
	if enemy_type == 0: #movil-enemy
		navigation_agent = get_node(NavigationAgent2D_path)
		navigation_agent.path_desired_distance  = 4.0
		navigation_agent.target_desired_distance = 4.0
		call_deferred("actor_setup")
	
	# Configuramos 
	pass
	# precargamos player
#	$CadenceTimer.wait_time = cadence
#	if player_path:
#		player = get_node(player_path)
#	navigation_agent.path_desired_distance  = 4.0
#	navigation_agent.target_desired_distance = 4.0
#	call_deferred("actor_setup")

# Esta funcion configura al agente de navegación, para establecer su
# destino con la posición de player
func actor_setup() -> void:
	await get_tree().physics_frame
	if is_instance_valid(player):
		set_movement_target(player.position)

# Esta función dispara proyectiles hacia player
func shoot() -> void:
	shoot_en = false
	var b = BULLET.instantiate()
	b.transform = $Icon/Muzzle.global_transform
	get_parent().add_child(b)
	cadenceTimer.start()

# Esta función decrementa la vida de enemy
func hurt(damage: int) -> void:
	if current_health > 0:
		current_health -= damage
		if current_health <= 0:
			emit_signal("update_score",SCORE)
			emit_signal("screen_update", self ,false)
			queue_free()

# Esta funcion establece la posición objetivo del agente de navegacion
func set_movement_target(newPos: Vector2) -> void:
	navigation_agent.target_position = newPos
	

func _on_cadence_timer_timeout() -> void:
	shoot_en = true
