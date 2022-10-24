extends StaticBody2D

onready var all_lights = [[$firstRow/red, $firstRow/orange, $firstRow/green], [$secondRow/red, $secondRow/orange, $secondRow/green], [$thirdRow/red, $thirdRow/orange, $thirdRow/green]]
var number = RandomNumberGenerator.new()
var lights = []
var lights_colors = []
var colors = {0: "red", 1: "orange", 2:"green"}

func _ready():
	choose_lights()
	config_lights()

func choose_lights():
	number.randomize()
	var selected_light
	for i in range(3):
		selected_light = number.randi_range(0,2)
		lights_colors.append(selected_light)
		lights.append(all_lights[i][selected_light])

func config_lights():
	for i in range(3):
		lights[i].set_light_type(colors[lights_colors[i]])
		lights[i].start_light()
