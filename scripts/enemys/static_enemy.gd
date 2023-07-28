extends CharacterBody2D

# Señales emitidas:
signal update_score(score)			#Señal cuando enemy muere y actualiza el puntaje
signal screen_update(node,flag)			#Señal cuando enemy entra en pantalla

# Escenas
@onready var BULLET:= preload("res://scenes/enemys/ammo/enemey_bullet.tscn")
@onready var EXPLOSION := preload("res://scenes/enemys/enemy_explosion.tscn")

# Nodos
@onready var rayCast2D        := $RayCast2D
@onready var muzzle_container := $Muzzle

# Parametros:
@export var player_path: NodePath
@export var cadence: float = .5
@export var health: int = 20
@export var SCORE: int = 10

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


func shoot():
	%Cadence_timer.start()
	shoot_en = false
	var muzzles = muzzle_container.get_children()
	for element in muzzles:
		var b = BULLET.instantiate()
		b.transform = element.global_transform
		get_parent().add_child(b)

func hurt(damage: int) -> void:
	health -= damage
	if health <= 0:
		emit_signal("update_score",SCORE)
		emit_signal("screen_update", self, false)
		emit_explotion()
		queue_free()
	

func emit_explotion():
	var newExplotion = EXPLOSION.instantiate()
	newExplotion.set("emitting",true)
	newExplotion.global_position = self.global_position
	get_parent().add_child(newExplotion)
	
func _on_cadence_timer_timeout():
	shoot_en = true


# Funcion que se ejecuta cuando enemy entra en pantalla
func _on_visible_on_screen_enabler_2d_screen_entered():
	emit_signal("screen_update", self ,true)

# Funcion que se ejecuta cuando enemy sale de la pantalla
func _on_visible_on_screen_enabler_2d_screen_exited():
	emit_signal("screen_update", self, false)
