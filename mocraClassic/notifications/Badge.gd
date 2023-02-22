extends Control

var number_label = "NA"

func setup(number:String):
	number_label = number
	_ready()
	return self

func _ready():
	$numberLabel.set_text(number_label)

func show():
	if number_label != "0":
		$AnimationPlayer.play("display")
	else:
		$".".hide()

func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if get_parent().has_method("show_notifications"):
			get_parent().show_notifications()
