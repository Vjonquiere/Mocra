class_name MapConstrucor

var map = null
var tileMap = TileMap.new()
var counter = 0

func set_map(map1):
	map = map1

func load_tileSet():
	tileMap.set_tileset(load(map.get_tileSet())) 
	tileMap.set_cell_size(Vector2(map.get_tile_size(),map.get_tile_size()))

func displayMap():
	if map == null:
		return
	for i in range(map.get_number_of_y_tiles()):
		for j in range(map.get_number_of_x_tiles()):
			tileMap.set_cell(j, i, map.tiles[counter])
			counter += 1
	return tileMap

