extends Node

####### JSON PARSER #######

func get_data_from_json(filepath:String) -> Dictionary:
	var file = File.new()
	file.open(filepath, File.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data
