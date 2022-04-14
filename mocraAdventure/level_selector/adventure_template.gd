extends Control


var level_nbr = 0
var level_template = load("res://mocraAdventure/level_selector/level_template.tscn")
var arrow_template = load("res://mocraAdventure/level_selector/level_separation.tscn")

var visibility = true

var level_array = []
var level_dic = {}
var arrow_array = []

signal selection_changed 

func _ready():
	print("adventure_init")

func add_level(Name:String, Difficulty:String, Description:String, ID:String):
	if level_nbr != 0:
		add_arrow()

	var level_gui = level_template.instance()
	level_array.append(level_gui)
	level_dic[ID] = level_gui
	$HBoxContainer.add_child(level_gui)
	level_gui.change_level_infos(Name, Difficulty, Description, ID)
	level_nbr += 1

func get_levels_ids():
	var id_array = []
	for i in range(len(level_array)):
		id_array.append(level_array[i].get_id())
	return id_array

func set_level_unselected(level_id):
	level_dic[level_id].set_unselected()

func set_name(name:String):
	$NameLabel.set_text(name)

func add_arrow():
	var arrow = arrow_template.instance()
	arrow_array.append(arrow)
	$HBoxContainer.add_child(arrow)

func toggle_level_visibility():

	for i in range(len(level_array)):
		## TOGGLE levels
		if visibility:
			level_array[i].hide()
		else:
			level_array[i].show()
		## TOGGLE arrows
		if len(arrow_array) > i:
			if visibility:
				arrow_array[i].hide()
			else:
				arrow_array[i].show()
	visibility = !visibility


func _on_AdventureSeparator_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		toggle_level_visibility()


func _on_Node2D_selection_changed():
	print("on dort")
