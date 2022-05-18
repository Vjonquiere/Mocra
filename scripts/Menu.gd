extends Control

var width_center = ( int(ProjectSettings.get_setting("display/window/size/width")) / 2)
var height_center = ( int(ProjectSettings.get_setting("display/window/size/height")) / 2)

func _ready():
	
	update_client_infos()
	$Profile/NameLabel.set_text(Global.username)
	$Profile/GlobalPointsLabel.set_text(Global.global_points)
	
	$AnimatedSprite.position.y = height_center - 30
	$AnimatedSprite.position.x = width_center


func _on_Button_pressed():
	
	$ErrorLabel.visible = false
	
	Networking.con.put_data("open_box/01".to_utf8())
	var results = Networking.waiting_for_cards()
	make_opening(results)



func _on_ShinyButton_pressed():
	
	$ErrorLabel.visible = false
	
	Networking.con.put_data("open_box/02".to_utf8())
	var results = Networking.waiting_for_cards()
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
			Networking.con.put_data(request.to_utf8())
			my_card_array.append(Networking.waiting_for_card() + "/" + str(card[1]))
			
		#for i in range(1,len(card_id_array)):
			
			#var request = "get_card_infos/" + str(card_id_array[i])
			#Networking.con.put_data(request.to_utf8())
			#my_card_array.append(Networking.waiting_for_card())
		
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
	Networking.con.put_data("update_client_infos".to_utf8())
	var received_data = Networking.waiting_for_server()
	print(received_data)
	$credits_label.set_text(received_data[1])
	$shinycredits_label.set_text(received_data[2])
	$boost_label.set_text(str(stepify(float(received_data[3]),0.01)))



func _on_CollectionButton_pressed():
	Networking.con.put_data("check_if_own_cards".to_utf8())
	var receive = Networking.waiting_for_server()
	print(receive)
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
