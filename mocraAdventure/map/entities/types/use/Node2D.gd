extends Area2D

var master_node
var id
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_id(new_id):
	id = new_id

func set_master(node):
	master_node = node

func use():
	print("entity_used")

func _on_Node2D_body_entered(body):
	if body.has_method("is_player"):
		master_node.entity_can_be_used(id) ### CAN BE USED


func _on_Node2D_body_exited(body):
	if body.has_method("is_player"):
		master_node.entity_cant_be_used(id) ### CAN'T BE USED
