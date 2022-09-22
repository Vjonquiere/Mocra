extends Control

var options = JsonParser.get_data_from_json("user://options.json")

func _ready():
	$VBoxContainer/musicContainer/musicVar.set_text(str(options["music_vol"]) + "%")
	$VBoxContainer/soundContainer/soundVar.set_text(str(options["sound_vol"]) + "%")
	$VBoxContainer/musicContainer/musicSlider.set_value(options["music_vol"])
	$VBoxContainer/soundContainer/soundSlider.set_value(options["sound_vol"])




func _on_musicSlider_value_changed(value):
	$VBoxContainer/musicContainer/musicVar.set_text(str(value) + "%")


func _on_soundSlider_value_changed(value):
	$VBoxContainer/soundContainer/soundVar.set_text(str(value) + "%")


func _on_saveButton_pressed():
	var json = '{\n"music_vol": ' + str($VBoxContainer/musicContainer/musicSlider.get_value()) + ',\n"sound_vol": '  + str($VBoxContainer/soundContainer/soundSlider.get_value()) + '\n}'
	var file = File.new()
	file.open("user://options.json", File.WRITE)
	file.store_string(json)
	file.close()
	get_parent().emit_signal("remove_blur")
	self.queue_free()


func _on_quitButton_pressed():
	$ConfirmationDialog.popup()


func _on_ConfirmationDialog_confirmed():
	get_parent().emit_signal("remove_blur")
	self.queue_free()


func _on_controlsbindingButton_pressed():
	var binding = load("res://mocraClassic/parameters/control_binding/control_binding.tscn").instance()
	$".".add_child(binding)
