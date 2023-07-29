extends Node

func _input(event):
	# Verificar si se presionó la tecla "SPACE" (Imprimir Pantalla)
	if event is InputEventKey and event.keycode == KEY_SPACE:
		# Obtener la fecha y hora actual para usarlo en el nombre del archivo
		var date_time 		= Time.get_date_dict_from_system()
		var date_time_clock = Time.get_time_dict_from_system()
		var timestamp = str(date_time.year) + str(date_time.month).pad_zeros(2) + str(date_time.day).pad_zeros(2) + "-" + str(date_time_clock.hour).pad_zeros(2) + str(date_time_clock.minute).pad_zeros(2) + str(date_time_clock.second).pad_zeros(2)

		# Guardar la textura en un archivo PNG en la carpeta del proyecto
		var file_path = "res://assets/screenshots/" + timestamp + ".png"
		get_viewport().get_texture().get_image().save_png(file_path)
		print("Captura de pantalla guardada como: " + file_path)
