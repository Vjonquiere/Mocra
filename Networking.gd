extends Node

var tcp = StreamPeerTCP.new()
var con = StreamPeerSSL.new()
var client_version = "1.0"
var anim = AnimatedSprite.new()

signal packet_found(data, timestamp)

var check_timer = Timer.new()
var waiting_queue = Queue.new()
var current

var auto_packet_checker = Timer.new()

func _ready():
	connect("packet_found", self, "_on_packet_found")
	tcp.connect_to_host("poschocnetwork.eu", 2305)
	var cert = load("res://ssl/cert.pem")
	con.connect_to_stream(tcp, true, "poschocnetwork.eu", cert)
	check_timer.connect("timeout", self, "check_queue")
	check_timer.set_wait_time(0.05)
	check_timer.set_one_shot(false)
	get_node(".").add_child(check_timer)
	check_timer.start()
	auto_packet_checker.connect("timeout", self, "_auto_packet_checker")
	get_node(".").add_child(auto_packet_checker)
	auto_packet_checker.set_wait_time(10)
	auto_packet_checker.start()
	animation_init()

func send_data(data:String):
	con.put_data(data.to_utf8())

func generate_uid(length):
	var uid = ""
	var possible_choice = ["a", "b", "c", "d", "e", "f", "0", "1", "2", "3"]
	for i in range(length):
		uid += possible_choice[randi()%len(possible_choice)]
	return uid

func send_data_through_queue(data:String, separator:String=""):
	var uid = generate_uid(10)
	waiting_queue.enqueue([data, uid, separator])
	print("QueueState: ", waiting_queue)
	return uid

func check_queue():
	if !waiting_queue.is_empty() and current == null:
		var head = waiting_queue.get_head()
		con.put_data(head[0].to_utf8())
		current = head
		print("treating: ", current)
		waiting_for_server(head[2], head[1])

func check_sum(data:String, separator):
	var tmp_data = data.split(separator)
	print(tmp_data)
	var data_len = int(tmp_data[0])
	print("CheckSum : ", data_len, " | data = ", data)
	if data_len == data.count(separator):
		return true
	else:
		return false

func remove_check_sum(data:String, separator):
	var tmp_data = data.split(separator)
	var check_sum_len = len(tmp_data[0])+1
	var tmp = data
	tmp.erase(0, check_sum_len)
	return tmp

func connection_established() -> bool:
	if con.get_status() == 2:
		return true
	else:
		return false

func waiting_for_server(separator:String, uid):
	play_anim()
	if con.get_status() == 2:
		con.poll()
		while con.get_available_bytes() == 0:
			yield(get_tree().create_timer(0.001), "timeout")
			if con.get_status() !=2:
				return null
			con.poll()
		var ttl = 20
		var data = con.get_string(con.get_available_bytes())
		while ttl > 0 and check_sum(data, separator) == false:
			con.poll()
			if con.get_available_bytes() != 0:
				data += con.get_string(con.get_available_bytes())
			yield(get_tree().create_timer(0.05), "timeout")
			ttl -= 1
		if ttl <= 0:
			print("PAQUET BROKEN")
			get_tree().change_scene("res://scenes/Menu.tscn")
		var final = remove_check_sum(data, separator)
		stop_anim()
		emit_signal("packet_found", final.split(separator), uid)
		return final.split(separator)
	print("echec connexion")

func _on_packet_found(data, timestamp):
	current = null
	waiting_queue.dequeue()

func waiting_for_server_without_separator():
	if con.get_status() == 2:
		con.poll()
		while con.get_available_bytes() == 0:
			yield(get_tree().create_timer(0.1), "timeout")
			con.poll()
		return con.get_string(con.get_available_bytes())
	else:
		print("You are disconected")
		get_tree().change_scene("res://scenes/Offline.tscn")
		print("null")
		return "null".split("/")

func waiting_for_news():
	emit_signal("test")
	if con.is_connected_to_host():
		while con.get_available_bytes() == 0:
			pass
		return con.get_string(con.get_available_bytes()).split("|")
	else:
		print("You are disconected")
		get_tree().change_scene("res://scenes/Offline.tscn")

func waiting_for_cards():
	if con.is_connected_to_host():
		while con.get_available_bytes() == 0:
			pass
		return con.get_string(con.get_available_bytes()).split("|")
	else:
		print("You are disconected")
		get_tree().change_scene("res://scenes/Offline.tscn")


func waiting_for_battle_results():
	if con.is_connected_to_host():
		while con.get_available_bytes() == 0:
			pass
		return con.get_string(con.get_available_bytes()).split("!")
	else:
		print("You are disconected")
		get_tree().change_scene("res://scenes/Offline.tscn")

func new_client_check():
	if con.get_available_bytes() == 0:
		return null
	else:
		return con.get_string(con.get_available_bytes()).split("/")


func trade_room_con():
	if con.get_available_bytes() == 0:
		return null
	else:
		print("ON A DE LA DATA")
		var data = con.get_string(con.get_available_bytes()).split("/")
		print(data)
		if data[0] != "TRADEROOM":
			return null
		else:
			return data

func waiting_for_card():
	if con.is_connected_to_host():
		while con.get_available_bytes() == 0:
			pass
		return con.get_string(con.get_available_bytes())
	else:
		print("You are disconected")
		get_tree().change_scene("res://scenes/Offline.tscn")
		return ["null"]
		
func notification_check():
	if con.get_available_bytes() == 0:
		return null
	else:
		return con.get_string(con.get_available_bytes()).split("/")

func _auto_packet_checker():
	var uid = Networking.send_data_through_queue("get_notifications", "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = yield(Networking, "packet_found")
	var receive = packet[0]
	print(receive)
	if len(receive) == 1 && receive[0] == "FORBIDEN_REQUEST_ON_NO_LOGED_USER":
		return
	print("RCV = ", receive)
	print("receive len = ", len(receive))
	var notif = load("res://mocraClassic/notifications/NotificationCenter.tscn")
	var instance = notif.instance()
	$'.'.add_child(instance)
	instance.init_with_ids(receive)


func animation_init():
	get_node(".").add_child(anim)
	anim.set_sprite_frames(load("res://animations/loading/full_animation.tres"))
	anim.set_scale(Vector2(0.2,0.2))
	anim.set_position(Vector2(1850,1000))
	anim.z_index = 100
	anim.visible = false


func play_anim():
	anim.visible = true
	anim.play("init")

func stop_anim():
	anim.stop()
	anim.visible = false
