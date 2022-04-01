extends Control


var level_nbr = 0
var level_template = load("res://mocraAdventure/level_selector/level_template.tscn")
var arrow_template = load("res://mocraAdventure/level_selector/level_separation.tscn")

func _ready():
	print("adventure_init")



func add_level(Name:String, Difficulty:String, Description:String):
	if level_nbr != 0:
		add_arrow()

	var level_gui = level_template.instance()
	$HBoxContainer.add_child(level_gui)
	level_gui.change_level_infos(Name, Difficulty, Description)
	level_nbr += 1

func add_arrow():
	$HBoxContainer.add_child(arrow_template.instance())
