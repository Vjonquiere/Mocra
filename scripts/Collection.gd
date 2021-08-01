extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Networking.con.put_data("get_collection".to_utf8())
	var received_data = Networking.waiting_for_cards()

	received_data.remove(0)
	print(received_data)
	Global.card = preload("res://scenes/Collection_card.tscn")
	var page_number = len(received_data)/6
	var last_page_card_number = len(received_data)%6
	var page_array = {}

	for pages in range(page_number):
		page_array[pages] =  []
		for cards in range(6):
			page_array[pages].append(create_collection_card(received_data[0], cards))
			received_data.remove(0)


func create_collection_card(card_str, card_page_index):
	#serie, name, scarcity, owned_number
	var instance  = Global.card.instance()
	$".".add_child(instance)
	var card_infos = card_str.split("/")
	instance._change_informations("test","lol","Common","top drole")
	
	return instance