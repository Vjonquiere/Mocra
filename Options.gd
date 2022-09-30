extends Control

var single_parameters_options = ["music_vol", "sound_vol", "visual_control"]


func load_inputs(option_path:String):
	var options = JsonParser.get_data_from_json(option_path)
	for i in range(len(options["input_names"])):
		InputMap.action_erase_events(options["input_names"][i])
		for j in range(len(options["inputs"][options["input_names"][i]])):
			var event
			match options["inputs"][options["input_names"][i]][j]["keytype"]:
				"InputEventKey":
					event = InputEventKey.new()
					event.set_physical_scancode(int(options["inputs"][options["input_names"][i]][j]["event_scan_code"]))
				"InputEventMouseButton":
					event = InputEventMouseButton.new()
					event.set_button_index(int(options["inputs"][options["input_names"][i]][j]["event_scan_code"]))
				"InputEventJoystickButton":
					event = InputEventJoypadButton.new()
					event.set_button_index(int(options["inputs"][options["input_names"][i]][j]["event_scan_code"]))
			InputMap.action_add_event(options["input_names"][i], event)

func load_options(option_path:String):
	var options = JsonParser.get_data_from_json(option_path)
	for i in range(len(single_parameters_options)):
		Global.options[single_parameters_options[i]] = options[single_parameters_options[i]]

func save_inputs(input_array:Array, option_path:String):
	var json = JsonParser.get_data_from_json(option_path)
	if json.has("inputs"):
		print("Inputs had already been altered")
	var input_names = []
	var inputs = {}
	for i in range(len(input_array)):
		var events = []
		for j in range(len(input_array[i]["keys"])):
			if input_array[i]["keys"][j] != null:
				var event_string = get_event_to_string(input_array[i]["keys"][j])
				events.append({"keytype": event_string[0], "event_scan_code": event_string[1]})
		inputs[input_array[i]["input_name"]] = events
		input_names.append(input_array[i]["input_name"])
	json["inputs"] = inputs
	json["input_names"] = input_names
	save_options(option_path, options_to_string(json))

func get_event_to_string(event):
	if event is InputEventKey:
		return ["InputEventKey", str(event.get_physical_scancode())]
	elif event is InputEventMouseButton:
		return ["InputEventMouseButton", str(event.get_button_index())]
	elif event is InputEventJoypadButton:
		return ["InputEventJoypadButton", str(event.get_button_index())]

func options_to_string(options:Dictionary):
	var content = "{"
	for i in range(len(single_parameters_options)):
		if options.has(single_parameters_options[i]):
			content += '"' + single_parameters_options[i] + '" : ' + str(options[single_parameters_options[i]]).to_lower() + ",\n"
	content += '"input_names": ['
	for i in range(len(options["input_names"])):
		content += '"' + options["input_names"][i] + '"'
		if i != len(options["input_names"]) -1:
			content += ','
	content += '],\n"inputs":{\n'
	for i in range(len(options["input_names"])):
		content += '"' + options["input_names"][i] + '": ['
		for j in range(len(options["inputs"][options["input_names"][i]])):
			var event = options["inputs"][options["input_names"][i]]
			content += '{"keytype": "' + event[j]["keytype"] + '", "event_scan_code": "' + event[j]["event_scan_code"] + '"}'
			if j != len(options["inputs"][options["input_names"][i]]) -1:
				content += ","
		if i != len(options["input_names"]) -1:
			content += "],\n"
		else:
			content += "]\n"
	content += "}\n}"
	return content

func save_options(path:String, content:String):
	var file = File.new()
	file.open(path, file.WRITE)
	file.store_string(content)
	file.close()
