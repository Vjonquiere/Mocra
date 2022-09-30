extends TextureProgress

var life
var max_life

func set_type(type:String):
	if type == "life":
		$".".set_progress_texture(load("res://mocraAdventure/overlay/player_health/textures/progress_life.png"))

func set_max_life(amount:float):
	max_life = amount
	$".".max_value = max_life

func set_life(amount:float):
	life = amount
	$".".value = life
