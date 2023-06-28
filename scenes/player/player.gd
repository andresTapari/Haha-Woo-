extends CharacterBody2D

const VELOCIDAD: int = 10000
var BULLET = preload("res://scenes/player/bullet.tscn")
var direccion: Vector2 = Vector2.ZERO

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
	var movimiento = direccion * VELOCIDAD * delta
	velocity = movimiento
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()

func shoot() -> void:
	var b = BULLET.instantiate()
	b.transform = $Muzzle.global_transform
	get_parent().add_child(b)
