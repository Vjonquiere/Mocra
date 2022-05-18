extends Control

# Declare member variables here. Examples:
# var a = 2
var shop_cards = []
signal buy(transactionID, quantity)
# Called when the node enters the scene tree for the first time.
func _ready():
	display_cards()


######################
### SELL CARD PART ###
######################

func calculate_total_price(amount, value) -> int:
	return amount*int(value)

func update_total_price():
	var new_price = calculate_total_price($Sell/AmoutSpinBox.get_value(), $Sell/UnitPriceLineEdit.get_text())
	$Sell/TotalLabel.set_text("Total amount will be " + str(new_price))

func _on_UnitPriceLineEdit_text_changed(new_text):
	update_total_price()


func _on_AmoutSpinBox_value_changed(value):
	update_total_price()


func _on_SelectCardButton_pressed():
	pass
	#var card_selector = load("res://mocraAdventure/card_selector/CardSelector.tscn").instance()

#####################
### BUY CARD PART ###
#####################

func display_cards():
	Networking.con.put_data("display_shop".to_utf8())
	var shop_infos = Networking.waiting_for_cards()
	var hbox = HBoxContainer.new()
	$ScrollContainer/Buy.add_child(hbox)
	print("shop infos = ", shop_infos)
	for i in range(len(shop_infos)-1):
		var card = load("res://mocraClassic/player_shop/card_template/card_template.tscn").instance()
		if hbox.get_child_count() >= 4:
			hbox = HBoxContainer.new()
			$ScrollContainer/Buy.add_child(hbox)
		hbox.add_child(card)
		var parsed_infos = parse_card(shop_infos[i].split("/"))
		card.set_infos(parsed_infos["number"], parsed_infos["seller_name"], parsed_infos["quantity"], parsed_infos["price"], parsed_infos["cardId"])
	

func parse_card(card:Array) -> Dictionary:
	return {"number":card[0], "seller_name":card[1], "quantity":card[4], "price":card[2], "cardId":card[3]}



func _on_Control_buy(transactionID, quantity):
	var req = "buy_card/" + str(transactionID) + "/" + str(quantity) 
	Networking.con.put_data(req.to_utf8())
	var res = Networking.waiting_for_server()
	if res[0] == "TRANSACTION_DONE":
		self.queue_free()
