extends Control

const paths = {"friend_request": "res://mocraClassic/notifications/friend/preset.tscn", "buy_card": "res://mocraClassic/notifications/cards/preset.tscn"}

var notifications = []
var notifications_GUI = []
var cycle_timer = Timer.new()

func setup_timer():
	cycle_timer.set_wait_time(3)
	cycle_timer.set_one_shot(false)
	$".".add_child(cycle_timer)
	cycle_timer.connect("timeout", self, "_on_cycle")

func init_with_ids(notifications_ids):
	setup_timer()
	get_notifications(notifications_ids)

func get_notifications(notifications_ids):
	for notification in notifications_ids:
		var string = "get_notification_with_id/" + str(notification)
		var uid = Networking.send_data_through_queue(string, "/")
		var packet = [null, null]
		while packet[1] != uid:
			packet = yield(Networking, "packet_found")
		notifications.append(packet[0])
	display_notifications()

func display_notifications():
	cycle_timer.start()
	for notification in notifications:
		if paths.has(notification[0]):
			var notification_preset = load(paths[notification[0]])
			var instance
			match len(notification):
				2: instance = notification_preset.instance().setup(str(notification[1]))
				3: instance = notification_preset.instance().setup(str(notification[1]), str(notification[2]))
				4: instance = notification_preset.instance().setup(str(notification[1]), str(notification[2]), str(notification[3]))
			$VBoxContainer.add_child(instance)
			instance.play_animation("display")
			notifications_GUI.append(instance)


func _on_cycle():
	if notifications_GUI.empty():
		return
	var notif = notifications_GUI.pop_front()
	notif.delete()
