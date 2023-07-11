extends CharacterBody2D

# Señales emitidas:
signal update_score(score)

	# Escenas
@onready var BULLET:= preload("res://scenes/enemys/ammo/enemey_bullet.tscn")

# Nodos
@onready var rayCast2D        := $RayCast2D
@onready var muzzle_container := $Muzzle

# Parametros:
@export var player_path: NodePath
@export var cadence: float = .5

# Variables:: Character
var player: CharacterBody2D
var shoot_en: bool = true

func _ready():
	%Cadence_timer.wait_time = cadence
	if not player_path.is_empty():
		player = get_node(player_path)

func _process(delta):
	if not player:
		return
	var target_pos: Vector2 = player.position - self.position
	$Muzzle.look_at(player.global_position)
	if shoot_en: shoot()
#	rayCast2D.target_position = target_pos
#	rayCast2D.force_raycast_update()
#	var collider = rayCast2D.get_collider()
#	if collider.is_in_group("player") and shoot_en:
#		shoot()

func shoot():
	%Cadence_timer.start()
	shoot_en = false
	var muzzles = muzzle_container.get_children()
	for element in muzzles:
		var b = BULLET.instantiate()
		b.transform = element.global_transform
		get_parent().add_child(b)

func hurt(damage: int) -> void:
	pass

func _on_cadence_timer_timeout():
	shoot_en = true

