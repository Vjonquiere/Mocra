extends Control

var player_name

onready var player_label = $backgroundTexture/playerNameLabel

func _ready():
	player_label.set_text(player_label)

func _init(player_name:String):
	self.player_name = player_name
