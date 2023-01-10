extends Control

var counter = 1
var max_cards = 99
var min_cards = 1
var selected_card_id
var selected_card_name
var owned_card_number 

func _ready():
	$CardNumber.set_text(str(counter))
	print("Card Selection tool initied")

func set_card_id(card_id:int):
	selected_card_id = card_id
	owned_card_number = get_number_of_owned_cards(card_id)

func set_card_name(card_name:String):
	selected_card_name = card_name

func get_number_of_owned_cards(card_id):
	var request = "get_amount_of_owned_card/" + str(card_id)
	var uid = Networking.send_data_through_queue(request, "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = yield(Networking, "packet_found")
	var rcv = packet[0]
	return int(rcv[0])

func get_card_number() -> int:
	return counter

func update_card_number():
	$CardNumber.set_text(str(counter))

func _on_Add1Button_pressed():
	if counter + 1 <= max_cards and counter + 1 <= owned_card_number:
		counter += 1
		update_card_number()

func _on_Add10Button_pressed():
	if counter + 10 <= max_cards and counter + 10 <= owned_card_number:
		counter += 10
		update_card_number()

func _on_RemoveAllButton_pressed():
	counter = min_cards
	update_card_number()


func _on_ConfirmButton_pressed():
	get_parent().emit_signal("advanced_selection", selected_card_id, selected_card_name, counter)
