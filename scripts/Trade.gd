extends Control


var timer = Timer.new()

var nbr_of_my_offer_card = 0
var my_offer_card_array = []

var themee = load("res://Theme/Theme.tres")

var joined_room_code = null
#### Offer var
var my_offer_array = []

func _ready():
	TradeBegin()



func _on_CreateRoomButton_pressed():
	Networking.con.put_data("create_trade".to_utf8())
	$TradeMenu/CreateRoomButton.disabled = true
	$TradeMenu/CreateRoomButton/CancelButton.visible = true
	joined_room_code = Networking.waiting_for_server()[0]
	$TradeMenu/CreateRoomButton/CancelButton/RoomCodeLabel/RoomCodeVarLabel.set_text(joined_room_code) 
	trade_connexion_init()


func _on_JoinRoomButton_pressed():
	if len($TradeMenu/RoomJoinLineEdit.get_text()) == 5:
		var room_code = $TradeMenu/RoomJoinLineEdit.get_text()
		room_code = room_code.to_upper()
		print(room_code)
		var send_str = "join_trade_room/" + room_code
		Networking.con.put_data(send_str.to_utf8()) 
		var return_data = Networking.waiting_for_server()[0]
		if return_data == "noroom":
			print("No room found")
		else:
			joined_room_code = room_code
			trade_connexion_init()


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")

func TradeBegin():
	Networking.con.put_data("get_collection".to_utf8())
	var received_data = Networking.waiting_for_cards()
	
	received_data.remove(0)
	Global.collection_card = preload("res://scenes/Collection_card.tscn")
	Global.current_page = 0

	Global.page_number = len(received_data)/5
	var last_page_card_number = len(received_data)%5
	Global.page_array = {}

	for pages in range(Global.page_number):
		Global.page_array[pages] = []
		for cards in range(5):
			Global.page_array[pages].append(create_collection_card(received_data[0], cards))
			received_data.remove(0)

	if last_page_card_number != 0:
		Global.page_number += 1
		Global.page_array[len(Global.page_array)] = []
		for cards in range(last_page_card_number):
			Global.page_array[len(Global.page_array)-1].append(create_collection_card(received_data[0], cards))
			received_data.remove(0)

	display_page_cards(0,Global.page_array)




###################################################################################
############################ MY OFFER ADD/REMOVE CARDS ############################
###################################################################################

func create_card_trade_options(card_instance, card_id, card_page_index):
	var add_button = Button.new()
	add_button.set_text("Add")
	add_button.connect("pressed", self, "add_to_my_offer", [card_instance, card_id])
	card_instance.add_child(add_button)
	add_button.set_size(Vector2(150,30))
	add_button.set_position(Vector2(-add_button.get_size()[0]/2,175)) 
	add_button.set_theme(themee)

func create_remove_card_trade_option(card_instance, card_id):
	
	var remove_button = Button.new()
	remove_button.set_text("Remove")
	remove_button.connect("pressed", self, "remove_to_my_offer", [remove_button,card_id])
	card_instance.add_child(remove_button)
	remove_button.set_size(Vector2(150,30))
	remove_button.set_position(Vector2(-remove_button.get_size()[0]/2,220)) 
	remove_button.set_theme(themee)


func remove_to_my_offer(remove_button, card_id):
	remove_button.queue_free()
	for i in range(len(my_offer_card_array)):
		if my_offer_card_array[i] == card_id:
			my_offer_card_array.remove(i)
			nbr_of_my_offer_card -= 1
			update_my_offer()
			break

func add_to_my_offer(card_instance, card_id):
	
	if nbr_of_my_offer_card < 3:
		if card_id in my_offer_card_array:
			print('card already added')
		else:
			my_offer_card_array.append(card_id)
			create_remove_card_trade_option(card_instance, card_id)
	
			update_my_offer()
			nbr_of_my_offer_card += 1
	else:
		print("error, you can only trade 3 card a time")
		

func update_my_offer():
	$TradeRoom/MyOffer/Card1Texture/card1.visible = false
	$TradeRoom/MyOffer/Card2Texture/card2.visible = false
	$TradeRoom/MyOffer/Card3Texture/card3.visible = false
	for i in range(len(my_offer_card_array)):
		var card_request = "get_card_infos/" + str(my_offer_card_array[i])
		Networking.con.put_data(card_request.to_utf8())
		var card_infos = Networking.waiting_for_server()
		if i == 0:
			$TradeRoom/MyOffer/Card1Texture/card1._change_informations(card_infos[2],card_infos[3],card_infos[4],"1")
			$TradeRoom/MyOffer/Card1Texture/card1.visible = true
		elif i == 1:
			$TradeRoom/MyOffer/Card2Texture/card2._change_informations(card_infos[2],card_infos[3],card_infos[4],"1")
			$TradeRoom/MyOffer/Card2Texture/card2.visible = true
		elif i == 2:
			$TradeRoom/MyOffer/Card3Texture/card3._change_informations(card_infos[2],card_infos[3],card_infos[4],"1")
			$TradeRoom/MyOffer/Card3Texture/card3.visible = true
	send_new_offer(my_offer_card_array)

#################################################################################################
############################ MY OFFER CARDS DISPLAY AND CARD BUILDER ############################
#################################################################################################

func create_collection_card(card_str, card_page_index):
	var instance  = Global.collection_card.instance()
	instance.scale = Vector2(0.6,0.6)
	$TradeRoom/MyCards.add_child(instance)
	if card_page_index == 0:
		instance.position.x = 160
		instance.position.y = 200
	elif card_page_index > 0 :
		instance.position.x = 160 * (card_page_index + 1)
		instance.position.y = 200

	var card_infos = card_str.split("/")
	instance._change_informations(card_infos[2],card_infos[3],card_infos[4],card_infos[8])
	create_card_trade_options(instance, card_infos[0], card_page_index)
	
	return instance


func display_page_cards(page, page_array):
	for cards in range(len(page_array[page])):
		page_array[page][cards]._display_card()


func hide_page_cards(page, page_array):
	for cards in range(len(page_array[page])):
		page_array[page][cards]._hide_card()

func _on_NextPageButton2_pressed():
	if Global.current_page < Global.page_number -1:
		hide_page_cards(Global.current_page, Global.page_array)
		Global.current_page += 1
		display_page_cards(Global.current_page, Global.page_array)
		$TradeRoom/MyCards/PreviousPageButton.visible = true
		if Global.current_page == Global.page_number -1:
			$TradeRoom/MyCards/NextPageButton.visible = false
	else:
		print("derniere page")


func _on_PreviousPageButton_pressed():
	if Global.current_page > 0:
		hide_page_cards(Global.current_page, Global.page_array)
		Global.current_page -= 1
		display_page_cards(Global.current_page, Global.page_array)
		$TradeRoom/MyCards/NextPageButton.visible = true
		if Global.current_page == 0:
			$TradeRoom/MyCards/PreviousPageButton.visible = false
	else:
		print("premiere page")

################################################################################
############################ OPPONENT CARDS DISPLAY ############################
################################################################################

func update_opponent_lock(state):
	if state:
		$TradeRoom/OpponentOffer/BoxTexture.texture = load("res://images/trade_mode/box_locked.png")
	else:
		$TradeRoom/OpponentOffer/BoxTexture.texture = load("res://images/trade_mode/box.png")

func update_opponent_offer(opponent_card_array):
	$TradeRoom/OpponentOffer/Card1Texture/card1.visible = false
	$TradeRoom/OpponentOffer/Card2Texture/card2.visible = false
	$TradeRoom/OpponentOffer/Card3Texture/card3.visible = false
	if opponent_card_array[0] == "null":
		print("no cards")
	else:
		for i in range(len(opponent_card_array)):
			var card_request = "get_card_infos/" + str(opponent_card_array[i])
			Networking.con.put_data(card_request.to_utf8())
			var card_infos = Networking.waiting_for_server()
			if i == 0:
				$TradeRoom/OpponentOffer/Card1Texture/card1._change_informations(card_infos[2],card_infos[3],card_infos[4],"1")
				$TradeRoom/OpponentOffer/Card1Texture/card1.visible = true
			elif i == 1:
				$TradeRoom/OpponentOffer/Card2Texture/card2._change_informations(card_infos[2],card_infos[3],card_infos[4],"1")
				$TradeRoom/OpponentOffer/Card2Texture/card2.visible = true
			elif i == 2:
				$TradeRoom/OpponentOffer/Card3Texture/card3._change_informations(card_infos[2],card_infos[3],card_infos[4],"1")
				$TradeRoom/OpponentOffer/Card3Texture/card3.visible = true

############################################################################################################
############################ TRADE CONNEXION: RECEIVE/SEND TRADE RELATIVE INFOS ############################
############################################################################################################

func trade_connexion_init():
	print(joined_room_code)
	$TradeRoom/TradeInfos/RoomCodeLabel/RoomCodeVar.set_text(joined_room_code)
	$TradeRoom/TradeInfos/TradingWithLabel/TradingWithVar.set_text("qqn")
	timer_init()
	timer.start()

func timer_init():
	print('Timer INIT')
	timer.connect("timeout",self,"waiting") 
	timer.set_wait_time(1)
	add_child(timer) 

func waiting():
	var trade_rcv = Networking.trade_room_con()
	if trade_rcv == null:
		print("...")
	else:
		timer.stop()
		if trade_rcv[1] == "trade_begin":
			print("LE TARDE VA COMMENCER")
			$TradeMenu.visible = false
			$TradeRoom.visible = true
		if trade_rcv[1] == "new_offer_received":
			print("NEW OFFER RECEIVED")
			print(trade_rcv[2])
			update_opponent_offer(trade_rcv[2].split("|"))
		if trade_rcv[1] == "opponent_locked":
			print("OPPONENT LOCKED TRADE")
			$TradeRoom/Lock/ConfirmButton.disabled = false
			update_opponent_lock(true)
		if trade_rcv[1] == "opponent_unlocked":
			print("OPPONENT UNLOCKED TRADE")
			$TradeRoom/Lock/ConfirmButton.disabled = true
			update_opponent_lock(false)
		if trade_rcv[1] == "trade_effectue":
			print("trade effectue")
			get_tree().change_scene("res://scenes/Menu.tscn")
		if trade_rcv[1] == "opponent_quit":
			get_tree().change_scene("res://scenes/Menu.tscn")
		
		timer.start()


func send_new_offer(offer):
	var complete_offer = "new_offer_received/" + joined_room_code + "/"
	for i in range(len(offer)):
		if i < len(offer)-1:
			complete_offer += str(offer[i]) + "|"
		else:
			complete_offer += str(offer[i])
	if len(offer) == 0:
		complete_offer += "null"
	print("my offer")
	print(offer)
	print(complete_offer)
	Networking.con.put_data(complete_offer.to_utf8())
	var returned_data = Networking.waiting_for_server()
	print(returned_data)


func _on_LockButton_toggled(button_pressed):
	print(button_pressed)
	var complete_str = ""
	if button_pressed:
		complete_str = "lock_trade/" + joined_room_code
		print("lock")
	else:
		complete_str = "unlock_trade/" + joined_room_code
		print("unlock")
	Networking.con.put_data(complete_str.to_utf8())


func _on_LeaveButton_pressed():
	var data = "leave_trade/" + joined_room_code
	Networking.con.put_data(data.to_utf8())
	get_tree().change_scene("res://scenes/Menu.tscn")


func _on_ConfirmButton_pressed():
	var data = "confirm_trade/" + joined_room_code
	Networking.con.put_data(data.to_utf8())
