extends Control

const PATH = "res://cards/avatar/"

var card_infos
var card_id
var number_of_cards
var credits_amount
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_card().completed
	$numberLabel.set_text("x"+str(number_of_cards))
	$amountLabel.set_text(str(int(credits_amount)*int(number_of_cards)))
	$cardIcon.set_texture(load(PATH+str(card_infos[3])+".png"))

func setup(card_id, number_of_cards, credits_amount):
	self.number_of_cards = number_of_cards
	self.credits_amount = credits_amount
	self.card_id = card_id
	return self

func get_card():
	var string = "get_card_infos/" + str(self.card_id)
	var uid = Networking.send_data_through_queue(string, "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	card_infos = packet[0]
