extends Control

var width = (int(ProjectSettings.get_setting("display/window/size/width"))/7)
var height = (int(ProjectSettings.get_setting("display/window/size/height"))/15)


# Called when the node enters the scene tree for the first time.
func _ready():
	Networking.send_data("get_collection")
	var received_data = yield(Networking.waiting_for_server("|"), "completed")
	received_data.remove(0)
	Global.collection_card = preload("res://scenes/Collection_card.tscn")

	for i in range(len(received_data)):
		print(received_data[i])
		create_collection_card(received_data[i])



func create_collection_card(card_str):
	var instance  = Global.collection_card.instance()
	$"ScrollContainer/GridContainer".add_child(instance) 
	instance.set_scale(Vector2(0.8, 0.8))
	var card_infos = card_str.split("/")
	instance._change_informations(card_infos[2],card_infos[3],card_infos[4],card_infos[8])
	instance._display_card()

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
