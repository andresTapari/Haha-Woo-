extends Control

@onready var animatedSprite := %AnimatedSprite2D

func _ready():
	update_draw(5)

func update_draw(value: int) -> void:
	if value > 5 or value < 0:
		return
	animatedSprite.frame = value
