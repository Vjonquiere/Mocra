extends Area2D

var master_node
var id
# Called when the node enters the scene tree for the first time.
func _ready():
	set_use_key_label()

func remove_physical(string:String) -> String:
	return string.split(" ")[0]

func set_use_key_label():
	var inputs = InputMap
	var actions = inputs.get_actions()
	var events = InputMap.get_action_list("use")
	var events_text = events[0].as_text()
	$Sprite/Label.set_text(remove_physical(events_text))

func set_id(new_id):
	id = new_id

func get_id():
	return id

func set_master(node):
	master_node = node

func use():
	print("entity_used")

func _on_Node2D_body_entered(body):
	if body.has_method("is_player"):
		master_node.entity_can_be_used(id) ### CAN BE USED
		$Sprite.show()
		$AnimationPlayer.play("can_be_used")


func _on_Node2D_body_exited(body):
	if body.has_method("is_player"):
		master_node.entity_cant_be_used(id) ### CAN'T BE USED
		$Sprite.hide()
		$AnimationPlayer.stop()
