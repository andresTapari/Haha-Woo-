extends Node

# Esta función establece el estado de Mute del bus definido en busName
func set_bus_mute_en(busName: String,mute_en: bool) -> void:
	var busIndx = AudioServer.get_bus_index(busName)
	if busIndx > -1:
		AudioServer.set_bus_mute(busIndx,mute_en)
	else:
		print_debug("ERROR: BUS ",busName," no encontrado")

# Esta función establece el volumen del bus definido en busName
func set_bus_volume_db(busName: String, newVolumeDb: float) -> void:
	var busIndx = AudioServer.get_bus_index(busName)
	if busIndx > -1:
		AudioServer.set_bus_volume_db(busIndx,newVolumeDb)
	else:
		print_debug("ERROR: BUS ",busName," no encontrado")
