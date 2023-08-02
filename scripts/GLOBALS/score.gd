extends Node

var score: int = 0					# Puntaje del jugador

# Esta función incrementa el score en newScore
func add_score(newScore: int) -> void:
	score += newScore

# Devuelve el valor de score cuando es llamada
func get_score() -> int:
	return score
