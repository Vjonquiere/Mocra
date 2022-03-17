extends Container

var classic_theme = load("res://Theme/Theme.tres")


func _ready():
	"""
	Networking.con.put_data("get_news".to_utf8())
	var rcv = Networking.waiting_for_news()
	print(rcv)
	if rcv[0] == "nothing_new":
		nothing_new()
	else:
		for i in range(len(rcv)):
			var request = rcv[i].split("/")
			if request[0] == "friend_request":
				display_friend_request(request, i)"""
	pass


func display_friend_request(request, news_number):
	news_number += 1
	print(request)
	var friend_name = Label.new()
	var accept_button = Button.new()
	var decline_button = Button.new()
	get_node(".").add_child(friend_name)
	get_node(".").add_child(accept_button)
	get_node(".").add_child(decline_button)
	decline_button.set_theme(classic_theme)
	accept_button.set_theme(classic_theme)
	friend_name.set_theme(classic_theme)
	friend_name.set_position(Vector2(0,50))
	friend_name.set_text("- You received a friend request from: " + str(request[1]))
	accept_button.set_text("accept")
	decline_button.set_text("decline")
	decline_button.set_size(Vector2(decline_button.get_size()[0]+100, decline_button.get_size()[1]))
	accept_button.set_size(Vector2(accept_button.get_size()[0]+100, accept_button.get_size()[1]))
	accept_button.set_position(Vector2(friend_name.get_minimum_size()[0]/2-accept_button.get_minimum_size()[0],20+friend_name.get_end()[1]))
	decline_button.set_position(Vector2(friend_name.get_minimum_size()[0]/2+accept_button.get_minimum_size()[0],20+friend_name.get_end()[1]))
	decline_button.connect("pressed", self, "decline_friend_request", [request[1], request[2]])
	accept_button.connect("pressed", self, "accept_friend_request", [request[1], request[2]])

func decline_friend_request(friend_name, request_id):
	var final_request = "decline_friend_request/" + friend_name + "/" + request_id
	Networking.con.put_data(final_request.to_utf8())
	delete_old_nodes()
	_ready()

func accept_friend_request(friend_name, request_id):
	var final_request = "accept_friend_request/" + friend_name + "/" + request_id
	Networking.con.put_data(final_request.to_utf8())
	delete_old_nodes()
	_ready()

	
func delete_old_nodes():
	for _i in self.get_children():
		_i.queue_free()


func nothing_new():
	print("nothing new")