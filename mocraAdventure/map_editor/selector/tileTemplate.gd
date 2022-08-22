extends Control

var tile_number
var selected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func toggle_selected():
	if selected:
		$backgroundTexture.set_texture(load("res://images/default2.png"))
		selected = false
	else:
		$backgroundTexture.set_texture(load("res://images/default1.png"))
		selected = true

func set_tile_texture(texture_path:String):
	$tileTexture.set_texture(load(texture_path))

func set_tile_name(tile_name:String):
	$tileNameLabel.set_text(tile_name)

func set_tile_number(new_tile_number):
	tile_number = new_tile_number

func get_tile_number():
	return tile_number


func _on_Control_gui_input(event):
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
#			toggle_selected()
			get_parent().get_parent().get_parent().emit_signal("tile_selected", tile_number)
