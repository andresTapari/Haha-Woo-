# movil_enemy.gd
extends Enemy_class


func _physics_process(delta) -> void:
	if not is_instance_valid(player):
		return # Si player no existe sale
	
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
