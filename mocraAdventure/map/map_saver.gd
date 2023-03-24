extends Node

const types = {"life":"kill", "reach":"reach", "use":"use"}

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
	var file = FileAccess.open("user://" + name + "/map.json", FileAccess.WRITE)
	file.store_string(content)
	file.close()

func save_entities(entity_array:Array, name:String):
	var content = '{ "entity_number":' + str(len(entity_array)) + ','
	for i in range(len(entity_array)-1):
		content += '"' + str(i) + '": {"path":"' + entity_array[i]["path"] + '", "flip_h":' + str(entity_array[i]["flip_h"]).to_lower() + ', "flip_v":' + str(entity_array[i]["flip_v"]).to_lower() + ', "scale":' + str(entity_array[i]["scale"]) + ', "coords":' + str(entity_array[i]["coords"]) + ', "args":' + str(entity_array[i]["args"]) + ', "type":"' + entity_array[i]["type"] +'", "uid": "' + str(entity_array[i]["uid"]) + '"},\n'
	var last_index = len(entity_array)-1
	content += '"' + str(last_index) + '": {"path": "' + str(entity_array[last_index]["path"]) + '", "flip_h":' + str(entity_array[last_index]["flip_h"]).to_lower() + ', "flip_v":' + str(entity_array[last_index]["flip_v"]).to_lower() + ', "scale":' + str(entity_array[last_index]["scale"]) + ', "coords":' + str(entity_array[last_index]["coords"]) + ', "args":' + str(entity_array[last_index]["args"]) + ', "type":"' + entity_array[last_index]["type"] + '", "uid": "' + str(entity_array[last_index]["uid"]) +'"} }'
	var file = FileAccess.open("user://" + name + "/entities.json", FileAccess.WRITE)
	file.store_string(content)
	file.close()

func save_script(script_array:Array, name:String):
	var content = '{ "state_number": ' + str(len(script_array)) + ', \n'
	for i in range(len(script_array)-1):
		content += '"' + str(i) + '": ["' + str(script_array[i]["entity_id"]) + '", "' + types[script_array[i]["action"]] + '", "' + str(script_array[i]["title"]) + '", "' + str(script_array[i]["subtitle"]) + '"], \n'
	var index = len(script_array)-1
	content += '"' + str(index) + '": ["' + str(script_array[index]["entity_id"]) + '", "' + types[script_array[index]["action"]] + '", "' + str(script_array[index]["title"]) + '", "' + str(script_array[index]["subtitle"]) + '"] }'
	var file = FileAccess.open("user://" + name + "/script.json", FileAccess.WRITE)
	file.store_string(content)
	file.close()

func create_save_folder(name:String):
	var dir = DirAccess.open("user://")
	dir.make_dir(name)

func create_time_stamp_file(name:String):
	var file = FileAccess.open("user://" + name + "/TimeStamp", FileAccess.WRITE)
	file.store_string(str(Time.get_unix_time_from_system()))
	file.close()
