extends CharacterBody2D

# Señales emitidas
signal update_ui(data)	# Señal al hud para informar estado actual de player
signal dammage			# Señal a la camara para informar cuando sacudir camara
signal game_over		# Señal para cambiar pantalla a game_over

# Escenas:
var BULLET_LVL_1   = preload("res://scenes/player/bullet_fase_1.tscn")
var BULLET_LVL_2_C = preload("res://scenes/player/bullet_fase_2_center.tscn")
var BULLET_LVL_2_E = preload("res://scenes/player/bullet_fase_2_edge.tscn")

# Variables de exportacion
@export var VELOCIDAD:      int = 10000   	# velocidad de movimiento
@export var muzzle_stage:   int = 1			# estado actual de modo de disparo
@export var idle_time:    float = 1.0		# duración de tiempo idle
@export var cadence_time: float = .5		# cadencia de disparo

# Variables internas
var health = 5								# Vida de player
var direccion :  Vector2  = Vector2.ZERO	# Direccon a donde moverse
var muzzle_stage_1: Array = []				# Array de muzzle_1
var muzzle_stage_2: Array = []				# Array de muzzle_2
var muzzle_stage_3: Array = []				# Array de muzzle_3
var idle_estate_en: bool  = false			# Bandera de estado idle
var shoot_en:       bool  = true			# Bandera de disparo habilitado

func _ready() -> void:
#	muzzle_stage_1 = $Muzzle_stage_1.playerget_children()
	muzzle_stage_2 = $Muzzle_stage_2.get_children()
	muzzle_stage_3 = $Muzzle_stage_3.get_children()
	%Ide_timer.wait_time     = idle_time
	%Cadence_Timer.wait_time = cadence_time 
	update_ui_signal()

func _physics_process(delta: float) -> void:
	direccion = Vector2.ZERO

	# Mouse Direction
	var mouse_pos = get_global_mouse_position()
	var direccion_mouse = (mouse_pos - global_position).normalized()
	rotation = direccion_mouse.angle() + PI/2

	# Input Teclado
	if Input.is_action_pressed("ui_right"):
		direccion.x += 1
	if Input.is_action_pressed("ui_left"):
		direccion.x -= 1
	if Input.is_action_pressed("ui_down"):
		direccion.y += 1
	if Input.is_action_pressed("ui_up"):
		direccion.y -= 1
	direccion = direccion.normalized()
	
	# Disparo
	if Input.is_action_pressed("shoot") and !idle_estate_en:
		if shoot_en: shoot()
	# Movemos a player
	var movimiento = direccion * VELOCIDAD * delta
	velocity = movimiento
	move_and_slide()

# Esta función dispara municiones segun el lvl del arma
func shoot() -> void:
	shoot_en = false
	%Cadence_Timer.start()
	match muzzle_stage:
		1:
			var b = BULLET_LVL_1.instantiate()
			b.transform = %Muzzle.global_transform
			get_parent().add_child(b)
		2:
			var bullet_a = BULLET_LVL_2_C.instantiate()
			var bullet_b = BULLET_LVL_2_E.instantiate()
			var bullet_c = BULLET_LVL_2_E.instantiate()
			bullet_a.transform = %Muzzle2.global_transform
			bullet_b.transform = %Muzzle3.global_transform
			bullet_c.transform = %Muzzle4.global_transform
			get_parent().add_child(bullet_a)
			get_parent().add_child(bullet_b)
			get_parent().add_child(bullet_c)
		3:
			var bullet_a = BULLET_LVL_2_C.instantiate()
			var bullet_b = BULLET_LVL_2_C.instantiate()
			var bullet_c = BULLET_LVL_2_C.instantiate()
			var bullet_d = BULLET_LVL_2_E.instantiate()
			var bullet_e = BULLET_LVL_2_E.instantiate()
			bullet_a.transform = %Muzzle2.global_transform
			bullet_b.transform = %Muzzle3.global_transform
			bullet_c.transform = %Muzzle4.global_transform
			bullet_d.transform = %Muzzle5.global_transform
			bullet_e.transform = %Muzzle6.global_transform
			get_parent().add_child(bullet_a)
			get_parent().add_child(bullet_b)
			get_parent().add_child(bullet_c)
			get_parent().add_child(bullet_d)
			get_parent().add_child(bullet_e)

# Esta función se ejecuta cuando player recibe daño
func hurt(damage: int = 1) -> void:
	if not idle_estate_en:
		health -= damage
		update_ui_signal()
		idle_estate_en = true
		%Ide_timer.start()
		$AnimatedSprite2D.play("idle_state")
		emit_signal("dammage")
		if health <= 0:
			emit_signal("game_over")
			queue_free()

func heal(heal_amount: int = 1) -> void:
	health += heal_amount
	if health > 5:
		health = 5
	update_ui_signal()
# Esta funcion envia una señal al hud, informando:
#	<> vida actual
#	<> lvl del arma

func update_ui_signal() -> void:
	var data = {
		"health": health,
		"muzzle_stage": muzzle_stage
	}
	emit_signal("update_ui",data)

# Esta funcion incrementa el lvl del arma
func upgrade_gun() -> void:
	if muzzle_stage < 3:
		muzzle_stage += 1
		update_ui_signal()

# Esta funcion decrementa el lvl del arma
func downgrade_gun() -> void:
	if muzzle_stage > 1:
		muzzle_stage -= 1
		update_ui_signal()

# Señales:
func _on_ide_timer_timeout():
	$AnimatedSprite2D.animation = "normal"
	idle_estate_en = false

func _on_cadence_timer_timeout():
	shoot_en = true
