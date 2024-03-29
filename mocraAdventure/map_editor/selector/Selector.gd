extends Control


var tileTemplate = load("res://mocraAdventure/map_editor/selector/tileTemplate.tscn")
var tiles = []
var selected_tile = null

signal tile_selected(tile_number)
# Called when the node enters the scene tree for the first time.
func _ready():
#	init_selector("res://mocraAdventure/map/tilesets/1/tileset.tres")
	pass

func get_tileset_infos_path(tileset_path:String) -> String:
	var split = tileset_path.split("/")
	var path = ""
	for i in range(len(split)-1):
		path += split[i] + "/"
	path += "infos.json"
	return path


func init_selector(tileset_path:String):
	var tileset_infos = JsonParser.get_data_from_json(get_tileset_infos_path(tileset_path))
	for i in range(tileset_infos["tile_number"]):
		var tile = tileTemplate.instance()
		tile.set_tile_texture(tileset_infos[str(i)]["texture_path"])
		tile.set_tile_name(tileset_infos[str(i)]["name"])
		tile.set_tile_number(i+1)
		tiles.append(tile)
		$ScrollContainer/HBoxContainer.add_child(tile)


func _on_Selector_tile_selected(tile_number):
	get_parent().get_parent().get_parent().emit_signal("tile_selected", tile_number)
	if tile_number != selected_tile:
		for i in range(len(tiles)):
			if tiles[i].get_tile_number() == selected_tile and selected_tile != null:
				tiles[i].toggle_selected()
		selected_tile = tile_number
		for i in range(len(tiles)):
			if tiles[i].get_tile_number() == selected_tile:
				tiles[i].toggle_selected()

func set_selected_tile(tile_number):
	if tile_number == null:
		for i in range(len(tiles)):
			if tiles[i].get_tile_number() == selected_tile:
				tiles[i].toggle_selected()
	selected_tile = tile_number
