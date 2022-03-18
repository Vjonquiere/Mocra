extends Control

var player_name = ""

var profile_scene = load("res://scenes/Profile.tscn")

func _ready():
	Networking.con.put_data("get_friends".to_utf8())
	var rcv = Networking.waiting_for_news()
	display_friends(rcv)
	


func _on_Button_pressed():
	$AddFriendNode/player_profile.visible = false
	$AddFriendNode/UnknownPlayerLabel.visible = false
	$AddFriendNode/FriendRequestSendedLabel.visible = false
	player_name = $AddFriendNode/LineEdit.get_text()
	var final_str = "get_profile/" + player_name
	Networking.con.put_data(final_str.to_utf8())
	var rcv = Networking.waiting_for_server()
	if rcv[0] != "nobody_found":
		change_profile_infos(rcv[0], rcv[1])
		$AddFriendNode/player_profile.visible = true
		$AddFriendNode/player_profile/AddFriendButton.visible = true
	else:
		$AddFriendNode/UnknownPlayerLabel.visible = true


func change_profile_infos(name, global_points):
	$AddFriendNode/player_profile/GlobalPointImage/PointsLabel.set_text(global_points)
	$AddFriendNode/player_profile/NameLabel.set_text(name)

func _on_AddFriendButton_pressed():
	var packet = "create_friend_request/" + player_name
	Networking.con.put_data(packet.to_utf8())
	$AddFriendNode/player_profile/AddFriendButton.visible = false
	$AddFriendNode/FriendRequestSendedLabel.visible = true


##############################################
############### Friend list ##################
##############################################

func display_friends(friend_packet):
	print(friend_packet)
	for i in range(1, len(friend_packet)-1):
		var friend = friend_packet[i].split("/")
		var online = true
		var profile_scene_instance = profile_scene.instance()
		$MyFriendNode/FriendContainer/VBoxContainer.add_child(profile_scene_instance)
		if friend[0] == "0":
			online = false
		else:
			online = true
		profile_scene_instance.profile_setup(friend[1],friend[2],online)


func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
