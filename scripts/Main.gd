extends Control

func _ready():
	if is_first_launch():
		print("Mocra: Online card collection first launch \nGenerating files ....")
		generate_user_files()
	else:
		Options.load_inputs("user://options.json")
		Options.load_options("user://options.json")
	print('game launched')

func _on_Button_pressed():
	
	var login = $LoginEntry.get_text()
	var password = $PasswordEntry.get_text().sha256_text()
	var final = "login_test/"+login+"/"+password+"/"+Networking.client_version
	
	if $ErrorLabel.visible:
		$ErrorLabel.visible = false

	var uid = Networking.send_data_through_queue(final, "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	var rcv = packet[0]

	if rcv[0] == "display_user_infos":
		Global.credits= rcv[2]
		Global.shiny_credits = rcv[3]
		Global.boost = str(snapped(float(rcv[4]),0.01))
		Global.username = rcv[5]
		Global.global_points = rcv[6]
		Global.mocra_ID = rcv[1]
		print("Mocra ID: ", Global.mocra_ID)
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")

	if rcv[0] == "error" && rcv[1] == "invalid_login":
		$ErrorLabel.set_text("ERROR: Invalid login or password")
		$ErrorLabel.visible = true
		
	if rcv[0] == "error" && rcv[1] == "old_client_version":
		$ErrorLabel.set_text("ERROR: Please download the last version of Mocra")
		$ErrorLabel.visible = true
	
	if rcv[0] == "error" && rcv[1] == "already_loged_in":
		$ErrorLabel.set_text("ERROR: You are already connected !")
		$ErrorLabel.visible = true


func _on_Button2_pressed():
	get_tree().change_scene_to_file("res://scenes/Register.tscn")


func _on_Button3_pressed():
	OS.shell_open("https://google.com")


func get_server_info():
	var uid = Networking.send_data_through_queue("get_server_infos", "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	var rcv = packet[0]
	
	if rcv[0] == "null":
		pass
	else:
		$ServerLabel.set_text("Connected to: " + rcv[0])
		$OnlinePlayerLabel.set_text("Online players: " + rcv[1])

func is_first_launch() -> bool:
	return FileAccess.file_exists("user://options.json")


func generate_user_files():
	var file = FileAccess.open("res://mocraClassic/parameters/options.json", FileAccess.READ)
	var content = file.get_as_text()
	var copy_file = FileAccess.open("user://options.json", FileAccess.WRITE)
	copy_file.store_string(content)
	copy_file.close()
	file.close()


func _on_Control_ready():
	return
	if Networking.connection_established():
		print("getting server informations")
		get_server_info()
	else:
		get_tree().change_scene_to_file("res://scenes/Offline.tscn")
