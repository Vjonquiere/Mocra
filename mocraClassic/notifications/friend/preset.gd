extends Control

## WORKING WITH MAX 7 CHARACTERS
const PATH = "res://mocraClassic/notifications/friend/"

var player_name
var type

@onready var player_label = $playerNameLabel

func _ready():
	if type != "default":
		$iconTexture.set_texture(load(PATH+str(type)+".png"))
		$titleLabel.set_text("Friend refused")
	player_label.set_text(player_name)

func setup(p_player_name:String, p_type:String="default"):
	player_name = p_player_name
	type = p_type

	return self

