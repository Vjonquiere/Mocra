extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("profile init")

func profile_setup(username, global_points, online_status):
	$UserNameLabel.set_text(username)
	$GlobalPointsLabel.set_text(global_points)
	if online_status:
		$OnlinestatusLabel.set_text("ONLINE")
		$OnlinestatusLabel.set("custom_colors/font_color", Color("13dc1f"))
		$OnlinestatusLabel/OnlineStatusTexure.set_texture(load("res://images/Menu_interface/online_texture.png"))
	else:
		$OnlinestatusLabel.set_text("OFFLINE")
		$OnlinestatusLabel.set("custom_colors/font_color", Color("cb1c1c"))
		$OnlinestatusLabel/OnlineStatusTexure.set_texture(load("res://images/Menu_interface/offline_texture.png"))