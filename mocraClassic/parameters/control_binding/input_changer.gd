extends Control

var joystick_match = {"n": ["B","A","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None"], "x": ["A","B","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None"], "p": ["X","O","None","None","None","None","None","None","None","None","None","None","None","None","None","None","None"]}
var mouse_match = ["Left", "Right", "Middle", "Wheel U", "Wheel D", "Wheel L", "Wheel R", "Xbutton1", "Xbutton2"]

var set_event = false
var event_type
var event_name
var node
var bind_input = [null, null, null]

func _ready():
	pass # Replace with function body.

func set_event_name(name:String):
	event_name = name

func set_name(name:String):
	$nameLabel.set_text(name)

func set_node(master_node):
	node = master_node
 
func get_name():
	return event_name

func get_input():
	return bind_input

func set_input(input:String, event):
	if event is InputEventKey:
		$keyboardchangeButton.set_text(remove_physical(input))
		bind_input[0] = event
	if event is InputEventMouseButton:
		$mousechangeButton.set_text(mouse_match[event.get_button_index() - 1])
		bind_input[1] = event
	if event is InputEventJoypadButton:
		$joystickchangeButton.set_text(joystick_match["x"][event.get_button_index()])
		bind_input[2] = event
#	$GridContainer/keyboardchangeButton.set_size(Vector2(100 + 100*len($GridContainer/keyboardchangeButton.get_text()), 100))

func remove_physical(string:String) -> String:
	return string.split(" ")[0]

func _input(event):
	if set_event and "Escape" == event.as_text():
		set_event = false
		$Label.hide()
	elif set_event and event is InputEventKey and event_type == "keyboard":
		set_input(event.as_text(), event)
		set_event = false
		$Label.hide()
	elif set_event and event is InputEventMouseButton and event_type == "mouse":
		set_input(event.as_text(), event)
		set_event = false
		$Label.hide()
	elif set_event and event is InputEventJoypadButton and event_type == "joypadbutton":
		set_input(event.as_text(), event)
		set_event = false
		$Label.hide()

func _on_changeButton_pressed():
	set_event = true
	event_type = "keyboard"
	$Label.show()


func _on_mousechangeButton_pressed():
	set_event = true
	event_type = "mouse"
	$Label.show()


func _on_joystickchangeButton_pressed():
	set_event = true
	event_type = "joypadbutton"
	$Label.show()
