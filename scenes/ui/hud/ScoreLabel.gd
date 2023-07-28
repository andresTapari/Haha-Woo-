extends Label

var current_score: int = 0

func _ready():
	
	pass
	
func update_score(new_score) -> void:
	current_score += new_score
	display_new_score()

func display_new_score() -> void:
	var max_length = 7
	var tempStr: String = str(current_score)
	var current_lengh: int = tempStr.length()
	var output_str: String = ""
	for element in range(max_length - current_lengh):
		output_str += "0"
	output_str+= str(current_score)
	self.text = output_str
