extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Area2D_body_entered(body):
	$PointLight2D.set_color(Color("00ff1c"))
	$AnimationPlayer.play("open")


func _on_Area2D_body_exited(body):
	$PointLight2D.set_color(Color("ff0000"))
	$AnimationPlayer.play("close")
