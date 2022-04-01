extends Control

var colors = {"easy":Color("#499236"), "normal":Color("#dba307"), "hard":Color("#c63724")}

func _ready():
	print('level_init')
	#change_level_infos("le premier", 'normal', "aucunesqfgyfazueyqgsvc_yaeqf<ov_yilzafugvqiyhk idee mdr")
	center_object("LevelLabel")

func change_level_infos(Name:String, Difficulty:String, Description:String):
	$LevelLabel.set_text(Name)
	$DescriptionLabel.set_text(Description)
	$DifficultyLabel.set_text(Difficulty)
	$DifficultyLabel.set("custom_colors/font_color",colors[Difficulty])


func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		print("test")


func center_object(node):
	var size = get_node(node).get_size()
	var parent_size = get_node(node).get_parent().get_size()
	print(parent_size[0])
	#parent_size[0]-size[0]
	get_node(node).set_position(Vector2(40,0))
