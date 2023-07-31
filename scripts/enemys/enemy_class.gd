extends CharacterBody2D
class_name Enemy_class

# Señales emitidas:
signal update_score(score)			# Señal de actualizar puntaje en hud cuando unidad es destruida
signal screen_update(flag)			# Señal cuando enemy entra en pantalla

# Escenas precargadas:
@onready var BULLET    := preload("res://scenes/enemys/ammo/enemey_bullet.tscn")
@onready var EXPLOSION := preload("res://scenes/enemys/enemy_explosion.tscn")
@onready var SOUND_FX  := preload("res://scenes/soundFx/SoundFx.tscn")

# Variables:
@export_category("Enemy Propertys")
@export_enum("Movil Enemy","Static Enemy", "Trap Enemy") var enemy_type: int = 0
@export var SCORE: int  = 50
@export var HEATLH: int = 10
@export var SPEED: float = 3000.0
@export var time_betwen_shoots: float = .5
@export var time_betwen_recalc_player_pos: float = .2

@export_category("Nodos")
@export var player_path: NodePath
@export var NavigationAgent2D_path: NodePath
@export var RayCast2D_path: NodePath
@export var VisibleOnScreenEnabler2D_path: NodePath

#@export var CadenceTimer_path: NodePath

# Nodos:
var player: CharacterBody2D							# Nodo Player 
var navigation_agent: NavigationAgent2D				# Nodo Navigation
var cadenceTimer: Timer								# Timer de espera entre disparos
var targetTimer:  Timer								# Timer para recalcular la pos de player
var rayCast2D:    RayCast2D							# Raycast que apunta al jugador para disparar
var visibleOnScreenEn2D: VisibleOnScreenEnabler2D 	# Nodo que habilita y avisa cuando enemigo es visible en pantalla
var modulateTimer: Timer							# Timer para restaurar color cuando enemy es golpeado

# Variables
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
	add_child(cadenceTimer)
	
	
	# Configuramos navegacion
	if enemy_type == 0: #movil-enemy
		if not NavigationAgent2D_path.is_empty():
			navigation_agent = get_node(NavigationAgent2D_path)
			navigation_agent.path_desired_distance   = 4.0
			navigation_agent.target_desired_distance = 4.0
			call_deferred("actor_setup")
	
		# Configuramos el tiempo de espera para recalcular la pos de player
		targetTimer =Timer.new()
		targetTimer.set("wait_time",time_betwen_shoots)
		targetTimer.set("one_shot", false)
		targetTimer.set("autostart",true)
		targetTimer.timeout.connect(_on_target_timer_timeout)
		add_child(targetTimer)
	
	# Configuramos Raycast
	if not RayCast2D_path.is_empty():
		rayCast2D = get_node(RayCast2D_path)
	
	# Configuramos Visibility Enabler:
	if not VisibleOnScreenEnabler2D_path.is_empty():
		visibleOnScreenEn2D = get_node(VisibleOnScreenEnabler2D_path)
		visibleOnScreenEn2D.screen_entered.connect(_on_visible_on_screen_enabler_2d_screen_entered)
		visibleOnScreenEn2D.screen_exited.connect(_on_visible_on_screen_enabler_2d_screen_exited)

	# Configuramos Color Modulate:
	modulateTimer = Timer.new()
	modulateTimer.set("wait_time",0.10)
	modulateTimer.set("one_shot", true)
	modulateTimer.timeout.connect(_on_handle_modulate_timer_timeout)
	add_child(modulateTimer)
	
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
	SoundFx.play_sound("res://assets/soundFx/enemy_laserShoot.wav")
	cadenceTimer.start()
# Esta función decrementa la vida de enemy

func hurt(damage: int) -> void:
	SoundFx.play_sound("res://assets/soundFx/enemy_hit.wav")
	if current_health > 0:
		current_health -= damage
		if current_health <= 0:
			Score.add_score(SCORE)
			emit_signal("update_score", SCORE)
			emit_signal("screen_update", self ,false)
			emit_explotion()
			queue_free()
	set("modulate",Color.RED)
	modulateTimer.start()

# Genera una explosión cuando es llamada
func emit_explotion():
	var newExplotion = EXPLOSION.instantiate()
	newExplotion.set("emitting",true)
	newExplotion.global_position = self.global_position
	get_parent().add_child(newExplotion)
	
# Esta funcion establece la posición objetivo del agente de navegacion
func set_movement_target(newPos: Vector2) -> void:
	navigation_agent.target_position = newPos
	
# Esta funcion reproduce el sonido en "sound_path"
func play_sound_fx(sound_path) -> void:
	var newSound = SOUND_FX.instantiate()
	newSound.load_stream_and_play(sound_path)
	get_parent().add_child(newSound)

# Señales:
func _on_cadence_timer_timeout() -> void:
	shoot_en = true

func _on_target_timer_timeout() -> void:
	if is_instance_valid(player):
		set_movement_target(player.position)
	
func _on_handle_modulate_timer_timeout() -> void:
	set("modulate",Color.WHITE)

func _on_visible_on_screen_enabler_2d_screen_entered():
	emit_signal("screen_update", self ,true)

func _on_visible_on_screen_enabler_2d_screen_exited():
	emit_signal("screen_update", self ,false)
