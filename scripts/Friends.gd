extends Control

var player_name = ""

var profile_scene = load("res://scenes/Profile.tscn")

func _ready():
	var uid = Networking.send_data_through_queue("get_friends", "|")
	var packet = [null, null]
	while packet[1] != uid:
		packet = yield(Networking, "packet_found")
	var rcv = packet[0]
	display_friends(rcv)
	


func _on_Button_pressed():
	$AddFriendNode/player_profile.visible = false
	$AddFriendNode/UnknownPlayerLabel.visible = false
	$AddFriendNode/FriendRequestSendedLabel.visible = false
	player_name = $AddFriendNode/LineEdit.get_text()
	var request = "get_profile/" + player_name
	var uid = Networking.send_data_through_queue(request, "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = yield(Networking, "packet_found")
	var rcv = packet[0]
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
	Networking.send_data(packet)
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
