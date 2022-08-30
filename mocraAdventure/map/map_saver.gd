extends Node

func tile_map_to_array(size:Array, map:TileMap) -> Array:
	var map_array = []
	for i in range(size[1]):
		for j in range(size[0]):
			map_array.append(map.get_cell(j, i))
	return map_array

func save_map(size:Array, tile_size:int, name:String, tileset_path:String, tiles:Array):
	var size_str = str(size[0]) + "x" + str(size[1])
	var content = '{"size": "' + size_str + '", "tile_size": "'+ str(tile_size) + '", "name": "' + name + '", "objectives" : ["1", "2", "3"], "challenges" : {"50":"A", "75":"B", "100":"C"}, "tileset": "' + tileset_path + '", "tiles":  ['
	for i in range(len(tiles)-1):
		content += str(tiles[i]) + ","
	var final_char = str(tiles[len(tiles)-1]) + ']}'
	content += final_char
	var file = File.new()
	file.open("user://" + name + "/map.json", File.WRITE)
	file.store_string(content)
	file.close()

func save_entities(entity_array:Array, name:String):
	var content = '{ "entity_number":' + str(len(entity_array)) + ','
	for i in range(len(entity_array)-1):
		content += '"' + str(i) + '": {"path":"' + entity_array[i]["path"] + '", "flip_h":' + str(entity_array[i]["flip_h"]).to_lower() + ', "flip_v":' + str(entity_array[i]["flip_v"]).to_lower() + ', "scale":' + str(entity_array[i]["scale"]) + ', "coords":' + str(entity_array[i]["coords"]) + ', "args":' + str(entity_array[i]["args"]) + ', "type":"' + entity_array[i]["type"] + '"},'
	var last_index = len(entity_array)-1
	content += '"' + str(last_index) + '": {"path": "' + str(entity_array[last_index]["path"]) + '", "flip_h":' + str(entity_array[last_index]["flip_h"]).to_lower() + ', "flip_v":' + str(entity_array[last_index]["flip_v"]).to_lower() + ', "scale":' + str(entity_array[last_index]["scale"]) + ', "coords":' + str(entity_array[last_index]["coords"]) + ', "args":' + str(entity_array[last_index]["args"]) + ', "type":"' + entity_array[last_index]["type"] + '"} }'
	var file = File.new()
	file.open("user://" + name + "/entities.json", File.WRITE)
	file.store_string(content)
	file.close()

func create_save_folder(name:String):
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir(name)
