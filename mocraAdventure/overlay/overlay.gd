extends CanvasLayer

signal remove_blur()

@onready var MA_parameters = load("res://mocraAdventure/MA_parameters/Control.tscn").instantiate()

func _ready():
	$lifeBars/l1.set_type("life")
	set_input_texts()
	MA_parameters.set_lobby_node(get_parent())

func first_objective(title, subhead):
	$Control.first_objective(title,subhead)

func next_objective(title, subhead):
	$Control.next_objective(title,subhead)

func set_offensive_progress_value(value):
	$offensiveProgress.set_progress_value(value)

func set_offensive_progress_max_value(value):
	$offensiveProgress.set_progress_max(value)

func get_player_tags():
	return [$Control2/Control, $Control2/Control2, $Control2/Control3]

func use_object(object_id):
	match object_id:
		"object1":
			$objects/o1.launch()
		"object2":
			$objects/o2.launch()
		"object3":
			$objects/o3.launch()

func set_objects_icons(icons_paths:Array):
	$objects/o1.set_icon(icons_paths[0])
	$objects/o2.set_icon(icons_paths[1])
	$objects/o3.set_icon(icons_paths[2])

func set_input_texts():
	var inputs = InputMap
	var actions = inputs.get_actions()
	for i in range(len(actions)):
#		print(actions[i])
		var first_input = InputMap.action_get_events(actions[i])[0].as_text().split(" ")[0]
		if actions[i] == "object1":
			$objects/o1.set_input_text(first_input)
		elif actions[i] == "object2":
			$objects/o2.set_input_text(first_input)
		elif actions[i] == "object3":
			$objects/o3.set_input_text(first_input)

func _on_optionsButton_pressed():
	get_node(".").add_child(load("res://mocraClassic/parameters/Control.tscn").instantiate())
	get_node(".").add_child(MA_parameters)
	$blur.visible = true


func _on_CanvasLayer_remove_blur():
	get_node(".").remove_child(MA_parameters)
	$blur.visible = false
