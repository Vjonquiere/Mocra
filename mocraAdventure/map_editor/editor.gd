extends Node2D

const max_entities = 200

var tile_map = TileMap.new()
var control_tile_map = Control.new()
var error_timer = Timer.new()
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
var mouse_in = false
var auto_v_align = false
var auto_h_align = false


## SCRIPT EDITOR
var script_states = []
var script_state_template = load("res://mocraAdventure/map_editor/script/Control.tscn")
var script_state_objects = []

signal tile_selected(tile_number)
signal entity_selected(entity_number)
signal init_editor(map_size, tile_size, name, tile_set_path)
signal remove_script_state(entity_id)
# Called when the node enters the scene tree for the first time.
func _ready():
	var menu = load("res://mocraAdventure/map_editor/Menu.tscn").instance()
	$".".add_child(menu)
	error_timer_init()
	entity_selector.set_node($".")
	control_tile_map.connect("mouse_entered", self, "_on_mouse_entered")
	control_tile_map.connect("mouse_exited", self, "_on_mouse_exited")

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
	control_tile_map.set_size(Vector2(tile_size*map_size[0],tile_size*map_size[1]))
	tile_map.add_child(control_tile_map)
	$Camera2D/CanvasLayer.add_child(tile_selector)
	$Camera2D/CanvasLayer.add_child(entity_selector)
	tile_selector.set_position(Vector2(210,850))
	entity_selector.set_position(Vector2(10,200))
#	selector.set_z_index(1)
	tile_selector.visible = true
	entity_selector.visible = true
	tile_map.set_z_index(-1)
	$Camera2D._set_current(true)
	edition = true
	$Camera2D/CanvasLayer/GUI.visible = true
	print("EDITOR INITIED : map_size = ", map_size, " tile_size = ", tile_size, " name = ", name, " tile_set_path: ", tile_set_path)

func get_input():
	if Input.is_action_just_released("editor_zoom_-") and mouse_in == true:
		return "zoom_-"
	if Input.is_action_just_released("editor_zoom_+") and mouse_in == true:
		return "zoom_+"
	if Input.is_action_pressed("editor_zoom_-") and mouse_in == true:
		return "zoom_-"
	if Input.is_action_pressed("editor_zoom_+") and mouse_in == true:
		return "zoom_+"
	if Input.is_action_pressed("editor_translate_up"):
		return "translate_up"
	if Input.is_action_pressed("editor_translate_down"):
		return "translate_down"
	if Input.is_action_pressed("editor_translate_left"):
		return "translate_left"
	if Input.is_action_pressed("editor_translate_right"):
		return "translate_right"
	if Input.is_action_pressed("editor_mouse_l") and mouse_in == true:
		return "get_pos"
	
func _process(delta):
	var input = get_input()
	if input == "zoom_-":
		$Camera2D.set_zoom(Vector2($Camera2D.get_zoom()[0] +0.01 , $Camera2D.get_zoom()[1] +0.01))
		$Camera2D/CanvasLayer/GUI/cameraZoomVSlider.value = $Camera2D.get_zoom()[0]

	elif input == "zoom_+":
		$Camera2D.set_zoom(Vector2($Camera2D.get_zoom()[0] -0.01 , $Camera2D.get_zoom()[1] -0.01))
		$Camera2D/CanvasLayer/GUI/cameraZoomVSlider.value = $Camera2D.get_zoom()[0]

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
		elif selected_type == "entity" and len(placed_entities) < max_entities:
			if auto_v_align and auto_h_align:
				place_entity(selected_entity, true, true)
			elif auto_h_align:
				place_entity(selected_entity, false, true)
			elif auto_v_align:
				place_entity(selected_entity, true, false)
			else:
				place_entity(selected_entity)
			update_entities_number_label()
		elif selected_type == "deleting_entities":
			remove_entity()
			update_entities_number_label()
	
	elif input == "get_pos" and !edition:
		raw_tile = [int(tile_map.get_local_mouse_position()[0]), int(tile_map.get_local_mouse_position()[1])]
		if selected_type == "script":
			add_script_state()

func add_script_state():
	if entity_place_checker([int(raw_tile[0]),int(raw_tile[1])]) == false:
		var closest = get_closest_entity([int(raw_tile[0]),int(raw_tile[1])])
		if closest != null and check_if_unic_state(closest):
			var template = script_state_template.instance()
			template.init_identity(placed_entities[closest]["path"], "avatar_path:String", placed_entities[closest]["coords"], placed_entities[closest]["type"], closest, $".")
			$script_editor/VBoxContainer.add_child(template)
			script_state_objects.append(template)
			script_states.append({"entity_id": closest, "action": placed_entities[closest]["type"], "title": "", "subtitle":""})
		selected_type = "tile"
		display_overlay()
		edition = true

func check_if_unic_state(entity_id):
	for i in range(len(script_states)):
		if script_states[i]["entity_id"] == entity_id:
			return false
	return true

func remove_entity():
	if entity_place_checker([int(raw_tile[0]),int(raw_tile[1])]) == false:
		var closest = get_closest_entity([int(raw_tile[0]),int(raw_tile[1])])
		if closest != null:
			placed_entities[closest]["model"].queue_free()
			placed_entities.remove(closest)
			emit_signal("remove_script_state", closest)

func place_tile(tile_number):
	if tile[0] < size[0] and tile[1] < size[1] and selected_tile != null:
		tile_map.set_cell(tile[0], tile[1], tile_number)

func place_entity(entity_number, v_align=false, h_align=false):
	if tile[0] < size[0] and tile[1] < size[1] and selected_entity != null and entity_place_checker([int(raw_tile[0]),int(raw_tile[1])]) == true:
		var entities = JsonParser.get_data_from_json("res://mocraAdventure/map/entities/entities.json")
		var entity = load(entities[str(entity_number)]["path"]).instance()
		tile_map.add_child(entity)
		var pos
		pos = Vector2(raw_tile[0], raw_tile[1])
		entity.scale = Vector2(0.25,0.25)
		if v_align:
			pos[1] =get_closest_entity_coords([int(raw_tile[0]),int(raw_tile[1])])[1]
		if h_align:
			pos[0] = entity_selector.get_entity_size(str(entity_number))[0]*0.25 + get_closest_entity_coords([int(raw_tile[0]),int(raw_tile[1])])[0]
		entity.position = pos
		placed_entities.append({"type": entities[str(entity_number)]["type"], "model":entity, "path":entities[str(entity_number)]["path"], "flip_h":false, "flip_v":false, "scale":0.25, "coords":[int(pos[0]), int(pos[1])], "args": []})

func update_entities_number_label() -> void:
	$Camera2D/CanvasLayer/GUI/EntityLabel.set_text(str(len(placed_entities)) + "/" + str(max_entities) + " entities")

func entity_place_checker(entity_coords) -> bool:
	if len(placed_entities) == 0:
		return true
	for i in range(len(placed_entities)):
		if pow(pow(placed_entities[i]["coords"][0]-entity_coords[0],2)+pow(placed_entities[i]["coords"][1]-entity_coords[1],2), 0.5) < 50:
			return false
	return true

func get_closest_entity_coords(coords):
	var closest = 0
	var closest_coords = placed_entities[0]["coords"]
	var closest_dist = pow(pow(placed_entities[0]["coords"][0]-coords[0],2)+pow(placed_entities[0]["coords"][1]-coords[1],2), 0.5)
	var entity_coords
	for i in range(len(placed_entities)):
		entity_coords = placed_entities[i]["coords"]
		if pow(pow(entity_coords[0]-coords[0],2)+pow(entity_coords[1]-coords[1],2), 0.5) < closest_dist:
			closest = i
			closest_coords = entity_coords
			closest_dist = pow(pow(entity_coords[0]-coords[0],2)+pow(entity_coords[1]-coords[1],2), 0.5)
	return entity_coords

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
	$Camera2D/CanvasLayer/GUI/deleteEntityButton.pressed = false

func error_timer_init():
	$".".add_child(error_timer)
	error_timer.connect("timeout", self, "_on_error_timer_timeout")
	error_timer.set_one_shot(true)
	error_timer.set_wait_time(5.0)

func _on_error_timer_timeout():
	$Camera2D/CanvasLayer/GUI/errorLabel.hide()

func display_error(error:String):
	$Camera2D/CanvasLayer/GUI/errorLabel.set_text(error)
	$Camera2D/CanvasLayer/GUI/errorLabel.show()
	error_timer.start()

func _on_saveButton_pressed():
	if is_map_savable():
		MapSaver.create_save_folder(map_name)
		MapSaver.save_map(size, tileset_tile_size, map_name, tile_set_p, MapSaver.tile_map_to_array(size, tile_map))
		MapSaver.save_entities(placed_entities, map_name)
		MapSaver.save_script(script_states, map_name)

func is_map_savable() -> bool:
	if len(script_states) == 0:
		display_error("Can't save map without at least one script state")
		return false
	if len(placed_entities) > max_entities:
		display_error("Maps can only contain " + str(max_entities) + " entities")
		return false
	return true

func _on_Node2D_entity_selected(entity_number):
	selected_entity = entity_number
	selected_type = "entity"
	$Camera2D/CanvasLayer/GUI/deleteEntityButton.pressed = false
	tile_selector.set_selected_tile(null)

func _on_cameraSpeedVSlider_value_changed(value):
	camera_speed = value


func _on_cameraZoomVSlider_value_changed(value):
	$Camera2D.set_zoom(Vector2(value , value))

func _on_deleteEntityButton_toggled(button_pressed):
	if button_pressed:
		selected_type = "deleting_entities"
		tile_selector.set_selected_tile(null)
	else:
		if selected_type == "deleting_entities":
			selected_type = "entity"


func display_overlay():
	$Camera2D/CanvasLayer/GUI.visible = true


func _on_addSciptButton_pressed():
	$script_editor.visible = false
	tile_map.visible = true
	$Camera2D.current = true
	tile_selector.visible = false
	entity_selector.visible = false
	selected_type = "script"


func _on_gameScriptButton_pressed():
	edition = false
	$script_editor.visible = true
	$script_editor/scriptEditorCamera.current = true
	$Camera2D/CanvasLayer/GUI.set_visible(false)
	tile_selector.visible = false
	entity_selector.visible = false
	tile_map.visible = false


func _on_Node2D_remove_script_state(entity_id):
	for i in range(len(script_state_objects)):
		if script_state_objects[i].get_entity_id() == entity_id:
			script_states.remove(i)
			script_state_objects[i].queue_free()
			script_state_objects.remove(i)
			break

func _on_backButton_pressed():
	$script_editor.visible = false
	tile_map.visible = true
	$Camera2D.current = true
	tile_selector.visible = true
	entity_selector.visible = true
	selected_type = "tile"
	display_overlay()
	edition = true


func change_script_title(entity_id, text):
	for i in range(len(script_state_objects)):
		if script_state_objects[i].get_entity_id() == entity_id:
			script_states[i]["title"] = text

func change_script_subtitle(entity_id, text):
	for i in range(len(script_state_objects)):
		if script_state_objects[i].get_entity_id() == entity_id:
			script_states[i]["subtitle"] = text

func _on_mouse_entered():
	mouse_in = true

func _on_mouse_exited():
	mouse_in = false




func _on_CheckBox_toggled(button_pressed):
	auto_v_align = button_pressed


func _on_CheckBox2_toggled(button_pressed):
	auto_h_align = button_pressed
