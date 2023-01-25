class_name Entities

var placed_entities = []

var parent
var script_state
var tiles

var entities = JsonParser.get_data_from_json("res://mocraAdventure/map/entities/entities.json")

## All setters
func set_parent(new_parent):
	parent = new_parent

func set_script_state(new_script_state):
	script_state = new_script_state

func set_tiles(new_tiles):
	tiles = new_tiles

## All getters
func get_parent():
	return parent

func get_script_state():
	return script_state

func get_tiles():
	return tiles

func get_entity_count() -> int:
	return len(placed_entities)

func get_entities() -> Array:
	return placed_entities

func generate_uid(length):
	var uid = ""
	var possible_choice = ["a", "b", "c", "d", "e", "f", "0", "1", "2", "3"]
	for i in range(length):
		uid += possible_choice[randi()%len(possible_choice)]
	return uid

func place_entity(origin, entity_id):
	var size = [int(ceil((entities[str(entity_id)]["x_size"]*0.25)/100)), int(ceil((entities[str(entity_id)]["y_size"]*0.25)/100))] ## Incorrect for little entities (size < 100)
	print("Entity size: ", size)
	var occupied_tiles = get_occupied_tiles(origin, size)
	for tiles in occupied_tiles:
		if get_entity(tiles) != null:
			print("Can't place an entity on a other")
			return null
	var uid = null
	while uid == null or parent.has_uid(uid):
		uid = generate_uid(10) 
	placed_entities.append({"uid": uid, "type": entities[str(entity_id)]["type"], "occupied_tiles": occupied_tiles , "path":entities[str(entity_id)]["path"], "flip_h":false, "flip_v":false, "scale":0.25, "coords":[origin[0]*100, origin[1]*100], "args": []})
	return [uid, entities[str(entity_id)]["path"]]

func remove_entity(tile):
	print(placed_entities)
	var entity = get_entity(tile)
	if entity == null:
		return null
	placed_entities.erase(entity)
	return entity["uid"]

func get_occupied_tiles(origin, size):
	var occupied_tiles = []
	for x in range(size[0]):
		for y in range(size[1]):
			occupied_tiles.append([origin[0]+x, origin[1]+y])
	return occupied_tiles

func get_entity(coords):
	for entities in placed_entities:
		if coords in entities["occupied_tiles"]:
			return entities
	return null

