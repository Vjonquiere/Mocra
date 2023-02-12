extends Control

const PATH = "res://cards/avatar/"

var card_infos
var card_id
var number_of_cards
var credits_amount
onready var animation_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_card(), "completed")
	$backgroundTexture/numberLabel.set_text("x"+str(number_of_cards))
	$backgroundTexture/amountLabel.set_text(str(int(credits_amount)*int(number_of_cards)))
	$backgroundTexture/cardIcon.set_texture(load(PATH+str(card_infos[3])+".png"))

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
		packet = yield(Networking, "packet_found")
	card_infos = packet[0]

func has_animation(animation_name:String):
	return animation_player.has_animation(animation_name)

func play_animation(animation_name:String):
	if has_animation(animation_name):
		animation_player.play(animation_name)

func delete():
	animation_player.play("delete")



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "delete":
		self.queue_free()
