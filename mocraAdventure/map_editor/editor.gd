extends Node2D

var tile_map = TileMap.new()
var tile_set
var tile_set_p
var tileset_tile_size
var edition = false
var selector = load("res://mocraAdventure/map_editor/selector/Selector.tscn").instance()
var tile = []
var size = []
var map_name 

signal tile_selected(tile_number)
signal init_editor(map_size, tile_size, name, tile_set_path)
# Called when the node enters the scene tree for the first time.
func _ready():
	var menu = load("res://mocraAdventure/map_editor/Menu.tscn").instance()
	$".".add_child(menu)

func load_tileset(path:String):
	tile_set = load(path)

func _on_Node2D_init_editor(map_size:Array, tile_size:int, name:String, tile_set_path:String):
	size = map_size
	map_name = name
	tile_set_p = tile_set_path
	tileset_tile_size = tile_size
	selector.init_selector(tile_set_path)
	tile_map.set_tileset(load(tile_set_path))
	tile_map.set_cell_size(Vector2(tile_size,tile_size))
	for i in range(int(map_size[1])):
		for j in range(int(map_size[0])):
			tile_map.set_cell(j,i,0)
	$".".add_child(tile_map)
	$Camera2D/CanvasLayer.add_child(selector)
	selector.set_position(Vector2(210,850))
#	selector.set_z_index(1)
	selector.visible = false
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
#		selector.set_scale(Vector2(selector.get_scale()[0] +0.01, selector.get_scale()[1] +0.01))
	elif input == "zoom_+":
		$Camera2D.set_zoom(Vector2($Camera2D.get_zoom()[0] -0.01 , $Camera2D.get_zoom()[1] -0.01))
#		selector.set_scale(Vector2(selector.get_scale()[0] -0.01, selector.get_scale()[1] -0.01))
	elif input == "translate_up":
		$Camera2D.set_offset(Vector2($Camera2D.get_offset()[0] , $Camera2D.get_offset()[1] -10))
#		selector.set_position(Vector2(selector.get_position()[0], selector.get_position()[1] -10))
	elif input == "translate_down":
		$Camera2D.set_offset(Vector2($Camera2D.get_offset()[0] , $Camera2D.get_offset()[1] +10))
#		selector.set_position(Vector2(selector.get_position()[0], selector.get_position()[1] +10))
	elif input == "translate_left":
		$Camera2D.set_offset(Vector2($Camera2D.get_offset()[0] -10 , $Camera2D.get_offset()[1]))
#		selector.set_position(Vector2(selector.get_position()[0] -10, selector.get_position()[1]))
	elif input == "translate_right":
		$Camera2D.set_offset(Vector2($Camera2D.get_offset()[0] +10 , $Camera2D.get_offset()[1]))
#		selector.set_position(Vector2(selector.get_position()[0] +10, selector.get_position()[1]))
	elif input == "get_pos" and edition:
		print("EDITION : ", edition)
#		edition = false
		tile = [int(tile_map.get_local_mouse_position()[0]/tileset_tile_size), int(tile_map.get_local_mouse_position()[1]/tileset_tile_size)]
		$SelectorTexture.set_position(Vector2(tile[0]*tileset_tile_size +25, tile[1]*tileset_tile_size +25))
		$SelectorTexture.visible = true
		selector.visible = true
		print("MOUSE POSITION => ", tile_map.get_local_mouse_position())
		print("TILE => ", tile)


func _on_Node2D_tile_selected(tile_number):
	print(tile_number)
	if tile[0] < size[0] and tile[1] < size[1]:
		tile_map.set_cell(tile[0], tile[1], tile_number)
#		edition = true



func _on_saveButton_pressed():
	MapSaver.save_map(size, tileset_tile_size, map_name, tile_set_p, MapSaver.tile_map_to_array(size, tile_map))
