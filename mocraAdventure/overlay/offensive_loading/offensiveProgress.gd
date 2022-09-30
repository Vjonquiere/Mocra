extends TextureProgress

var maximum
var minimum
var current

func set_progress_max(new_maximum):
	maximum = new_maximum

func set_progress_min(new_minimum):
	minimum = new_minimum

func set_progress_value(new_value):
	current = new_value
	$".".value = $".".max_value - current
