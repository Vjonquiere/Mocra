class_name Tiles

func _init():
	print("Tiles module initied")

var collisionNode = Control.new()
var tile_map = TileMap.new()
var map_size = [null, null]

# All getters
func get_tile_map():
	return tile_map

func set_map_size(size):
	map_size = size

func set_tile_set(tile_set_path):
	tile_map.set_tileset(load(tile_set_path))

func set_cell_size(tile_size):
	tile_map.set_cell_size(tile_size)

# All setters
func get_map_size():
	return map_size

func fill_cells():
	for i in range(int(map_size[1])):
		for j in range(int(map_size[0])):
			tile_map.set_cell(j,i,0)

func place_tile(tile_index, tile):
	if tile[0] < map_size[0] and tile[1] < map_size[1]:
		tile_map.set_cell(tile[0], tile[1], tile_index)
