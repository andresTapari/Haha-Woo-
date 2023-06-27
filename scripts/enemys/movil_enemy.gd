extends CharacterBody2D

@export var SPEED: float = 3000.0
@export var player_path: NodePath
@export var navigation_agent: NavigationAgent2D

var player

func _ready() -> void:
	if player_path:
		player = get_node(player_path)
	navigation_agent.path_desired_distance  = 4.0
	navigation_agent.target_desired_distance = 4.0
	call_deferred("actor_setup")
	

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(player.position)

func set_movement_target(target_pos: Vector2) -> void:
	navigation_agent.target_position = target_pos

func _physics_process(delta):
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()*SPEED*delta
	velocity = new_velocity
	move_and_slide()


func _on_timer_timeout():
	set_movement_target(player.position)
