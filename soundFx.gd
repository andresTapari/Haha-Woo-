extends Node

# Reproduce sonido definido en soundPath
func play_sound(sound_path) -> void:
	var newSound = AudioStreamPlayer.new()
	var newStream: AudioStream = load(sound_path)
	newSound.set("stream",newStream)
	newSound.set("autoplay",true)
	newSound.set("bus",1)
	get_tree().get_root().add_child(newSound)
