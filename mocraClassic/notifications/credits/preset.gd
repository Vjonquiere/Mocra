extends Control

var amount
onready var animation_player = $AnimationPlayer

onready var icon = $backgroundTexture/iconTexture
onready var label = $backgroundTexture/creditLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	if amount[0] == '-':
		icon.set_texture(load("res://mocraClassic/notifications/credits/remove.png"))
	label.set_text(amount)

func setup(amount:String):
	self.amount = amount
	return self

func has_animation(animation_name:String):
	return animation_player.has_animation(animation_name)

func play_animation(animation_name:String):
	if has_animation(animation_name):
		animation_player.play(animation_name)
