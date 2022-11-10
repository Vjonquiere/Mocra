extends Control


var tile_template = load("res://mocraAdventure/map_editor/selector/tileTemplate.tscn")
var node
var entities = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func init_selector(entities_path:String):
	var entities_infos = JsonParser.get_data_from_json(entities_path)
	print(entities_infos)
	for i in range(entities_infos["entities_number"]):
		var tile = tile_template.instance()
		tile.set_tile_texture_scale(entities_infos[str(i)]["texture_path"], 0.2)
		tile.set_tile_name(entities_infos[str(i)]["name"])
		tile.set_tile_number(i)
		tile.set_entity_type()
		tile.set_signal_node(node)
		tile.set_entity_size([int(entities_infos[str(i)]["x_size"]), int(entities_infos[str(i)]["y_size"])])
		entities[str(i)] = tile
		$ScrollContainer/VBoxContainer.add_child(tile)

func get_entity_size(entity_id):
	return entities[str(entity_id)].get_entity_size()

func set_node(new_node):
	node = new_node
