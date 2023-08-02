extends MarginContainer

# Parametros por defecto:
const DEFAULT_FX_MUTE_EN: 		bool  = false
const DEFAULT_MUSIC_MUTE_EN: 	bool  = false
const DEFAULT_FX_VOLUME: 		float = 0.0
const DEFAULT_MUSIC_VOLUME: 	float = 0.0

# Variables 
var fx_mute_en:    bool = DEFAULT_FX_MUTE_EN
var fx_volume:    float = DEFAULT_FX_VOLUME
var music_mute_en: bool = DEFAULT_MUSIC_MUTE_EN
var music_volume: float = DEFAULT_MUSIC_VOLUME

# Señales
func _ready():
	set_control_nodes_values()

# Esta función se ejecuta cuando cambia el estado de FxBtn_En
func _on_fx_btn_en_toggled(button_pressed):
	System.set_bus_mute_en("Fx",!button_pressed)

# Esta función se ejecuta cuando se mueve el FxSlider
func _on_fx_slider_value_changed(value):
	# atenuacion_dB = 20 * log10(1 - valor_slider / 100) 
	# log10(x) = log(x)/log(10)
	var atenuacion_dB:float = log10(value)
	System.set_bus_volume_db("Fx",atenuacion_dB)

# Esta función se ejecuta cuando cambia el estado de MusicBtn_en
func _on_music_btn_en_toggled(button_pressed):
	System.set_bus_mute_en("Music",!button_pressed)

# Esta función se ejecuta cuando se mueve el MusicSlider
func _on_music_slider_value_changed(value):
	# 72 es la maxima atenuacion en el BUS
	var atenuacion_dB:float = log10(value) 
	System.set_bus_volume_db("Music",atenuacion_dB)

# Calculo de logaritmo base 10
func log10(value: float) -> float:
	return 20 * log( value / 100) / log(10)
	
# Calculo de la inversa de logaritmo base 10
func i_log10(value: float) -> float:
	return 100 * 10 ** (value / 20)

func set_control_nodes_values() -> void:
	%FxBtn_en.set("button_pressed",not(System.get_bus_mute_en("Fx")))
	%MusicBtn_en.set("button_pressed",not(System.get_bus_mute_en("Music")))
	%FxSlider.set("value",i_log10(System.get_bus_volume_db("Fx")))
	%MusicSlider.set("value",i_log10(System.get_bus_volume_db("Fx")))

# Señales
func _on_btn_aceptar_pressed():
	fx_mute_en    = System.get_bus_mute_en("Fx")
	music_mute_en = System.get_bus_mute_en("Music")
	fx_volume     = System.get_bus_volume_db("Fx")
	music_volume  = System.get_bus_volume_db("Music")
	queue_free()

func _on_btn_cancelar_pressed():
	System.set_bus_mute_en("Fx",fx_mute_en)
	System.set_bus_volume_db("Fx",fx_volume)
	System.set_bus_mute_en("Music",music_mute_en)
	System.set_bus_volume_db("Music",music_volume)
	queue_free()
#	set_control_nodes_values()
