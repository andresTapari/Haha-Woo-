extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Señales
# Esta función se ejecuta cuando cambia el estado de FxBtn_En
func _on_fx_btn_en_toggled(button_pressed):
	System.set_bus_mute_en("Fx",!button_pressed)

# Esta función se ejecuta cuando se mueve el FxSlider
func _on_fx_slider_value_changed(value):
	# atenuacion_dB = 20 * log10(1 - valor_slider / 100) 
	# log(x)/log(10) = log10(x)
	var atenuacion_dB:float = ( 20 * log( value / 100) / log(10)) 
	System.set_bus_volume_db("Fx",atenuacion_dB)

# Esta función se ejecuta cuando cambia el estado de MusicBtn_en
func _on_music_btn_en_toggled(button_pressed):
	System.set_bus_mute_en("Music",!button_pressed)

# Esta función se ejecuta cuando se mueve el MusicSlider
func _on_music_slider_value_changed(value):
	# 72 es la maxima atenuacion en el BUS
	var atenuacion_dB:float = ( 20 * log( value / 100) / log(10))
	System.set_bus_volume_db("Music",atenuacion_dB)
