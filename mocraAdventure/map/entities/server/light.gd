extends Light2D

var types = {"red":"4b1414", "orange":"453515", "green":"1d4515"}
var light_type
var timer = Timer.new()
var wait_time = RandomNumberGenerator.new()

func _ready():
	timer.set_one_shot(true)
	$".".add_child(timer)
	pass

func set_light_type(type:String):
	light_type = type
	$".".set_color(Color(types[type]))

func start_light():
	$".".enabled = true
	if light_type == "green":
		timer.connect("timeout", self, "_on_random_timer_timeout")
	elif light_type == "orange":
		timer.connect("timeout", self, "_on_fixed_timer_timeout")
		timer.set_one_shot(false)
	else:
		return
	timer.set_wait_time(1)
	timer.start()

func _on_fixed_timer_timeout():
	$".".enabled = !$".".enabled

func _on_random_timer_timeout():
	wait_time.randomize()
	var time_to_wait = wait_time.randf_range(0, 0.5)
	$".".enabled = !$".".enabled
	timer.set_wait_time(time_to_wait)
	timer.start()
