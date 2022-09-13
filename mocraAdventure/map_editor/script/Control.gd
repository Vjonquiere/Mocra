extends Control

var types = {"life":"kill", "reach":"reach"}

var entity_id
var node

func init_identity(entity_name:String, avatar_path:String, position:Array, type:String, new_entity_id, master_node):
	entity_id = new_entity_id
	node = master_node
	var name = entity_name.split('/')[-2]
	$entityLabel.set_text(name)
	$avatarTextureRect.set_texture(load("res://mocraAdventure/map/entities/" + name + "/texture.png"))
	$posLabel.set_text("pos (" + str(position[0]) + ";" + str(position[1]) + ")")
	$typeLabel.set_text(types[type])

func get_entity_id():
	return entity_id

func _on_Button_pressed():
	node.emit_signal("remove_script_state", entity_id)
