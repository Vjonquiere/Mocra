extends Node2D

var tile_map = TileMap.new()
var tile_set
var tile_set_p
var tileset_tile_size
var edition = false
var tile_selector = load("res://mocraAdventure/map_editor/selector/Selector.tscn").instance()
var entity_selector = load("res://mocraAdventure/map_editor/selector/entitySelector.tscn").instance()
var placed_entities = []
var placed_entities_coords = []
var tile = []
var raw_tile = []
var size = []
var map_name 
var selected_tile = null
var selected_entity = null 
var selected_type = null
var camera_speed = 1

signal tile_selected(tile_number)
signal entity_selected(entity_number)
signal init_editor(map_size, tile_size, name, tile_set_path)
# Called when the node enters the scene tree for the first time.
func _ready():
	var menu = load("res://mocraAdventure/map_editor/Menu.tscn").instance()
	$".".add_child(menu)
	entity_selector.set_node($".")

func load_tileset(path:String):
	tile_set = load(path)

func _on_Node2D_init_editor(map_size:Array, tile_size:int, name:String, tile_set_path:String):
	size = map_size
	map_name = name
	tile_set_p = tile_set_path
	tileset_tile_size = tile_size
	tile_selector.init_selector(tile_set_path)
	entity_selector.init_selector("res://mocraAdventure/map/entities/entities.json")
	tile_map.set_tileset(load(tile_set_path))
	tile_map.set_cell_size(Vector2(tile_size,tile_size))
	for i in range(int(map_size[1])):
		for j in range(int(map_size[0])):
			tile_map.set_cell(j,i,0)
	$".".add_child(tile_map)
	$Camera2D/CanvasLayer.add_child(tile_selector)
	$Camera2D/CanvasLayer.add_child(entity_selector)
	tile_selector.set_position(Vector2(210,850))
#	selector.set_z_index(1)
	tile_selector.visible = false
	entity_selector.visible = false
	tile_map.set_z_index(-1)
	$Camera2D._set_current(true)
	edition = true
	print("EDITOR INITIED : map_size = ", map_size, " tile_size = ", tile_size, " name = ", name, " tile_set_path: ", tile_set_path)

func get_input():
	if Input.is_action_pressed("editor_zoom_-"):
		return "zoom_-"
	if Input.is_action_pressed("editor_zoom_+"):
		return "zoom_+"
	if Input.is_action_pressed("editor_translate_up"):
		return "translate_up"
	if Input.is_action_pressed("editor_translate_down"):
		return "translate_down"
	if Input.is_action_pressed("editor_translate_left"):
		return "translate_left"
	if Input.is_action_pressed("editor_translate_right"):
		return "translate_right"
	if Input.is_action_just_pressed("editor_mouse_l"):
		return "get_pos"
	
func _process(delta):
	var input = get_input()
	if input == "zoom_-":
		$Camera2D.set_zoom(Vector2($Camera2D.get_zoom()[0] +0.01 , $Camera2D.get_zoom()[1] +0.01))
		$Camera2D/CanvasLayer/cameraZoomVSlider.value = $Camera2D.get_zoom()[0]

	elif input == "zoom_+":
		$Camera2D.set_zoom(Vector2($Camera2D.get_zoom()[0] -0.01 , $Camera2D.get_zoom()[1] -0.01))
		$Camera2D/CanvasLayer/cameraZoomVSlider.value = $Camera2D.get_zoom()[0]

	elif input == "translate_up":
		if $Camera2D.get_offset()[1] > -200:
			$Camera2D.set_offset(Vector2($Camera2D.get_offset()[0] , $Camera2D.get_offset()[1] -camera_speed))

	elif input == "translate_down":
		if $Camera2D.get_offset()[1] < size[1]*100+200:
			$Camera2D.set_offset(Vector2($Camera2D.get_offset()[0] , $Camera2D.get_offset()[1] +camera_speed))

	elif input == "translate_left":
		if $Camera2D.get_offset()[0] > -200:
			$Camera2D.set_offset(Vector2($Camera2D.get_offset()[0] -camera_speed , $Camera2D.get_offset()[1]))

	elif input == "translate_right":
		if $Camera2D.get_offset()[0] < size[0]*100+200:
			$Camera2D.set_offset(Vector2($Camera2D.get_offset()[0] +camera_speed , $Camera2D.get_offset()[1]))

	elif input == "get_pos" and edition:
#		print("EDITION : ", edition)
#		edition = false
		raw_tile = [int(tile_map.get_local_mouse_position()[0]), int(tile_map.get_local_mouse_position()[1])]
		tile = [int(tile_map.get_local_mouse_position()[0]/tileset_tile_size), int(tile_map.get_local_mouse_position()[1]/tileset_tile_size)]
		tile_selector.visible = true
		entity_selector.visible = true
		if selected_type == "tile":
			place_tile(selected_tile)
		elif selected_type == "entity":
			place_entity(selected_entity)
#		print("MOUSE POSITION => ", tile_map.get_local_mouse_position())
#		print("TILE => ", tile)

func place_tile(tile_number):
	if tile[0] < size[0] and tile[1] < size[1] and selected_tile != null:
		tile_map.set_cell(tile[0], tile[1], tile_number)

func place_entity(entity_number):
	if tile[0] < size[0] and tile[1] < size[1] and selected_entity != null and entity_place_checker([int(raw_tile[0]),int(raw_tile[1])]) == true:
		var entities = JsonParser.get_data_from_json("res://mocraAdventure/map/entities/entities.json")
		var entity = load(entities[str(entity_number)]["path"]).instance()
		tile_map.add_child(entity)
		entity.position = Vector2(raw_tile[0], raw_tile[1])
		entity.scale = Vector2(0.3,0.3)
		placed_entities.append({"model":entity, "path":entities[str(entity_number)]["path"], "flip_h":false, "flip_v":false, "scale":0.3, "coords":[int(raw_tile[0]), int(raw_tile[1])], "args": []})
	elif entity_place_checker([int(raw_tile[0]),int(raw_tile[1])]) == false:
		var closest = get_closest_entity([int(raw_tile[0]),int(raw_tile[1])])
		if closest != null:
			placed_entities[closest]["model"].queue_free()
			placed_entities.remove(closest)

func entity_place_checker(entity_coords) -> bool:
	if len(placed_entities) == 0:
		return true
	for i in range(len(placed_entities)):
		if pow(pow(placed_entities[i]["coords"][0]-entity_coords[0],2)+pow(placed_entities[i]["coords"][1]-entity_coords[1],2), 0.5) < 50:
			return false
	return true

func get_closest_entity(coords):
	var closest = 0
	var closest_coords = placed_entities[0]["coords"]
	var closest_dist = pow(pow(placed_entities[0]["coords"][0]-coords[0],2)+pow(placed_entities[0]["coords"][1]-coords[1],2), 0.5)
	for i in range(len(placed_entities)):
		var entity_coords = placed_entities[i]["coords"]
		if pow(pow(entity_coords[0]-coords[0],2)+pow(entity_coords[1]-coords[1],2), 0.5) < closest_dist:
			closest = i
			closest_coords = entity_coords
			closest_dist = pow(pow(entity_coords[0]-coords[0],2)+pow(entity_coords[1]-coords[1],2), 0.5)
	if closest <= 50:
		return closest
	else:
		return null

func _on_Node2D_tile_selected(tile_number):
	selected_tile = tile_number
	selected_type = "tile"

func _on_saveButton_pressed():
	MapSaver.save_map(size, tileset_tile_size, map_name, tile_set_p, MapSaver.tile_map_to_array(size, tile_map))

func _on_Node2D_entity_selected(entity_number):
	selected_entity = entity_number
	selected_type = "entity"


func _on_cameraSpeedVSlider_value_changed(value):
	camera_speed = value


func _on_cameraZoomVSlider_value_changed(value):
	$Camera2D.set_zoom(Vector2(value , value))
