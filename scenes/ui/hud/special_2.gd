extends Control

@onready var animatedSprite = $AnimatedSprite2D

func _ready():
	animatedSprite.frame = 0

func update_special(current_life: int) -> void:
	if current_life > 3:
		animatedSprite.frame = 0
	elif current_life > 1:
		animatedSprite.frame = 1
	else:
		animatedSprite.frame = 2
