# movil_enemy.gd
extends Enemy_class

# Export:
@onready var rayCast2D :RayCast2D = $RayCast2D


func _physics_process(delta) -> void:
	if not is_instance_valid(player):
		# Si player no existe sale
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

func _on_target_timer_timeout():
	if is_instance_valid(player):
		set_movement_target(player.position)

func _on_visible_on_screen_enabler_2d_screen_entered():
	emit_signal("screen_update", self ,true)

func _on_visible_on_screen_enabler_2d_screen_exited():
	emit_signal("screen_update", self ,false)
