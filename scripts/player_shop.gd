extends Control

# Declare member variables here. Examples:
# var a = 2
var shop_cards = []
var selected_card = {"id":null}
var sell_card_template = load("res://mocraClassic/player_shop/card_template/card_template.tscn")
signal buy(transactionID, quantity)
signal selection_done(card_usage, card_id, card_name, amount)
signal retrieve(transactionID)
# Called when the node enters the scene tree for the first time.
func _ready():
	display_cards()
	search_current_cards_to_sell()


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
	var card_selector = load("res://mocraAdventure/card_selector/CardSelector.tscn").instance()
	get_node(".").add_child(card_selector)
	card_selector.init_selection("all", "tets")
	card_selector.display_collection()
	card_selector.set_position(Vector2(500,200)) 

#####################
### BUY CARD PART ###
#####################

func display_cards():
	Networking.con.put_data("display_shop".to_utf8())
	var shop_infos = yield(Networking.waiting_for_server("|"), "completed")
	print("RES: ", shop_infos)
	if shop_infos[0] == "EMPTY_SHOP":
		$EmptyLabel.visible = true
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

func refresh(): ## BORDEL => A REFAIRE
	var children = $ScrollContainer/Buy.get_children()
	for i in range(len(children)):
		children[i].queue_free()
	children = $CurrentCardToSell/Container.get_children()
	for i in range(len(children)):
		children[i].queue_free()
	display_cards()
	search_current_cards_to_sell()

func _on_Control_buy(transactionID, quantity):
	var req = "buy_card/" + str(transactionID) + "/" + str(quantity) 
	Networking.con.put_data(req.to_utf8())
	var res = yield(Networking.waiting_for_server("/"), "completed")
	if res[0] == "TRANSACTION_DONE":
		self.queue_free()


func _on_QuitButton_pressed():
	self.queue_free()


func _on_SellButton_pressed():
	if selected_card["id"] != null && int($Sell/UnitPriceLineEdit.get_text()) != 0:
		var req = "sell_card/" + str(selected_card["id"]) + "/" + str(int($Sell/AmoutSpinBox.get_value())) + "/" + str(int($Sell/UnitPriceLineEdit.get_text()))
		print(req)
		Networking.con.put_data(req.to_utf8())
		var res = yield(Networking.waiting_for_server("/"), "completed")
		print(res)
	else:
		print("ERROR")
	refresh()


func _on_Control_selection_done(card_usage, card_id, card_name, amount):
	if card_id != null && card_name != null:
		$Sell/SelectedCardNameLabel.set_text(card_name)
		$Sell/SelectedCardNameLabel.visible = true
		selected_card["id"] = card_id

#### CURRENT CARDS TO SELL
func search_current_cards_to_sell():
	Networking.con.put_data("get_sell_waiting_cards".to_utf8())
	var res = yield(Networking.waiting_for_server("/"), "completed")
	print(res)
	if res[0] == "NOTHING_HERE":
		pass
	else:
		for i in range(len(res)):
			var card = init_card_to_sell(res[i])
			$CurrentCardToSell/Container.add_child(card)
	

func init_card_to_sell(card_infos:String):
	var parsed_infos = card_infos.split("/")
	print("PARSED INFOS: ", parsed_infos)
	var card_template = sell_card_template.instance()
	card_template.set_type_to_current_sell()
	card_template.set_infos(parsed_infos[0], "you", parsed_infos[4], parsed_infos[2], parsed_infos[3])
	return card_template
	

##########################
### RETREIVE CARD PART ###
##########################

func _on_Control_retrieve(transactionID):
	print("retrieve_card")
	var req = "retrieve_card/" + transactionID
	Networking.con.put_data(req.to_utf8())
	var res = yield(Networking.waiting_for_server("/"), "completed")
	print(res)
	if res[0] == "DONE":
		refresh()
