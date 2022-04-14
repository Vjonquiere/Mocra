extends Control

var levels = "res://mocraAdventure/level_selector/level_list.json"
var levels2 = "user://level_list.txt"
var c = "sdsdgauivqod"
var adventure = load("res://mocraAdventure/level_selector/adventure_template.tscn")
var selected_level

var adventures = {}

signal selection_changed(level_id)

func _ready():
	var t = get_from_json(levels)
	generate_adventures(t)

func get_from_json(filepath:String) -> Dictionary:
	var file = File.new()
	file.open(filepath, File.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data

func generate_adventures(parsed_json):
	for i in range(len(parsed_json["Adventures_list"])):
		adventures[i] = adventure.instance()
		adventures[i].set_name(parsed_json["Adventures_list"][i]["name"])
		generate_levels(parsed_json["Adventures_list"][i]["levels"], adventures[i])
		get_node("AdventuresContainer").add_child(adventures[i])

func generate_levels(adventure_infos:Array, adventure_object):
	for i in range(len(adventure_infos)):
		adventure_object.add_level(adventure_infos[i]["name"], adventure_infos[i]["difficulty"], adventure_infos[i]["description"], adventure_infos[i]["id"])

func _on_Control_selection_changed(level_id):
	for i in range(len(adventures)):
		if selected_level in adventures[i].get_levels_ids():
			adventures[i].set_level_unselected(selected_level)
	selected_level = level_id


func _on_SelectButton_pressed():
	if selected_level != null:
		get_node("../../").emit_signal("level_changed", selected_level)
		self.queue_free()
