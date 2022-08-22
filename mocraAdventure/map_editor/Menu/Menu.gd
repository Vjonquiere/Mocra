extends Control


var tile_sets = {"grass":"res://mocraAdventure/map/tilesets/1/tileset.tres", "stone": "res://mocraAdventure/map/tilesets/1/tileset.tres"}

# Called when the node enters the scene tree for the first time.
func _ready():
	$tileSetLabel/tileSetItemList.add_item("grass")
	$tileSetLabel/tileSetItemList.add_item("stone")


func valid_size_values():
	if int($sizeLabel/xSizeLineEdit.get_text()) < 100 and int($sizeLabel/ySizeLineEdit.get_text()) < 100:
		return true
	else:
		return false

func valid_name_value():
	if $NameLabel/NameLineEdit.get_text().length() < 15:
		return true
	else:
		return false

func valid_tile_size_value():
	if int($tileSizeLabel/tileSizeLineEdit.get_text()) < 200:
		return true
	else:
		return false

func valid_tile_set_value():
	if $tileSetLabel/tileSetItemList.is_anything_selected():
		return true
	else:
		return false

func _on_ConfirmButton_pressed():
	if valid_name_value() and valid_size_values() and valid_tile_size_value() and valid_tile_set_value():
		get_parent().emit_signal("init_editor", [int($sizeLabel/xSizeLineEdit.get_text()), int($sizeLabel/ySizeLineEdit.get_text())], int($tileSizeLabel/tileSizeLineEdit.get_text()), $NameLabel/NameLineEdit.get_text(), tile_sets[$tileSetLabel/tileSetItemList.get_item_text($tileSetLabel/tileSetItemList.get_selected_items()[0])])
		self.queue_free()
