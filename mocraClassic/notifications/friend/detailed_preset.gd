extends Control


var notification_id
var notification

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func setup(p_notification_id, p_notification, type:String="default"):
	notification_id = p_notification_id
	notification = p_notification
	$playerNameLabel.set_text(str(notification))
	if type != "default":
		change_type_to_refused(type)
	return self

func change_type_to_refused(type:String):
	$acceptButton.hide()
	$declineButton.hide()
	$deleteButton.show()
	if type == "refused":
		$iconTexture.set_texture(load("res://mocraClassic/notifications/friend/refused.png"))
		$typeLabel.set_text("Friend request refused")
	else:
		$typeLabel.set_text("Friend request accepted")
func _on_acceptButton_pressed():
	var req = "accept_friend_request/" + str(notification) + "/" + str(notification_id)
	Networking.send_data_through_queue(req, '/')


func _on_declineButton_pressed():
	var req = "decline_friend_request/" + str(notification) + "/" + str(notification_id)
	Networking.send_data_through_queue(req, '/')


func _on_deleteButton_pressed():
	var uid = Networking.send_data_through_queue("delete_notification/"+str(notification_id), "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = yield(Networking, "packet_found")
	if packet[0][0] == "DONE":
		self.queue_free()
