extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup():
	var uid = Networking.send_data_through_queue("get_notifications", "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	var receive = packet[0]
	if len(receive) == 1 && receive[0] == "NO_NOTIFICATION":
		self.queue_free()
	for req in receive:
		get_notification(req)
	return self

func game_init_setup():
	var uid = Networking.send_data_through_queue("get_notifications", "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	var receive = packet[0]
	if len(receive) == 1 && receive[0] == "NO_NOTIFICATION":
		self.queue_free()
		return null
	for req in receive:
		get_notification(req)
	return self

func get_notification(id):
	var uid = Networking.send_data_through_queue("get_notification_with_id/" + str(id), "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = await Networking.packet_found
	var receive = packet[0]
	var notification 
	print("RECEIVE = ", receive)
	match receive[0]:
		"friend_request": notification = load("res://mocraClassic/notifications/friend/detailed_preset.tscn").instantiate().setup(id, receive[1])
		"buy_card": notification = load("res://mocraClassic/notifications/cards/detailed_preset.tscn").instantiate().setup(id, receive[1], receive[2], receive[3])
		"friend_request_refused": notification = load("res://mocraClassic/notifications/friend/detailed_preset.tscn").instantiate().setup(id, receive[1], "refused")
		"friend_request_accepted": notification = load("res://mocraClassic/notifications/friend/detailed_preset.tscn").instantiate().setup(id, receive[1], "accepted")
		_: return
	$Control/ScrollContainer/VBoxContainer.add_child(notification)


func _on_leaveButton_pressed():
	self.queue_free()
