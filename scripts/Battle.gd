extends Control

# Declare member variables here. Examples:
var room_code
var battle_results
var thread
var label_theme = load("res://fonts/Default_font.tres") 
var classic_theme = load("res://Theme/Theme.tres") 
var timer = Timer.new()
var refresh = false
signal join
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func display_joinable_battles(battle_array):
	var join_button = {}
	var control_node = Control.new()
	$".".add_child(control_node)
	control_node.set_position(Vector2(370,250))
	var host_username_column = Label.new()
	var number_of_player_column = Label.new()
	var number_of_cards_column = Label.new()
	control_node.add_child(host_username_column)
	control_node.add_child(number_of_player_column)
	control_node.add_child(number_of_cards_column)
	host_username_column.set_theme(classic_theme)
	host_username_column.set_text("HOST USERNAME")
	host_username_column.set_position(Vector2(10,25))
	number_of_cards_column.set_theme(classic_theme)
	number_of_cards_column.set_text("PACK SIZE")
	number_of_cards_column.set_position(Vector2(250,25))
	number_of_player_column.set_theme(classic_theme)
	number_of_player_column.set_text("NUMBER OF PLAYER")
	number_of_player_column.set_position(Vector2(400,25))
	for battles in range(len(battle_array)-1):
		var data = battle_array[battles].split("/")
		var host_username = str(data[1])
		var number_of_player = data[2]
		var number_of_cards = data[3]
		var room_code = data[4]
		var host_username_label = Label.new()
		var number_of_player_label = Label.new()
		var number_of_cards_label = Label.new()
		control_node.add_child(host_username_label)
		control_node.add_child(number_of_player_label)
		control_node.add_child(number_of_cards_label)
		host_username_label.set_theme(classic_theme)
		host_username_label.set_text(host_username)
		host_username_label.set_position(Vector2(10,(battles+2)*40))
		number_of_cards_label.set_theme(classic_theme)
		number_of_cards_label.set_text(number_of_cards)
		number_of_cards_label.set_position(Vector2(250,(battles+2)*40))
		number_of_player_label.set_theme(classic_theme)
		number_of_player_label.set_text(number_of_player)
		number_of_player_label.set_position(Vector2(475,(battles+2)*40))
		join_button[room_code] = Button.new()
		var button = join_button[room_code]
		control_node.add_child(button)
		button.set_position(Vector2(670,(battles+2)*40))
		button.set_text("JOIN")
		button.set_theme(classic_theme)
		button.connect("pressed", self, "join_a_room", [room_code])

func join_a_room(room):
	
	var data = "join_room/" + room
	Networking.send_data(data)
	var result = yield(Networking.waiting_for_server("/"), "completed")
	print(result)
	
	if result[0] == "room_finded":
		var opening = yield(Networking.waiting_for_server("/"), "completed")
		var results = yield(Networking.waiting_for_server("!"), "completed")
		if len(results) < 3:
			print("Infos are not complete")
			
		var opponent_card_array = ["cards",]
		var opponent_card_id = results[0].split("|")
		for i in range(len(opponent_card_id)-1):
			var request = "get_card_infos/" + str(opponent_card_id[i])
			Networking.send_data(request)
			var res = yield(Networking.waiting_for_server(""), "completed")
			opponent_card_array.append(res)
	
		Global.opponent_card_str = opponent_card_array
	
		var my_card_array = ["battle",]
		var my_card_id = results[1].split("|")
		
		for i in range(len(my_card_id)-1):
			var request = "get_card_infos/" + str(my_card_id[i])
			Networking.send_data(request)
			var res = yield(Networking.waiting_for_server(""), "completed")
			my_card_array.append(res)
		

		Global.card_str = my_card_array

		Global.battle_result = results[2].split("/")
	
		get_tree().change_scene("res://scenes/card_opening.tscn")
	
		$CreateRoomNode/CreateButton.disabled = false
		$BackButton.disabled = false
		$JoinButton.disabled = false
	else:
		print("salle indisponible")

func timer_init():
	print('Timer INIT')
	timer.connect("timeout",self,"waiting") 
	timer.set_wait_time(1)
	add_child(timer) 

func waiting():
	battle_results = Networking.new_client_check()
	if battle_results == null:
		print("...")
	else:
		emit_signal("join")
		timer.stop()

func _waiting_for_client2(truc):
	print("thread lancé")
	print("Wainting: ")
	$CreateRoomNode/CreateButton.disabled = true
	$BackButton.disabled = true
	$JoinButton.disabled =true
	timer_init()
	timer.start()


func _on_JoinButton_pressed():
	Networking.send_data("check_available_battle_rooms")
	var rcv = yield(Networking.waiting_for_server("|"), "completed")
	if rcv[0] == "error":
		print("no rooms")
	else:
		display_joinable_battles(rcv)


func _on_CreateButton_pressed():
	var number_of_cards = str($CreateRoomNode/NumberOfCardLabel/SpinBox.get_value())
	var data = "create_battle/" + number_of_cards
	Networking.send_data(data)
	var rcv = yield(Networking.waiting_for_server("/"), "completed")
	room_code = rcv[1]
	$CodeLabel/CodeVar.set_text(room_code)
	$CreateRoomNode/CancelButton.visible = true
	thread = Thread.new()
	thread.start(self, "_waiting_for_client2", "Wafflecopter")


func _on_SpinBox_value_changed(value):
	$CreateRoomNode/PriceLabel/PriceVarLabel.set_text(str(int(value)*6))
	var x = 80 + len($CreateRoomNode/PriceLabel/PriceVarLabel.get_text()) * 6
	$CreateRoomNode/PriceLabel/CreditImage.set_position(Vector2(x, 4))


func _on_Control_join():
	var results = yield(Networking.waiting_for_server("!"), "completed")
	print(results)
	if len(results) < 3:
		print("WARNING -> Infos are not complete")
		#### Partie a completer -> refaire un check packet + join les deux listes
	var opponent_card_array = ["cards",]
	var opponent_card_id = results[1].split("|")

	for i in range(len(opponent_card_id)-1):
		var request = "get_card_infos/" + str(opponent_card_id[i])
		Networking.send_data(request)
		var res = yield(Networking.waiting_for_server(""), "completed")
		opponent_card_array.append(res)
	
	Global.opponent_card_str = opponent_card_array
	
	var my_card_array = ["battle",]
	var my_card_id = results[0].split("|")
	
	for i in range(len(my_card_id)-1):
		var request = "get_card_infos/" + str(my_card_id[i])
		Networking.send_data(request)
		var res = yield(Networking.waiting_for_server(""), "completed")
		my_card_array.append(res)

	Global.card_str = my_card_array
	
	Global.battle_result = results[2].split("/")
	
	
	get_tree().change_scene("res://scenes/card_opening.tscn")

	$CreateRoomNode/CreateButton.disabled = false
	$BackButton.disabled = false
	$JoinButton.disabled = false

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")


func _on_CancelButton_pressed():
	var data = "quit_battle/" + room_code
	Networking.send_data(data)

	var results = yield(Networking.waiting_for_server("!"), "completed")

	timer.stop()
	
	$CreateRoomNode/CancelButton.visible = false
	$BackButton.disabled = false
	$CreateRoomNode/CreateButton.disabled = false
	$JoinButton.disabled = false


