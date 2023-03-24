extends Control


var template = load("res://mocraClassic/parameters/control_binding/input_changer.tscn")



var type = {"mouse":"InputEventMouseButton ", "joystick":"InputEventJoypadButton "}

signal alter_input(input_name, event)
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("alter_input",Callable(self,"_on_alter_input"))
	var inputs = InputMap
	var actions = inputs.get_actions()
	for i in range(len(actions)):
		if actions[i] in Global.alterable_inputs:
			var events_text
			var events = InputMap.action_get_events(actions[i])
			var instance = template.instantiate()
			instance.set_name(str(actions[i]))
			instance.set_event_name(actions[i])
			instance.set_node($".")
			for j in range(len(events)):
				events_text = events[j].as_text()
				instance.set_input(events_text, events[j])
			$ScrollContainer/VBoxContainer.add_child(instance)

func save_inputs():
	var children = $ScrollContainer/VBoxContainer.get_children()
	var actions = []
	for i in range(len(children)):
		actions.append({"input_name": children[i].get_name(), "keys": children[i].get_input()})
	Options.save_inputs(actions, "user://options.json")

func _on_quitButton_pressed():
	save_inputs()
	Options.load_inputs("user://options.json")
	self.queue_free()
