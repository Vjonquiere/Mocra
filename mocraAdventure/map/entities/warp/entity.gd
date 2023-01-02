extends Area2D


var teleport_coordinates = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_teleportation_coordinates(x:int, y:int):
	teleport_coordinates[0] = x
	teleport_coordinates[1] = y

func _on_Area2D_body_entered(body):
	if body.has_mathod("is_player") && body.is_player():
		teleport(body)

func teleport(player):
	player.set_position(teleport_coordinates)
