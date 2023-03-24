extends Control

var options = JsonParser.get_data_from_json("user://options.json")
var visual_control_pressed

func _ready():
	$VBoxContainer/musicContainer/musicVar.set_text(str(options["music_vol"]) + "%")
	$VBoxContainer/soundContainer/soundVar.set_text(str(options["sound_vol"]) + "%")
	$VBoxContainer/musicContainer/musicSlider.set_value(options["music_vol"])
	$VBoxContainer/soundContainer/soundSlider.set_value(options["sound_vol"])
	visual_control_pressed = options["visual_control"]
	$VBoxContainer/visualContainer/CheckBox.button_pressed = visual_control_pressed




func _on_musicSlider_value_changed(value):
	$VBoxContainer/musicContainer/musicVar.set_text(str(value) + "%")


func _on_soundSlider_value_changed(value):
	$VBoxContainer/soundContainer/soundVar.set_text(str(value) + "%")


func _on_saveButton_pressed():
	var json = JsonParser.get_data_from_json("user://options.json")
	json["music_vol"] = $VBoxContainer/musicContainer/musicSlider.get_value()
	json["sound_vol"] = $VBoxContainer/soundContainer/soundSlider.get_value()
	print("visual control: ", visual_control_pressed)
	json["visual_control"] = visual_control_pressed
	Options.save_options("user://options.json", Options.options_to_string(json))
	Options.load_options("user://options.json")
	get_parent().emit_signal("remove_blur")
	self.queue_free()


func _on_quitButton_pressed():
	$ConfirmationDialog.popup()


func _on_ConfirmationDialog_confirmed():
	get_parent().emit_signal("remove_blur")
	self.queue_free()


func _on_controlsbindingButton_pressed():
	var binding = load("res://mocraClassic/parameters/control_binding/control_binding.tscn").instantiate()
	$".".add_child(binding)

func _on_CheckBox_toggled(button_pressed):
	visual_control_pressed = button_pressed
