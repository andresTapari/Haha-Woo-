extends Enemy_class

# Export:
#@onready var BULLET:= preload("res://scenes/enemys/ammo/enemey_bullet.tscn")
@onready var rayCast2D :RayCast2D = $RayCast2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var shoot_en: bool = true
var player
var current_health: int = HEATLH


func _ready() -> void:
#	$CadenceTimer.wait_time = cadence
#	if player_path:
#		player = get_node(player_path)
#	navigation_agent.path_desired_distance  = 4.0
#	navigation_agent.target_desired_distance = 4.0
#	call_deferred("actor_setup")
	pass
func actor_setup() -> void:
	await get_tree().physics_frame
	set_movement_target(player.position)

func set_movement_target(target_pos: Vector2) -> void:
	navigation_agent.target_position = target_pos

func _physics_process(delta) -> void:
	if not is_instance_valid(player):
		# Si player no existe
		# sale
		return
	
	# Orientamos el personaje:
	$Icon.look_at(player.global_position)
	$Icon.rotation += PI/2
	
	# Apuntamos raycast hacia el jugador 
	rayCast2D.target_position = (player.global_position - global_position)
	rayCast2D.force_raycast_update()
	var collider = rayCast2D.get_collider()
	if collider: if collider.is_in_group("player") and shoot_en: shoot()
	
	# Movemos a traves de la trayectoria
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()*SPEED*delta
	velocity = new_velocity
	move_and_slide()

func shoot() -> void:
	shoot_en = false
	var b = BULLET.instantiate()
	b.transform = $Icon/Muzzle.global_transform
	get_parent().add_child(b)
	$CadenceTimer.start()

func hurt(damage: int) -> void:
	if current_health > 0:
		current_health -= damage
		if current_health <= 0:
			emit_signal("update_score",SCORE)
			emit_signal("screen_update", self ,false)
			queue_free()


func _on_cadence_timer_timeout():
	shoot_en = true

func _on_target_timer_timeout():
	if is_instance_valid(player):
		set_movement_target(player.position)


func _on_visible_on_screen_enabler_2d_screen_entered():
	emit_signal("screen_update", self ,true)


func _on_visible_on_screen_enabler_2d_screen_exited():
	emit_signal("screen_update", self ,false)
