 extends Control

signal advanced_selection(card_id, card_name, card_number)

var card_preload
var card_type_selected
var card_array
var card_usage
var advanced_selection = true

func _ready():
	print("selector created")

func init_selection(card_type:String, usage:String):
	match card_type:
		"object":
			card_preload = load("res://mocraAdventure/object_cards/card.tscn")
		"character":
			card_preload = load("res://mocraAdventure/character_cards/card.tscn")
		"ground":
			card_preload = load("res://mocraAdventure/ground_cards/card.tscn")
		"all":
			card_preload = load("res://mocraAdventure/classic_cards/card.tscn")
			advanced_selection = false
	card_usage = usage
	card_type_selected = card_type

func display_collection():
	var uid = Networking.send_data_through_queue("get_collection_only_ids", "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	var ids = packet[0]
	ids.remove(len(ids)-1) ## DO NOT REMOVE
	construct_cards(ids)

func search_cards() -> Array:
	var request = "get_cards_with_type/" + card_type_selected
	var uid = Networking.send_data_through_queue(request, "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	var rcv = packet[0]
	return rcv

func get_card_infos_mocra_classic(id:String) -> Array:
	var request = "get_card_infos/" + id 
	var uid = Networking.send_data_through_queue(request, "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	var rcv = packet[0]
	return rcv

func get_card_infos(id:String) -> Array:
	var request = "get_MA_card_infos/" + id + "/" + card_type_selected
	var uid = Networking.send_data_through_queue(request, "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	var rcv = packet[0]
	return rcv


func construct_cards(card_array:Array) -> void:
	for i in range(len(card_array)):
		var card_instance = card_preload.instantiate()
		$ScrollContainer/HBoxContainer.add_child(card_instance)
		card_instance.set_position(Vector2(0,0))
		
		var card_infos
		if advanced_selection:
			card_infos = await get_card_infos(card_array[i]).completed
			card_instance.change_avatar(card_infos[0])
			card_infos = await get_card_infos(card_array[i]).completed
			create_and_link_button(int(card_array[i]), card_infos[0], card_instance)
		else:
			card_infos = await get_card_infos_mocra_classic(card_array[i]).completed
			create_and_link_button(int(card_array[i]), card_infos[3], card_instance)

		match card_type_selected:
			"object":
				card_instance.change_informations(card_infos[2], card_infos[3])
			"character":
				card_instance.change_informations(card_infos[2], card_infos[3], card_infos[4], card_infos[5], card_infos[6], await get_number_of_owned_cards(card_array[i]).completed)
			"ground":
				card_instance.change_informations(card_infos[0], card_infos[2])
			"all":
				card_instance._change_informations(card_infos[1], card_infos[2], card_infos[3], card_infos[4], card_infos[5])
	
func get_number_of_owned_cards(card_id):
	var request = "get_amount_of_owned_card/" + str(card_id)
	var uid = Networking.send_data_through_queue(request, "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	var rcv = packet[0]
	return rcv[0]

func create_and_link_button(card_id:int, card_name:String, card_node):
	var add_button = Button.new()
	card_node.add_child(add_button)
	add_button.set_text("Select")
	add_button.set_position(Vector2(80,400))
	add_button.set_size(Vector2(300,125))
	add_button.set_scale(Vector2(0.5,0.5))
	add_button.connect("pressed",Callable(self,"select_card").bind(card_id, card_name, 1))

	if advanced_selection:
		add_button.set_position(Vector2(50,350))
		var advanced_add_button = Button.new()
		add_button.add_child(advanced_add_button)
		advanced_add_button.set_text("Advanced selection")
		advanced_add_button.set_position(Vector2(0,40))
		advanced_add_button.connect("pressed",Callable(self,"advanced_card_selection").bind(card_node, card_name, card_id))

func advanced_card_selection(card_node, card_name:String, card_id:int):
	var tools = load("res://mocraAdventure/card_number_selector/card_number_selector.tscn").instantiate()
	get_node(".").add_child(tools)
	tools.set_card_id(card_id)
	tools.set_card_name(card_name)
	tools.set_scale(Vector2(0.8,0.8))
	tools.set_position(Vector2(0,300))

func select_card(card_id:int, card_name:String, amount:int):
	get_parent().emit_signal("selection_done", card_usage, card_id, card_name, amount)
	queue_free()

func _on_closebutton_pressed():
	print("selector closed")
	get_parent().emit_signal("selection_done", null, null, null, null)
	queue_free()

func _on_Control_advanced_selection(card_id, card_name, card_number):
	select_card(card_id, card_name, card_number)
