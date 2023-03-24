extends Control

var width_center = ( int(ProjectSettings.get_setting("display/window/size/viewport_width")) / 2)
var height_center = ( int(ProjectSettings.get_setting("display/window/size/viewport_height")) / 2)

signal remove_blur()

func _ready():
	
	update_client_infos()
	$Profile/NameLabel.set_text(Global.username)
	$Profile/GlobalPointsLabel.set_text(Global.global_points)
	
	$AnimatedSprite2D.position.y = height_center - 30
	$AnimatedSprite2D.position.x = width_center
	show_notifications()

func show_notifications():
	var summary = await load("res://mocraClassic/notifications/notification_summary.tscn").instantiate().game_init_setup().completed
	if summary != null:
		$".".add_child(summary)


func _on_Button_pressed():
	
	$ErrorLabel.visible = false
	
	var uid = Networking.send_data_through_queue("open_box/01", "|")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	var results = packet[0]
	make_opening(results)



func _on_ShinyButton_pressed():
	
	$ErrorLabel.visible = false
	
	var uid = Networking.send_data_through_queue("open_box/02", "|")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
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
			var rcv = await Networking.waiting_for_server_without_separator().completed
			my_card_array.append(rcv + "/" + str(card[1]))

		Global.card_str = my_card_array
		print(my_card_array)
		get_tree().change_scene_to_file("res://scenes/card_opening.tscn")


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
		packet = await Networking.packet_found
	var received_data = packet[0]
	print(received_data)
	$clientInfos.set_credits(received_data[1])
	$clientInfos.set_shiny_cedits(received_data[2])
	$clientInfos.set_boost(str(snapped(float(received_data[3]),0.01)))
	$badge.setup(received_data[4])
	$badge.show()



func _on_CollectionButton_pressed():
	var uid = Networking.send_data_through_queue("check_if_own_cards", "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	var receive = packet[0]
	if receive[0] == "0":
		$ErrorLabel.set_text("you don't have any cards")
		$ErrorLabel.visible = true
	else:
		get_tree().change_scene_to_file("res://scenes/Collection.tscn")




func _on_BattleButton_pressed():
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_TradeButton_pressed():
	get_tree().change_scene_to_file("res://scenes/Trade.tscn")


func _on_FriendButton_pressed():
	get_tree().change_scene_to_file("res://scenes/Friends.tscn")

func _on_MocraAdventureButton_pressed():
	get_tree().change_scene_to_file("res://scenes/AdventureLobby.tscn")


func _on_PlayerShopButton_pressed():
	get_node(".").add_child(load("res://scenes/player_shop.tscn").instantiate())
	$blur.visible = true


func _on_OptionsButton_pressed():
	get_node(".").add_child(load("res://mocraClassic/parameters/Control.tscn").instantiate())
	$blur.visible = true


func _on_Control_remove_blur():
	update_client_infos()
	$blur.visible = false
