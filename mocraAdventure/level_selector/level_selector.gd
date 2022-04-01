extends Control

var levels = "res://mocraAdventure/level_selector/level_list.json"
var selected_level

signal selection_changed 

func _ready():
	var t = get_from_json(levels)
	$Node2D.add_level("test","hard","je sais pas quoi mettre donc voila")
	$Node2D.add_level("test2", "normal", "ca a interet a marcher")
	print("z")

func get_from_json(filepath:String) -> Dictionary:
	var file = File.new()
	file.open(filepath, File.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data

func extract_data(parsed_json):
	var adventure_number = len(parsed_json["Adventures_list"])

func _on_Control_selection_changed():
	pass
