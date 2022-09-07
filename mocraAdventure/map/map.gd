class_name Map


var size = []
var tile_size
var name = ""
var objectives = []
var challenges = {'50': null, '75': null, '100': null}
var tiles = []
var tileSet
var entity_types = {"life": "res://mocraAdventure/map/entities/types/life/Node2D.tscn"}


func load_map(map_path:String):
	var path = map_path + "/map.json"
	var level_data = JsonParser.get_data_from_json(path)
	size = level_data['size'].split("x")
	tile_size = level_data['tile_size']
	name = level_data['name']
	objectives = level_data['objectives']
	challenges = level_data['challenges']
	tileSet = level_data['tileset']
	tiles = level_data['tiles']

func load_entities(map_path:String, entity_node):
	var path = map_path + "/entities.json"
	var entities_data = JsonParser.get_data_from_json(path)
	for i in range(entities_data['entity_number']):
		var entity = entities_data[str(i)]
		print(entity)
		var type = load(entity_types[entity['type']]).instance()
		var model = load(entity['path']).instance()
		entity_node.add_child(type)
		type.add_child(model)
		type.set_scale(Vector2(entity["scale"], entity["scale"]))
		type.set_position(Vector2(entity['coords'][0],entity['coords'][1]))
		if entity['flip_h']:
			model.flip_h()

func get_number_of_tiles():
	return size[0]*size[1]

func get_tileSet():
	return tileSet

func get_number_of_x_tiles():
	return size[0]

func get_number_of_y_tiles():
	return size[1]

func get_tile_size():
	return tile_size