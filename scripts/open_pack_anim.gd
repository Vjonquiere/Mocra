extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_anim():
	$AnimatedSprite2D.play("open_pack")




func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite2D.hide()
