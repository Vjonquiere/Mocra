class_name ScriptStates

var script_state_template = load("res://mocraAdventure/map_editor/script/Control.tscn")

var script_states = []
var script_state_objects = []

var parent
var entities
var tiles

## All setters
func set_parent(new_parent):
	parent = new_parent

func set_entities(new_entities):
	entities = new_entities

func set_tiles(new_tiles):
	tiles = new_tiles

## All getters
func get_parent():
	return parent

func get_entities():
	return entities

func get_tiles():
	return tiles

func get_script_states() -> Array:
	return script_states

func get_script_states_objects() -> Array:
	return script_state_objects

func add_script_state(coords, init_node) -> int:
	var entity = entities.get_entity(coords)
	if entity == null || !check_if_unic_state(entity["uid"]) || entity["type"] == "none":
		return -1
	var template = script_state_template.instance()
	template.init_identity(entity["path"], "avatar_path:String", entity["coords"], entity["type"], entity["uid"], init_node)
	parent.script_editor_add_child(template)
	script_state_objects.append(template)
	script_states.append({"entity_id": entity["uid"], "action": entity["type"], "title": "", "subtitle":""})
	return 1

"""func add_script_state(raw_tile, init_node):
	if entities.entity_place_checker([int(raw_tile[0]),int(raw_tile[1])]):
		return
	var closest = entities.get_closest_entity([int(raw_tile[0]),int(raw_tile[1])])
	if closest != null and check_if_unic_state(closest):
		var template = script_state_template.instance()
		var entity = entities.placed_entities[closest]
		template.init_identity(entity["path"], "avatar_path:String", entity["coords"], entity["type"], closest, init_node)
		parent.script_editor_add_child(template)
		script_state_objects.append(template)
		script_states.append({"entity_id": closest, "action": entity["type"], "title": "", "subtitle":""})"""


func check_if_unic_state(entity_id):
	for i in range(len(script_states)):
		if script_states[i]["entity_id"] == entity_id:
			return false
	return true
	
