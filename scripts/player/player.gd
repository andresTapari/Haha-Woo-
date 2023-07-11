extends CharacterBody2D

# Señales emitidas
signal update_ui(data)

# Escenas:
var BULLET = preload("res://scenes/player/bullet.tscn")

# Variables de exportacion
@export var VELOCIDAD:      int = 10000   	# velocidad de movimiento
@export var muzzle_stage:   int = 2			# estado actual de modo de disparo
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
	muzzle_stage_1 = $Muzzle_stage_1.get_children()
	muzzle_stage_2 = $Muzzle_stage_2.get_children()
	muzzle_stage_3 = $Muzzle_stage_3.get_children()
	%Ide_timer.wait_time     = idle_time
	%Cadence_Timer.wait_time = cadence_time 
	update_ui_signal()

func _physics_process(delta: float) -> void:
	direccion = Vector2.ZERO

	# Mouse Direction
	var mouse_pos = get_viewport().get_mouse_position()
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

func shoot() -> void:
	shoot_en = false
	%Cadence_Timer.start()
	var current_muzzle_list: Array = muzzle_stage_1
	if muzzle_stage == 2:
		current_muzzle_list = muzzle_stage_2
	if muzzle_stage == 3:
		current_muzzle_list = muzzle_stage_2 +  muzzle_stage_3
	
	
	
	for muzzle in current_muzzle_list:
		var b = BULLET.instantiate()
		b.transform = muzzle.global_transform
		get_parent().add_child(b)
	
func hurt(damage: int = 1) -> void:
	if not idle_estate_en:
		health -= damage
		update_ui_signal()
		idle_estate_en = true
		%Ide_timer.start()
		$AnimatedSprite2D.play("idle_state")
		if health <= 0:
			queue_free()

func update_ui_signal() -> void:
	var data = {
		"health": health,
		"muzzle_stage": muzzle_stage
	}
	emit_signal("update_ui",data)

func _on_ide_timer_timeout():
	$AnimatedSprite2D.animation = "normal"
	idle_estate_en = false


func _on_cadence_timer_timeout():
	shoot_en = true
