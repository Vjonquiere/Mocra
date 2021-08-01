extends Node

var con = StreamPeerTCP.new()

func _ready():
	con.connect_to_host("poschocnetwork.eu", 2305)
	
	
func waiting_for_server():
	while con.get_available_bytes() == 0:
		pass
	return con.get_string(con.get_available_bytes()).split("/")

func waiting_for_cards():
	while con.get_available_bytes() == 0:
		pass
	return con.get_string(con.get_available_bytes()).split("|")