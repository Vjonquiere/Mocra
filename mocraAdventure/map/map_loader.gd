class_name map_loader

var available_entities = []

func _init():
	print("Map loader initied")

func is_map_loadable(path:String) -> bool:
	var dir = Directory.new()
	if !dir.dir_exists(path):
		return false
	dir.open(path)
	if !dir.file_exists("entities.json") || !dir.file_exists("map.json") || !dir.file_exists("script.json"):
		return false
	return true

func load_tiles(path:String):
	var tiles = JsonParser.get_data_from_json(path+"/map.json")
	var commands = []
	var xSize = int(tiles["size"].split("x")[0]) 
	var ySize = int(tiles["size"].split("x")[1])
	var counter = 0
	for y in range(ySize):
		for x in range(xSize):
			commands.append(["place_tile", [x,y], tiles["tiles"][counter]])
			counter += 1
	return commands

func generate_available_entities():
	var entities_list = JsonParser.get_data_from_json("res://mocraAdventure/map/entities/entities.json") 
	for i in range(entities_list["entities_number"]):
		available_entities.append(entities_list[str(i)]["path"])

func load_entities(path:String):
	generate_available_entities()
	var commands = []
	var entities = JsonParser.get_data_from_json(path+"/entities.json")
	for i in range(entities["entity_number"]):
		if available_entities.find(entities[str(i)]["path"], 0) != -1:
			commands.append(["place_entity", available_entities.find(entities[str(i)]["path"], 0), get_real_tile_with_entity_path(entities[str(i)]["path"], entities[str(i)]["coords"])])
	return commands

func get_real_tile_with_entity_path(path:String, coords:Array):
	var entities = JsonParser.get_data_from_json("res://mocraAdventure/map/entities/entities.json")
	for i in range(entities["entities_number"]):
		if entities[str(i)]["path"] == path:
			var size = [int(ceil((entities[str(i)]["x_size"]*0.25)/100)), int(ceil((entities[str(i)]["y_size"]*0.25)/100))]
			return [(coords[0]-50*size[0])/100, (coords[1]-50*size[1])/100]

func get_coords_with_uid(uid:String, path:String):
	var entities = JsonParser.get_data_from_json(path+"/entities.json")
	for i in range(entities["entity_number"]):
		if entities[str(i)]["uid"] == uid:
			return get_real_tile_with_entity_path(entities[str(i)]["path"], entities[str(i)]["coords"])

func load_script(path:String):
	var script = JsonParser.get_data_from_json(path+"/script.json")
	var coords = []
	for i in range(script["state_number"]):
		coords.append(get_coords_with_uid(script[str(i)][0], path))
	return coords

func load_from_path(path:String) -> Dictionary:
	if is_map_loadable(path):
		var tiles = load_tiles(path)
		var entities = load_entities(path)
		var script = load_script(path)
		return {"status": 1, "tiles": tiles, "entities": entities, "script": script}
	else:
		return {"status": -1}

func get_default_args(path:String) -> Dictionary:
	if is_map_loadable(path):
		var map = JsonParser.get_data_from_json(path+"/map.json")
		return {"status": 1, "size":[int(map["size"].split("x")[0]), int(map["size"].split("x")[1])], "tile_size":int(map["tile_size"]), "name":map["name"], "tile_set_path":"res://mocraAdventure/map/tilesets/1/tileset.tres"}
	return {"status": -1}
