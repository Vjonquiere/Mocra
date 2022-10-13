extends Control

var width = (int(ProjectSettings.get_setting("display/window/size/width"))/7)
var height = (int(ProjectSettings.get_setting("display/window/size/height"))/15)


# Called when the node enters the scene tree for the first time.
func _ready():
	Networking.con.put_data("get_collection".to_utf8())
	var received_data = yield(Networking.waiting_for_server("|"), "completed")
	print("collection data : ", received_data)
	received_data.remove(0)
	Global.collection_card = preload("res://scenes/Collection_card.tscn")
	Global.current_page = 0

	Global.page_number = len(received_data)/18
	var last_page_card_number = len(received_data)%18
	Global.page_array = {}

	for pages in range(Global.page_number):
		Global.page_array[pages] = []
		for cards in range(18):
			Global.page_array[pages].append(create_collection_card(received_data[0], cards))
			received_data.remove(0)

	if last_page_card_number != 0:
		Global.page_number += 1
		Global.page_array[len(Global.page_array)] = []
		for cards in range(last_page_card_number):
			Global.page_array[len(Global.page_array)-1].append(create_collection_card(received_data[0], cards))
			received_data.remove(0)

	display_page_cards(0,Global.page_array)



func create_collection_card(card_str, card_page_index):
	var instance  = Global.collection_card.instance()
	$".".add_child(instance)
	instance.scale.x = 0.8
	instance.scale.y = 0.8
	if card_page_index == 0:
		instance.position.x = width
		instance.position.y = height * 4
	elif card_page_index > 0 and card_page_index <=5:
		instance.position.x = width * (card_page_index + 1)
		instance.position.y = height * 4
	elif card_page_index >= 6 and card_page_index <=11:
		instance.position.x = width * (card_page_index - 5)
		instance.position.y = height * 8
	else:
		instance.position.x = width * (card_page_index - 11)
		instance.position.y = height * 12
	var card_infos = card_str.split("/")

	instance._change_informations(card_infos[2],card_infos[3],card_infos[4],card_infos[8])

	return instance

func display_page_cards(page, page_array):
	for cards in range(len(page_array[page])):
		page_array[page][cards]._display_card()


func hide_page_cards(page, page_array):
	for cards in range(len(page_array[page])):
		page_array[page][cards]._hide_card()


func _on_NextButton_pressed():
	if Global.current_page < Global.page_number -1:
		hide_page_cards(Global.current_page, Global.page_array)
		Global.current_page += 1
		display_page_cards(Global.current_page, Global.page_array)
		$PreviousButton.visible = true
		if Global.current_page == Global.page_number -1:
			$NextButton.visible = false
	else:
		print("derniere page")

func _on_PreviousButton_pressed():
	if Global.current_page > 0:
		hide_page_cards(Global.current_page, Global.page_array)
		Global.current_page -= 1
		display_page_cards(Global.current_page, Global.page_array)
		$NextButton.visible = true
		if Global.current_page == 0:
			$PreviousButton.visible = false
	else:
		print("premiere page")


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
