extends Enemy_class

func _process(delta):
	if not player:
		return
	var target_pos: Vector2 = player.position - self.position
	$Muzzle.look_at(player.global_position)
	if shoot_en: 
		shoot()

func shoot():
	%Cadence_timer.start()
	shoot_en = false
	var muzzles = $Muzzle.get_children()
	for element in muzzles:
		var b = BULLET.instantiate()
		b.transform = element.global_transform
		get_parent().add_child(b)
