extends Control


var value = 0
var animDuration = 30 ## (cycle) 1 cycle = 1 ms => FAUX
onready var backgroundTexture = $"."
onready var label
var state_set_value
var max_value 
var operation


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset_vars():
	animDuration = 30
	value = 0

func add_credits(amount):
	reset_vars()
	operation = "+"
	$AnimationPlayer.play("show")
	state_set_value = int(amount)/animDuration
	if state_set_value <= 0:
		animDuration = amount
		state_set_value = 1
	max_value = amount
	$Timer.start()

func remove_credits(amount):
	reset_vars()
	operation = "-"
	$AnimationPlayer.play("show")
	state_set_value = int(amount)/animDuration
	if state_set_value <= 0:
		animDuration = amount
		state_set_value = 1
	max_value = amount
	$backgroundTexture.set_texture(load("res://mocraClassic/client_infos/remove_texture.png"))
	$Timer.start()

func _on_Timer_timeout():
	if animDuration <= 0:
		$Label.set_text(operation+str(max_value))
		$AnimationPlayer.play("end")
	else:
		value += state_set_value
		$Label.set_text(operation+str(value))
		animDuration -= 1
		$Timer.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "end":
		print("AnimationPlayer: animation 'end' has ended")
