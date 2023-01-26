extends Control


var tile_sets = {"grass":"res://mocraAdventure/map/tilesets/1/tileset.tres", "stone": "res://mocraAdventure/map/tilesets/1/tileset.tres"}

# Called when the node enters the scene tree for the first time.
func _ready():
	$createMenu/tileSetLabel/tileSetItemList.add_item("grass")
	#$tileSetLabel/tileSetItemList.add_item("stone")


func valid_size_values():
	if int($createMenu/sizeLabel/xSizeLineEdit.get_text()) < 100 and int($createMenu/sizeLabel/ySizeLineEdit.get_text()) < 100:
		return true
	else:
		return false

func valid_name_value():
	if $createMenu/NameLabel/NameLineEdit.get_text().length() < 15:
		return true
	else:
		return false

func valid_tile_size_value():
	if int($createMenu/tileSizeLabel/tileSizeLineEdit.get_text()) < 200:
		return true
	else:
		return false

func valid_tile_set_value():
	if $createMenu/tileSetLabel/tileSetItemList.is_anything_selected():
		return true
	else:
		return false

func _on_ConfirmButton_pressed():
	if valid_name_value() and valid_size_values() and valid_tile_size_value() and valid_tile_set_value():
		get_parent().emit_signal("init_editor", [int($createMenu/sizeLabel/xSizeLineEdit.get_text()), int($createMenu/sizeLabel/ySizeLineEdit.get_text())], int($createMenu/tileSizeLabel/tileSizeLineEdit.get_text()), $createMenu/NameLabel/NameLineEdit.get_text(), tile_sets[$createMenu/tileSetLabel/tileSetItemList.get_item_text($createMenu/tileSetLabel/tileSetItemList.get_selected_items()[0])])
		self.queue_free()


func _on_loadButton_pressed():
	var path = $loadMenu/pathLabel/pathLineEdit.get_text()
	if "user://" in path:
		var loader = map_loader.new()
		var loaded_map = loader.load_from_path(path)
		var default_args = loader.get_default_args(path)
		if loaded_map["status"] != -1 && default_args["status"] != -1:
			get_parent().emit_signal("init_editor", default_args["size"], default_args["tile_size"], default_args["name"], default_args["tile_set_path"], loaded_map["tiles"], loaded_map["entities"])
			self.queue_free()
