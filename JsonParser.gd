extends Node

####### JSON PARSER #######

func get_data_from_json(filepath:String) -> Dictionary:
	var file = FileAccess.open(filepath, FileAccess.READ)
	var text = file.get_as_text()
	var test_json_conv = JSON.new()
	test_json_conv.parse(text)
	var data = test_json_conv.get_data()
	file.close()
	return data
