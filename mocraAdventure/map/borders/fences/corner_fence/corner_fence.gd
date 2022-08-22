extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func flip_h():
	$Sprite2.set_flip_h(true)
	$Sprite2/StaticBody2D/Collision.set_disabled(true)
	$Sprite2/StaticBody2D/Collision_flip_h.set_disabled(false)
