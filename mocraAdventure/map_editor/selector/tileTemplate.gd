extends Control

var tile_number
var selected = false
var type = "tile"
var size
var node 
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

func set_tile_texture_scale(texture_path:String, scale:float):
	var texture = load(texture_path)
	$tileTexture.set_texture(texture)
	$tileTexture.set_scale(Vector2(0.25,0.25))

func set_signal_node(signal_node):
	node = signal_node

func set_entity_type():
	type = "entity"

func set_tile_name(tile_name:String):
	$tileNameLabel.set_text(tile_name)

func set_tile_number(new_tile_number):
	tile_number = new_tile_number

func get_tile_number():
	return tile_number

func get_entity_size():
	if type == "entity":
		return size

func set_entity_size(new_size:Array):
	if type == "entity":
		size =  new_size

func _on_Control_gui_input(event):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
#			toggle_selected()
			if type == "entity":
				node.emit_signal("entity_selected", tile_number)
			else:
				get_parent().get_parent().get_parent().emit_signal("tile_selected", tile_number)
