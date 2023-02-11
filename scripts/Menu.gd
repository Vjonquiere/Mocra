extends Control

var width_center = ( int(ProjectSettings.get_setting("display/window/size/width")) / 2)
var height_center = ( int(ProjectSettings.get_setting("display/window/size/height")) / 2)

signal remove_blur()

func _ready():
	
	update_client_infos()
	$Profile/NameLabel.set_text(Global.username)
	$Profile/GlobalPointsLabel.set_text(Global.global_points)
	
	$AnimatedSprite.position.y = height_center - 30
	$AnimatedSprite.position.x = width_center


func _on_Button_pressed():
	
	$ErrorLabel.visible = false
	
	var uid = Networking.send_data_through_queue("open_box/01", "|")
	var packet = [null, null]
	while packet[1] != uid:
		packet = yield(Networking, "packet_found")
	var results = packet[0]
	make_opening(results)



func _on_ShinyButton_pressed():
	
	$ErrorLabel.visible = false
	
	var uid = Networking.send_data_through_queue("open_box/02", "|")
	var packet = [null, null]
	while packet[1] != uid:
		packet = yield(Networking, "packet_found")
	var results = packet[0]
	make_opening(results)

func make_opening(results):
	
	if results[0] == "error":
		$ErrorLabel.set_text(results[1])
		$ErrorLabel.visible = true
	else:
		var my_card_array = ["display_cards",]
		var card_id_array = results[0].split("/")
		var sorted_id_pile = count_duplicates(card_id_array)

		while sorted_id_pile.isEmpty() == false:
			var card = sorted_id_pile.unstack()
			var request = "get_card_infos/" + str(card[0]) 
			Networking.send_data(request)
			var rcv = yield(Networking.waiting_for_server_without_separator(), "completed")
			my_card_array.append(rcv + "/" + str(card[1]))

		Global.card_str = my_card_array
		print(my_card_array)
		get_tree().change_scene("res://scenes/card_opening.tscn")

func count_duplicates(card_array:Array) -> Pile:
	var pile = Pile.new()
	var checked_numbers = []
	for i in range(len(card_array)):
		if card_array[i] in checked_numbers:
			pass
		else:
			checked_numbers.append(card_array[i])
			var counter = 0
			for k in range(len(card_array)):
				if card_array[k] == card_array[i]:
					counter+=1
			pile.stack([card_array[i],counter])
	return pile


func update_client_infos():
	var uid = Networking.send_data_through_queue("update_client_infos", "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = yield(Networking, "packet_found")
	var received_data = packet[0]
	print(received_data)
	$clientInfos.set_credits(received_data[1])
	$clientInfos.set_shiny_cedits(received_data[2])
	$clientInfos.set_boost(str(stepify(float(received_data[3]),0.01)))



func _on_CollectionButton_pressed():
	var uid = Networking.send_data_through_queue("check_if_own_cards", "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = yield(Networking, "packet_found")
	var receive = packet[0]
	if receive[0] == "0":
		$ErrorLabel.set_text("you don't have any cards")
		$ErrorLabel.visible = true
	else:
		get_tree().change_scene("res://scenes/Collection.tscn")




func _on_BattleButton_pressed():
	get_tree().change_scene("res://scenes/Battle.tscn")

func _on_TradeButton_pressed():
	get_tree().change_scene("res://scenes/Trade.tscn")


func _on_FriendButton_pressed():
	get_tree().change_scene("res://scenes/Friends.tscn")

func _on_MocraAdventureButton_pressed():
	get_tree().change_scene("res://scenes/AdventureLobby.tscn")


func _on_PlayerShopButton_pressed():
	get_node(".").add_child(load("res://scenes/player_shop.tscn").instance())
	$blur.visible = true


func _on_OptionsButton_pressed():
	get_node(".").add_child(load("res://mocraClassic/parameters/Control.tscn").instance())
	$blur.visible = true


func _on_Control_remove_blur():
	update_client_infos()
	$blur.visible = false


func _on_notifButton_pressed():
	var uid = Networking.send_data_through_queue("get_notifications", "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = yield(Networking, "packet_found")
	var receive = packet[0]
	print("RCV = ", receive)
	print("receive len = ", len(receive))
	for notifications in receive:
		var string = "get_notification_with_id/" + str(notifications)
		print('REQUEST ====== ', string)
		var uid1 = Networking.send_data_through_queue(string, "/")
		var packet1 = [null, null]
		while packet1[1] != uid:
			packet1 = yield(Networking, "packet_found")
		var receive1 = packet1[0]
		print("NoTIF = ", receive1)
