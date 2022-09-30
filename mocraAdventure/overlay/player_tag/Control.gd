extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect/lifeProgress2.set_type("life")
	$TextureRect/GUI.set_color("blue")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
