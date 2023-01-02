extends Control


# Declare member variables here. Examples:
# var a = 2
var dialog_load_path

signal close_dialog(data_array)
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("close_dialog", self, "_on_close_dialog")
	pass # Replace with function body.

func set_entity_label(label:String):
	$entityName.set_text(label)

func set_mode(mode:String):
	var button_label
	match mode:
		"warp":
			button_label= "ADD WARP"
			dialog_load_path = "res://mocraAdventure/map_editor/dialog/warp_dialog.tscn"
		"life":
			button_label = "EDIT LIFE"
			dialog_load_path = "res://"
		_:
			button_label = "None"
			dialog_load_path = null
	$Button.set_text(button_label)

func _on_Button_pressed():
	print("clicked")
	if dialog_load_path != null:
		$".".add_child(load(dialog_load_path).instance())

func _on_close_dialog(data_array:Array):
	if len(data_array) == 1 && data_array[0] == null:
		print("Info: dialog closed without args")
		return
	print("dialog array : ", data_array)


func _on_Control_mouse_entered():
	print("mouse entered")
	get_parent().emit_signal("dialog_entered", true)

func _on_Control_mouse_exited():
	get_parent().emit_signal("dialog_entered", false)
