extends Control

var colors = {"easy":Color("#499236"), "normal":Color("#dba307"), "hard":Color("#c63724")}

var textures = {"0": "res://mocraAdventure/level_selector/levels_textures/default_empty.png", "1": "res://mocraAdventure/level_selector/levels_textures/default.png"}

var selected = false
var level_id

func _ready():
	print('level_init')
	#change_level_infos("le premier", 'normal', "aucunesqfgyfazueyqgsvc_yaeqf<ov_yilzafugvqiyhk idee mdr")
	#center_object("LevelLabel")

func get_level_stats():
	print("level_id = ", self.get_id())
	var data = "get_level_stats/" + str(self.get_id())
	Networking.con.put_data(data.to_utf8())
	var res = Networking.waiting_for_server()
	if res[0] == "nothing":
		return null
	else:
		return res

func update_level_stats():
	var stats = get_level_stats()
	print("level stats: ", stats)
	if stats == null:
		return
	$star1Texture.set_texture(load(textures[stats[3]]))
	$star2Texture.set_texture(load(textures[stats[2]]))
	$star3Texture.set_texture(load(textures[stats[4]]))
	

func change_level_infos(Name:String, Difficulty:String, Description:String, ID:String):
	level_id = ID
	$LevelLabel.set_text(Name)
	$DescriptionLabel.set_text(Description)
	$DifficultyLabel.set_text(Difficulty)
	$DifficultyLabel.set("custom_colors/font_color",colors[Difficulty])
	update_level_stats()

func get_id():
	return level_id

func set_unselected():
	$Background.set_texture(load("res://mocraAdventure/level_selector/levels_textures/background.png"))
	selected = false

func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if not selected:
			$Background.set_texture(load("res://mocraAdventure/level_selector/levels_textures/selected_background.png"))
			selected = true
			get_node("../../../../").emit_signal("selection_changed", level_id)
		else:
			$Background.set_texture(load("res://mocraAdventure/level_selector/levels_textures/background.png"))
			selected = false
			get_node("../../../../").emit_signal("selection_changed", level_id)

func center_object(node):
	var size = get_node(node).get_size()
	var parent_size = get_node(node).get_parent().get_size()
	print("parent: ", parent_size[0], " child:", size[0])
	print("center = ", parent_size[0]-((size[0]*0.15)/2))
	#parent_size[0]-size[0]
	get_node(node).set_position(Vector2(parent_size[0]-((size[0]*0.15)),0))
