extends CanvasLayer

const paths = {"friend_request": "res://mocraClassic/notifications/friend/preset.tscn", "buy_card": "res://mocraClassic/notifications/cards/preset.tscn", "friend_request_refused": "res://mocraClassic/notifications/friend/preset.tscn"}

var notifications = []
var notifications_GUI = []
var cycle_timer = Timer.new()

func setup_timer():
	cycle_timer.set_wait_time(3)
	cycle_timer.set_one_shot(false)
	$".".add_child(cycle_timer)
	cycle_timer.connect("timeout",Callable(self,"_on_cycle"))

func init_with_ids(notifications_ids):
	setup_timer()
	get_notifications(notifications_ids)

func get_notifications(notifications_ids):
	for notification in notifications_ids:
		var string = "get_notification_with_id/" + str(notification)
		var uid = Networking.send_data_through_queue(string, "/")
		var packet = [null, null]
		while packet[1] != uid:
			packet = await Networking.packet_found
		notifications.append(packet[0])
	$AnimationPlayer.play("display")
	display_notifications()

func display_notifications():
	cycle_timer.start()
	for notification in notifications:
		if paths.has(notification[0]):
			var notification_preset = paths[notification[0]]
			var inst = load("res://mocraClassic/notifications/notification_preset.tscn").instantiate().setup(notification_preset, notification)
			$VBoxContainer.add_child(inst)
			inst.play_animation("display")
			notifications_GUI.append(inst)

func is_empty():
	return notifications_GUI.is_empty()

func _on_cycle():
	if notifications_GUI.is_empty():
		$AnimationPlayer.play("hide")
		notifications = []
		notifications_GUI = []
		return
	var notif = notifications_GUI.pop_front()
	notif.delete()

func _on_moreButton_pressed():
	var notification_summary = await load("res://mocraClassic/notifications/notification_summary.tscn").instantiate().setup().completed
	$".".add_child(notification_summary)
