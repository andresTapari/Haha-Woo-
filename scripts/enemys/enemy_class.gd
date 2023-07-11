# Enemy Class:
extends CharacterBody2D

class_name ENEMY_CLASS

@export var RayCast_node_path: NodePath
@export var Muzzle_node_path: NodePath

var rayCast: RayCast2D
var muzzle: Marker2D

func _ready():
	if not RayCast_node_path.is_empty():
		rayCast = get_node(RayCast_node_path)
	if not Muzzle_node_path != null:
		muzzle = get_node(Muzzle_node_path)

func _process(delta):
	pass
