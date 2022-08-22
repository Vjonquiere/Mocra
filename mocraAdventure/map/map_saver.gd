extends Node

func tile_map_to_array(size:Array, map:TileMap) -> Array:
	var map_array = []
	for i in range(size[0]):
		for j in range(size[1]):
			map_array.append(map.get_cell(i, j))
	return map_array

func save_map(size:Array, tile_size:int, name:String, tileset_path:String, tiles:Array):
	var size_str = str(size[0]) + "x" + str(size[1])
	var content = '{"size": "' + size_str + '", "tile_size": "'+ str(tile_size) + '", "name": "' + name + '", "objectives" : ["1", "2", "3"], "challenges" : {"50":"A", "75":"B", "100":"C"}, "tileset": "' + tileset_path + '", "tiles":  ['
	for i in range(len(tiles)-1):
		content += str(tiles[i]) + ","
	var final_char = str(tiles[len(tiles)-1]) + ']}'
	content += final_char
	var file = File.new()
	file.open("user://" + name + ".json", File.WRITE)
	file.store_string(content)
	file.close()

