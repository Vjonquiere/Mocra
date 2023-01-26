extends Node2D

const max_entities = 200

var error_timer = Timer.new()
var entity_placer_timer = Timer.new()
var entity_placing = true
var tile_set
var tile_set_p
var tileset_tile_size
var edition = false

var tile_selector = load("res://mocraAdventure/map_editor/selector/Selector.tscn").instance()
var entity_selector = load("res://mocraAdventure/map_editor/selector/entitySelector.tscn").instance()
var dialog = load("res://mocraAdventure/map_editor/dialog/dialog.tscn").instance()

var collisionNode = Control.new() ## Used to detect if cursor is on tileMap

var tmp_label = Label.new()

var mEntities = Entities.new()
var mScriptState = ScriptStates.new()
var mTiles = Tiles.new()

var entities_models = {}

var size = []
var tile = []
var raw_click = [null, null]
var map_name 
var selected_tile = null
var selected_entity = null 
var selected_type = null
var camera_speed = 1
var mouse_in = false
var auto_v_align = false
var auto_h_align = false
var auto_tile_align = false


signal tile_selected(tile_number)
signal entity_selected(entity_number)
signal init_editor(map_size, tile_size, name, tile_set_path)
signal remove_script_state(entity_id)
signal dialog_entered(status)
# Called when the node enters the scene tree for the first time.
func _ready():
	var menu = load("res://mocraAdventure/map_editor/Menu.tscn").instance()
	$".".add_child(menu)
	$".".add_child(dialog)
	dialog.set_scale(Vector2(0.5,0.5))
	dialog.hide()
	error_timer_init()
	entity_selector.set_node($".")
#	dialog.connect("mouse_entered", self, "_on_dialog_mouse_entered")
#	dialog.connect("mouse_exited", self, "_on_dialog_mouse_exited")
	$".".add_child(entity_placer_timer)
	entity_placer_timer.connect("timeout", self, "_on_entity_placer_timeout")
	entity_placer_timer.set_wait_time(0.5)

func load_tileset(path:String):
	tile_set = load(path)

func _on_Node2D_init_editor(map_size:Array, tile_size:int, name:String, tile_set_path:String, default_tiles=[], default_entities=[], default_script=[]):
	map_name = name
	tile_set_p = tile_set_path
	tileset_tile_size = tile_size
	tile_selector.init_selector(tile_set_path)
	entity_selector.init_selector("res://mocraAdventure/map/entities/entities.json")
	
	mScriptState.set_entities(mEntities)
	mScriptState.set_parent(self)
	
	size = map_size
	mTiles.set_map_size(map_size)
	mTiles.set_tile_set(tile_set_path)
	mTiles.set_cell_size(Vector2(tile_size,tile_size))
	mTiles.fill_cells()
	$".".add_child(mTiles.get_tile_map())
	mTiles.get_tile_map().set_z_index(-1)
	$Camera2D/CanvasLayer.add_child(tile_selector)
	$Camera2D/CanvasLayer.add_child(entity_selector)
	
	$".".add_child(collisionNode)
	collisionNode.set_size(Vector2(tile_size*map_size[0],tile_size*map_size[1]))
	collisionNode.connect("mouse_entered",self, "_on_mouse_entered")
	collisionNode.connect("mouse_exited",self, "_on_mouse_exited")
	
	mEntities.set_parent(self)
	
	$".".add_child(tmp_label)
	
	tile_selector.set_position(Vector2(210,850))
	entity_selector.set_position(Vector2(10,200))
#	selector.set_z_index(1)
	tile_selector.visible = true
	entity_selector.visible = true

	$Camera2D._set_current(true)
	edition = true
	$Camera2D/CanvasLayer/GUI.visible = true
	print("EDITOR INITIED : map_size = ", map_size, " tile_size = ", tile_size, " name = ", name, " tile_set_path: ", tile_set_path)
	for command in default_tiles:
		place_tile(command[2], command[1], true)
	for command in default_entities:
		place_entity(command[1], command[2])
	for command in default_script:
		add_script_state(command[0])

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
	#var mouse_pos = get_global_mouse_position()
	#tmp_label.set_position(Vector2(mouse_pos[0]-50, mouse_pos[1]-50))
	#tmp_label.set_text(str(int(mTiles.get_tile_map().get_local_mouse_position()[0]/100)) + "," + str(int(mTiles.get_tile_map().get_local_mouse_position()[1]/100)))

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
		raw_click = [int(mTiles.get_tile_map().get_local_mouse_position()[0]), int(mTiles.get_tile_map().get_local_mouse_position()[1])]
		tile = [int(raw_click[0]/tileset_tile_size), int(raw_click[1]/tileset_tile_size)]
		tile_selector.visible = true
		entity_selector.visible = true
		if selected_type == "tile":
			place_tile(selected_tile, tile)
		elif selected_type == "entity" and mEntities.get_entity_count() < max_entities and entity_placing:
			entity_placing = false
			entity_placer_timer.start()
			place_entity(selected_entity, tile)
			update_entities_number_label()
		elif selected_type == "deleting_entities":
			remove_entity(tile)
			update_entities_number_label()
	
	elif input == "get_pos" and !edition:
		raw_click = [int(mTiles.get_tile_map().get_local_mouse_position()[0]), int(mTiles.get_tile_map().get_local_mouse_position()[1])]
		tile = [int(raw_click[0]/tileset_tile_size), int(raw_click[1]/tileset_tile_size)]
		if selected_type == "script":
			add_script_state(tile)

func add_script_state(tile):
	if mScriptState.add_script_state(tile, $".") == -1:
		display_error("Can't create an script state for this tile")
	selected_type = "tile"
	display_overlay()
	edition = true

func script_editor_add_child(child):
	$script_editor/VBoxContainer.add_child(child)

func place_tile(tile_index, tile, forced=false):
	if selected_tile != null || forced:
		mTiles.place_tile(tile_index, tile)

func place_entity(entity_id, tile):
	var _entity = mEntities.place_entity(tile, entity_id)
	if  _entity != null: # Entity can be placed
		var entity = load(_entity[1]).instance()
		mTiles.get_tile_map().add_child(entity)
		entity.scale = Vector2(0.25,0.25) # Constant size reducing
		entity.set_position(Vector2(tile[0]*100+_entity[2][0]*50, tile[1]*100+_entity[2][1]*50))
		entities_models[_entity[0]] = entity
	else:
		display_error("An error as occured when trying to place entity") # An entity is already present at given tile

		"""var entity = placed_entities[get_closest_entity([int(raw_tile[0]),int(raw_tile[1])])] ### Move to parent
		if entity["path"] == "res://mocraAdventure/map/entities/house1/entity.tscn":
			dialog.set_position(Vector2(int(raw_tile[0])-90,int(raw_tile[1])-200))
			dialog.set_entity_label(entity["type"])
			dialog.set_mode("warp")
			dialog.show()""" ## ALL THE CODE PREVIOUSLY EXECUTED WHEN NOT ENOUGHT PLACE

func remove_entity(tile):
	var uid = mEntities.remove_entity(tile)
	if uid != null:
		entities_models[uid].queue_free()
		entities_models.erase(uid)
		emit_signal("remove_script_state", uid)
	else:
		display_error("There isn't an entity to delete")

func has_uid(uid):
	return uid in entities_models
	

func update_entities_number_label() -> void:
	$Camera2D/CanvasLayer/GUI/EntityLabel.set_text(str(mEntities.get_entity_count()) + "/" + str(max_entities) + " entities")

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
	$Camera2D/CanvasLayer/GUI/errorLabel.set("custom_colors/font_color", Color(0.843137, 0.094118, 0.094118))
	$Camera2D/CanvasLayer/GUI/errorLabel.set_text(error)
	$Camera2D/CanvasLayer/GUI/errorLabel.show()
	error_timer.start()

func display_info(info:String):
	$Camera2D/CanvasLayer/GUI/errorLabel.set("custom_colors/font_color", Color(0.176471, 0.498039, 0.87451))
	$Camera2D/CanvasLayer/GUI/errorLabel.set_text(info)
	$Camera2D/CanvasLayer/GUI/errorLabel.show()
	error_timer.start()

func _on_saveButton_pressed():
	if is_map_savable():
		MapSaver.create_save_folder(map_name)
		MapSaver.save_map(mTiles.get_map_size(), tileset_tile_size, map_name, tile_set_p, MapSaver.tile_map_to_array(mTiles.get_map_size(), mTiles.get_tile_map()))
		MapSaver.save_entities(mEntities.get_entities(), map_name)
		MapSaver.save_script(mScriptState.get_script_states(), map_name)
		display_info("Your map has been saved !")

func is_map_savable() -> bool:
	if len(mScriptState.get_script_states()) == 0:
		display_error("Can't save map without at least one script state")
		return false
	if len(mEntities.get_entities()) > max_entities:
		display_error("Maps can only contain " + str(max_entities) + " entities")
		return false
	if !map_has_spawn():
		display_error("Map need a spawn point entity to be saved")
		return false
	return true

func map_has_spawn() -> bool: ## To update with new modules
	var entities = mEntities.get_entities()
	for entity in entities:
		if entity["path"] == "res://mocraAdventure/map/entities/spawn_point/entity.tscn":
			return true
	return false

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
	print("adding script state")
	$script_editor.visible = false
	mTiles.get_tile_map().visible = true
	$Camera2D.current = true
	tile_selector.visible = false
	entity_selector.visible = false
	collisionNode.visible = true
	selected_type = "script"


func _on_gameScriptButton_pressed():
	edition = false
	$script_editor.visible = true
	$script_editor/scriptEditorCamera.current = true
	$Camera2D/CanvasLayer/GUI.set_visible(false)
	tile_selector.visible = false
	entity_selector.visible = false
	mTiles.get_tile_map().visible = false
	collisionNode.visible = false


func _on_Node2D_remove_script_state(entity_id): ## Need to improve with new modules
	var script_states = mScriptState.get_script_states()
	var script_state_objects = mScriptState.get_script_states_objects()
	for i in range(len(script_state_objects)):
		if script_state_objects[i].get_entity_id() == entity_id:
			script_states.remove(i)
			script_state_objects[i].queue_free()
			script_state_objects.remove(i)
			break

func _on_backButton_pressed():
	$script_editor.visible = false
	mTiles.get_tile_map().visible = true
	$Camera2D.current = true
	tile_selector.visible = true
	entity_selector.visible = true
	collisionNode.visible = true
	selected_type = "tile"
	display_overlay()
	edition = true


func change_script_title(entity_id, text): ## Need to improve with new modules
	var script_states = mScriptState.get_script_states()
	var script_state_objects = mScriptState.get_script_states_objects()
	for i in range(len(script_state_objects)):
		if script_state_objects[i].get_entity_id() == entity_id:
			script_states[i]["title"] = text

func change_script_subtitle(entity_id, text): ## Need to improve with new modules
	var script_states = mScriptState.get_script_states()
	var script_state_objects = mScriptState.get_script_states_objects()
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

func _on_tileAlignCheckBox_toggled(button_pressed):
	auto_tile_align = button_pressed

func _on_entity_placer_timeout():
	entity_placing = true

func _on_Node2D_dialog_entered(state:bool):
	if state:
		_on_mouse_entered()
	else:
		_on_mouse_exited()
	
