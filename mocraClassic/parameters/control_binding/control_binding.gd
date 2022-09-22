extends Control


var template = load("res://mocraClassic/parameters/control_binding/input_changer.tscn")

var alterable_inputs = ["editor_zoom_-", "editor_zoom_+", "offensive", "ui_left", "ui_right"]

var type = {"mouse":"InputEventMouseButton ", "joystick":"InputEventJoypadButton "}

signal alter_input(input_name, event)
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("alter_input", self, "_on_alter_input")
	var inputs = InputMap
	var actions = inputs.get_actions()
	for i in range(len(actions)):
		if actions[i] in alterable_inputs:
			var events_text
			var events = InputMap.get_action_list(actions[i])
			var instance = template.instance()
			instance.set_name(str(actions[i]))
			instance.set_event_name(actions[i])
			instance.set_node($".")
			for j in range(len(events)):
				events_text = events[j].as_text()
				instance.set_input(events_text, events[j])
			$ScrollContainer/VBoxContainer.add_child(instance)

# ADD INPUT TYPE KEYBOARD/MOUSE/JOYSTICK
func _on_alter_input(input_name, event):
	var events = InputMap.get_action_list(input_name)
	var to_clear = null
	for i in range(len(events)):
		if events[i] is InputEventKey and event is InputEventKey:
			to_clear = events[i]
		if events[i] is InputEventJoypadButton and event is InputEventJoypadButton:
			to_clear = events[i]
		if events[i] is InputEventMouseButton and event is InputEventMouseButton:
			to_clear = events[i]
	if to_clear != null:
		InputMap.action_erase_event(input_name, to_clear)
	InputMap.action_add_event(input_name, event)


func _on_quitButton_pressed():
	self.queue_free()
