extends Control

const PATH = "res://cards/avatar/"

var card_infos
var card_id
var number_of_cards
var credits_amount
var notification_id
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_card().completed
	$Control/numberLabel.set_text("x"+str(number_of_cards))
	$Control/amountLabel.set_text(str(int(credits_amount)*int(number_of_cards)))
	$Control/cardIcon.set_texture(load(PATH+str(card_infos[3])+".png"))

func setup(p_notification_id, p_card_id, p_number_of_cards, p_credits_amount):
	number_of_cards = p_number_of_cards
	credits_amount = p_credits_amount
	card_id = p_card_id
	notification_id = p_notification_id
	return self

func get_card():
	var string = "get_card_infos/" + str(self.card_id)
	var uid = Networking.send_data_through_queue(string, "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	card_infos = packet[0]

func _on_deleteButton_pressed():
	var uid = Networking.send_data_through_queue("delete_notification/"+str(notification_id), "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	if packet[0][0] == "DONE":
		self.queue_free()
