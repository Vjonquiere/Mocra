extends Node


var con = StreamPeerTCP.new()
var client_version = "1.0"
var anim = AnimatedSprite.new()

func _ready():
	con.connect_to_host("poschocnetwork.eu", 2305)
	print((con.get_status()))
	print(con.is_connected_to_host())
	animation_init()

	
func waiting_for_server():
	if con.is_connected_to_host():
		while con.get_available_bytes() == 0:
			pass
		return con.get_string(con.get_available_bytes()).split("/")
	else:
		print("You are disconected")
		get_tree().change_scene("res://scenes/Offline.tscn")
		return ["null"]
		
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


func animation_init():
	get_node(".").add_child(anim)
	anim.set_sprite_frames(load("res://animations/loading/full_animation.tres"))
	anim.set_position(Vector2(300,300))
	anim.set_scale(Vector2(0.2,0.2))
	anim.set_position(Vector2(1200,650))
	anim.z_index = 100
	anim.visible = false


func play_anim():
	anim.visible = true
	anim.play("init")

func stop_anim():
	anim.stop()
	anim.visible = false

