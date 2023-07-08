extends Control

@onready var animatedSprite = $AnimatedSprite2D

func _ready():
	animatedSprite.animation = "lvl_1"
	animatedSprite.frame = 0

func update_special(current_lvl: int, current_health: int) -> void:
	# Actualizamos color hud
	if current_lvl == 1:
		animatedSprite.animation = "lvl_1"
	elif current_lvl == 2:
		animatedSprite.animation = "lvl_2"
	elif current_lvl == 3:
		animatedSprite.animation = "lvl_3"

	# Actualizamos lvl de arma
	if current_health > 3:
		animatedSprite.frame = 0
	elif current_health > 1:
		animatedSprite.frame = 1
	else:
		animatedSprite.frame = 2
