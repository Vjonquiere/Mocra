extends Control

var duration
var timer = Timer.new()
var active = false
var colors = {"blue": "res://mocraAdventure/overlay/object_timer/textures/blue_loading.png", "yellow": "res://mocraAdventure/overlay/object_timer/textures/yellow_loading.png", "green": "res://mocraAdventure/overlay/object_timer/textures/green_loading.png"}

func _ready():
	$".".add_child(timer)
	timer.connect("timeout", self, "on_timeout")
	set_color("green")
	set_duration(1)
	construct_timer()
	launch()

func set_color(color:String):
	$loadingProgress.set_progress_texture(load(colors[color]))

func set_duration(new_duration:float):
	duration = new_duration * 30
	$loadingProgress.max_value = duration

func construct_timer():
	timer.set_wait_time(duration/30)
	timer.set_one_shot(true)

func launch():
	timer.start()
	active = true

func _process(delta):
	if active:
		$loadingProgress.value = duration - timer.get_time_left() * 30

func on_timeout():
	active = false
