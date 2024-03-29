extends Control

var unit_price 
var transactionID
var quantity
var cardID
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_type_to_current_sell():
	$BackgroundTexture.set_texture(load("res://images/shop/card_background.png"))
	$Button.visible = false
	$RetrieveButton.visible = true
	$BuyLabel.visible = false

func set_infos(number, seller_name, quantity, price, cardId):
	transactionID = number
	cardID = cardId
	$BuyLabel/SpinBox.max_value = int(quantity)
	var card_infos = yield(card_infos_req(cardId), "completed")
	card_init(card_infos["name"], price, card_infos["scarcity"], quantity, seller_name)
	update_price(1) 

func card_infos_req(cardId):
	var req = "get_card_infos/" + str(cardId)
### RCV TROP LONG 
	var uid = Networking.send_data_through_queue(req, "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = yield(Networking, "packet_found")
	var res = packet[0]
	return {"name":res[3], "scarcity":res[4]}

func card_init(name, price, scarcity, quantity, seller_name):
	$NameLabel.set_text(name)
	$PriceLabel.set_text(price)
	$ScarcityLabel.set_text(scarcity)
	$ScarcityLabel.set("custom_colors/font_color", Color(Global.colors[scarcity])) 
	$SellerLabel.set_text(seller_name)
	$QuantityLabel.set_text(str(quantity) + " Available")
	var path = "res://cards/avatar/" + name + ".png"
	$AvatarTexture.set_texture(load(path))
	unit_price = price

func update_price(amount:int):
	quantity = amount
	$BuyLabel.set_text("Buy                  for " + str(amount*int(unit_price)))

func _on_SpinBox_value_changed(value):
	update_price(value)


func _on_Button_pressed():
	get_node("../../../../").emit_signal("buy", transactionID, quantity)


func _on_RetrieveButton_pressed():
	get_node("../../../").emit_signal("retrieve", transactionID)
