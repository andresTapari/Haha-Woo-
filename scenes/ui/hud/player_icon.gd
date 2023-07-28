extends Control

@onready var animatedSprite = %AnimatedSprite2D

func _ready():
	animatedSprite.animation = "idle"
	animatedSprite.frame = 0

func handle_player_hit(currentLife: int) -> void:
	if currentLife > 3:
		animatedSprite.play("green_damage")
	elif currentLife > 1:
		animatedSprite.play("yellow_damage")
	else:
		animatedSprite.play("red_damage")

func update_draw(currentLife: int) -> void:
	animatedSprite.animation = "idle"
	if currentLife > 3:
		animatedSprite.frame = 0
	elif currentLife > 1:
		animatedSprite.frame = 1
	else:
		animatedSprite.frame = 2
