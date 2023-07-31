extends Node

@onready var NEWSOUND = preload("res://scenes/soundFx/SoundFx.tscn")

# Reproduce sonido definido en soundPath
func play_sound(sound_path) -> void:
	var newSound = NEWSOUND.instantiate()
	var newStream: AudioStream = load(sound_path)
	newSound.set("stream",newStream)
	get_tree().get_root().add_child(newSound)
	
