class_name MapConstrucor

var map = null
var tileMap = TileMap.new()
var counter = 0
var map_path

func set_map(chosen_map:Map):
	map = chosen_map

func load_tileSet():
	tileMap.set_tileset(load(map.get_tileSet())) 
	tileMap.set_cell_size(Vector2(map.get_tile_size(),map.get_tile_size()))

func displayMap():
	if map == null:
		return null
	for i in range(map.get_number_of_y_tiles()):
		for j in range(map.get_number_of_x_tiles()):
			tileMap.set_cell(j, i, map.tiles[counter])
			counter += 1
	var entities_node = Node2D.new()
	tileMap.add_child(entities_node)
	map.load_entities(map_path, entities_node)
	return tileMap

func set_map_path(new_map_path):
	map_path = new_map_path
