extends Area2D

var speed = 150

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		return
	if body.is_in_group("player"):
		body.hurt()
	queue_free()
