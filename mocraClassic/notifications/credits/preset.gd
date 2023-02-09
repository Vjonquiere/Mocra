extends Control

var amount

onready var icon = $backgroundTexture/iconTexture
onready var label = $backgroundTexture/creditLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	if amount[0] == '-':
		icon.set_texture(load("res://mocraClassic/notifications/credits/remove.png"))
	label.set_text(amount)

func _init(amount:String):
	self.amount = amount
