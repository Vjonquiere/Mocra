extends Control

const default_size = [10,10]
var size = default_size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_exitButton_pressed():
	get_parent().emit_signal("close_dialog", [null])
	self.queue_free()


func _on_createWarpButton_pressed():
	get_parent().emit_signal("close_dialog", size)


func _on_xLineEdit_text_changed(new_text):
	if new_text.is_valid_integer():
		size[0] = int(new_text)

func _on_yLineEdit2_text_changed(new_text):
	if new_text.is_valid_integer():
		size[0] = int(new_text)
