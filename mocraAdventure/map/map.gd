class_name Map


var size = []
var tile_size
var name = ""
var objectives = []
var challenges = {'50': null, '75': null, '100': null}
var tiles = []
var tileSet

func load_map(map_path:String):
	var level_data = JsonParser.get_data_from_json(map_path)
	size = level_data['size'].split("x")
	tile_size = level_data['tile_size']
	name = level_data['name']
	objectives = level_data['objectives']
	challenges = level_data['challenges']
	tileSet = level_data['tileset']
	tiles = level_data['tiles']


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
