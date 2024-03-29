extends Node2D

var SERVER_IP = "poschocnetwork.eu"
var SERVER_PORT = 2556
var timer = Timer.new()
var peer = NetworkedMultiplayerENet.new()
var timed_out_counter = 0
var selection = load("res://mocraAdventure/lobby/lobby.tscn").instance()
var selected_cards = {}
var loading = {"map":false, "players":false}
var players = {}
var players_ids = []
var self_player 
var tile_map 
var map_load

var overlay = load("res://mocraAdventure/overlay/overlay.tscn").instance()
var emul = load("res://mocraAdventure/touch_control/CanvasLayer.tscn").instance()
var player_tags = {}

signal selection_updated(data)
signal level_changed(selected_level)
signal ready_update(state)

func _ready():
	$AnimatedSprite.play("loop")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer
	connection_timer()
	timer.start(0.5)


remote var current_room = null
# Player info, associate ID to data
var player_info = {}
var card_selection_node = {}
# Info we send to other players
var my_info = { name = Global.username, current_room = null, mocra_ID = Global.mocra_ID}

func connection_timer():
	timer.connect("timeout",self,"_on_timer_timeout")
	get_node(".").add_child(timer)

func _on_timer_timeout():
	if peer.get_connection_status() != 2:
		print("disconnected")
		timed_out_counter += 1
		if timed_out_counter == 20:
			$AnimatedSprite.hide()
			$AcceptDialog.popup()
	else:
		print("connected")
		$AnimatedSprite.stop()
		$AnimatedSprite.hide()
		$Menu.show()
		timer.stop()

func _player_connected(id):
	rpc_id(id, "register_player", my_info)

func _player_disconnected(id):
	player_info.erase(id)

func _connected_ok():
	pass

func _server_disconnected():
	pass

func _connected_fail():
	print("echec de la connection")

func MA_disconnect():
	rpc_id(1, "manual_client_disconnect")
	peer.close_connection()
	get_tree().change_scene("res://scenes/Menu.tscn")
	print("Disconnected")
	#print_tree()
	queue_free()

remote func register_player(info):
	var id = get_tree().get_rpc_sender_id()
	player_info[id] = info

remote func make_mocraID_var(rpc_id):
	var req = "register_mocra_adventure/" + str(rpc_id)
	var uid = Networking.send_data_through_queue(req, "/")
	var packet = [null, null]
	while packet[1] != uid:
		packet = yield(Networking, "packet_found")
	var res = packet[0]
	if res[0] == "done":
		rpc_id(1, "mocra_id_verification_done", rpc_id)
	else:
		print("An error has occured when trying to link Mocra and Mocra Adventure")

func _on_CreateRoomButton_pressed():
	rpc_id(1, "create_room")

remote func error(error):
	$Menu/ErrorLabel.set_text(error)
	$Menu/ErrorLabel.visible = true

#data -> [LobbyCodeVar:String, PlayerNumberVar:String, StatusVar:String]
remote func card_selection(data:Array):
	print(data)
	selection.set_lobby_infos(str(data[0]), str(data[1]), str(data[2]))
	get_node(".").add_child(selection)

remote func new_client_join_room(client_data):

	player_info[client_data[0]] = client_data
	card_selection_node[client_data[0]] = load("res://mocraAdventure/player_tag/Player_tag.tscn").instance()
	selection.player_list.add_child(card_selection_node[client_data[0]])
	card_selection_node[client_data[0]].set_name(client_data[1])

remote func room_joined(room_data:Array):

	for i in range(len(room_data)):
		card_selection_node[room_data[i]["rpc_id"]] = load("res://mocraAdventure/player_tag/Player_tag.tscn").instance()
		selection.player_list.add_child(card_selection_node[room_data[i]["rpc_id"]])
		card_selection_node[room_data[i]["rpc_id"]].set_name(room_data[i]["name"])

remote func card_changed(updated_data:Array):

	var card_type_array = ["character", "object1", "object2", "object3"]
	#Array -> [rpc_id, {character:["example", "8"], object1:"example", "8"] ,object2:"example", "8"] , object3:"example", "8"] , ground:"example", "8"]}]
	for i in range(len(card_type_array)):
		card_selection_node[updated_data[0]].set_new_card(card_type_array[i], updated_data[1][card_type_array[i]][0], updated_data[1][card_type_array[i]][1])

remote func level_changed(level):
	selection.set_level(level) ## Need to complete function

remote func player_leave(rpc_id):
	card_selection_node[rpc_id].queue_free()

remote func set_level(level_id:String):
	selection.set_level(level_id)

remote func set_room_leader():
	selection.set_room_leader()

remote func toggle_player_ready(data):
	card_selection_node[data[0]].toggle_ready_state(data[1])

func _on_JoinRoomButton_pressed():
	rpc_id(1, "join_room", $Menu/JoinRoomEntry.get_text())


func _on_AcceptDialog_confirmed():
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_Node2D_selection_updated(data):
	rpc_id(1, "update_card_selection", data)


func _on_Node2D_level_changed(selected_level):
	rpc_id(1, "set_selected_level", selected_level)

func _on_Node2D_ready_update(state):
	rpc_id(1, "ready_update", state)

remote func set_all_to_loading_state(player_ids:Array) -> void:
	for i in range(len(player_ids)):
		card_selection_node[player_ids[i]].play_loading_anim()

remote func player_load_finished(player_id):
	card_selection_node[player_id].stop_loading_anim()

remote func load_players(player_array, player_cards):
	var tags = overlay.get_player_tags()
	var player_template = load("res://mocraAdventure/character/remote_template/template.tscn")
	for i in range(len(player_array)):
		var rpc_id = player_array[i]
		player_tags[rpc_id] = tags[i]
		tags[i].show()
		players_ids.append(rpc_id)
		players[rpc_id] = player_template.instance()
		players[rpc_id].set_sprite_sheet("res://mocraAdventure/character/{name}/SpriteFrame.tres".format({"name": "debug"})) ## A verfier player_cards[rpc_id]["character"][0]
		players[rpc_id].set_collision("res://mocraAdventure/character/{name}/CollisionShape.tres".format({"name": "debug"})) ## Egalement
	loading["players"] = true
	loading_complete_check()

remote func load_self_player(player_card):
	print("CARDS = ", player_card)
	var player_template = load("res://mocraAdventure/character/template/template.tscn")
	self_player = player_template.instance()
	self_player.set_sprite_sheet("res://mocraAdventure/character/{name}/SpriteFrame.tres".format({"name": "debug"}))
	self_player.set_collision("res://mocraAdventure/character/{name}/CollisionShape.tres".format({"name": "debug"}))
	overlay.set_objects_icons(["res://cards/avatar/{name}.png".format({"name":player_card["object1"][0]}), "res://cards/avatar/{name}.png".format({"name":player_card["object2"][0]}), "res://cards/avatar/{name}.png".format({"name":player_card["object3"][0]})])

func has_map(map_path, timestamp):
	var tmp_map = Map.new(self)
	if !tmp_map.has_map(map_path, timestamp):
		return false
	else:
		return true

func download_map(map_path):
	rpc_id(1, "download_map", map_path)

remote func download_file(path, content):
	#print("path => ", path, "\nfile => ", content)
	var parsed_path = path.split("/")
	var dir = Directory.new()
	var file = File.new()
	if !dir.dir_exists("user://maps"): ## Check if maps folder exists
		dir.make_dir("user://maps")
	if !dir.dir_exists("user://maps/" + parsed_path[-2]):
		dir.make_dir("user://maps/" + parsed_path[-2])
	file.open(path, File.WRITE)
	file.store_string(content)
	file.close()


remote func load_map(map_path, map_timestamp):
	if has_map(map_path, map_timestamp):
		print("loading map -> ", map_path)
		map_load = Map.new(self)
		map_load.load_map(map_path)
		var map = MapConstrucor.new()
		map.set_map(map_load)
		map.set_map_path(map_path)
		map.load_tileSet()
		tile_map = map
		loading["map"] = true
		loading_complete_check()
	else:
		download_map(map_path)

remote func load_after_download(map_path, timestamp):
	load_map(map_path, timestamp)

func loading_complete_check() -> void:
	if loading["map"] == true and loading["players"] == true:
		print("Complete Loading")
		rpc_id(1, "load_finished")
	else:
		print("Incomplete Loading")

remote func start():
	var children = self.get_children()
	for i in range(len(children)):
		children[i].queue_free()
	$".".add_child(tile_map.displayMap())
	$".".add_child(overlay)
	if Global.options["visual_control"]:
		$".".add_child(emul)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randf_range(0, 600)
	self_player.set_position(Vector2(my_random_number,100))
	self_player.set_current_camera(true)

func move(new_pos):
	rpc_id(1, "player_moved", new_pos)

func offensive_1():
	rpc_id(1, "offensive_1")

func use_object(object_id):
	overlay.use_object(object_id)

remote func player_moved(player_id, new_pos):
	players[player_id].move(new_pos)

remote func init_position(player_id, pos):
	if players.has(player_id):
		players[player_id].move(pos)
		$".".add_child(players[players_ids[player_id]])
	else:
		self_player.set_position(Vector2(pos[0], pos[1]))
		$".".add_child(self_player)
	print("player moved to ", pos)

remote func player_has_disconnected(player_id):
	if players.has(player_id):
		players[player_id].queue_free()
	else:
		print("Unknown player")

remote func remote_offensive_1(player_id):
	players[player_id].offensive_1()

func entity_hurt(id):
	rpc_id(1, "entity_hurt", id)

func entity_reach(id):
	rpc_id(1, "entity_reach", id)
	print("entity_reach")

func entity_can_be_used(id):
	self_player.entity_can_be_used(id)

func entity_cant_be_used(id):
	self_player.entity_cant_be_used(id)

func entity_use(id):
	rpc_id(1, "entity_use", id)

remote func remote_entity_use(id):
	map_load.entities[str(id)].use()

remote func remove_life_entity(entity_id, amount):
	map_load.entities[str(entity_id)].remove_health(amount)

remote func set_next_objective(title, subhead):
	overlay.next_objective(title, subhead)

remote func first_objective(title, subhead):
	overlay.first_objective(title, subhead)

remote func game_ends(room_stats):
	var end_screen = load("res://mocraAdventure/game_end/Control.tscn").instance()
	$".".add_child(end_screen)
	end_screen.init("test", room_stats)
	$".".remove_child(overlay)
	$".".remove_child(emul)
	map_load.delete_entities()

func _on_MapEditorButton_pressed():
	get_tree().change_scene("res://mocraAdventure/map_editor/map_editor.tscn")

func update_offensive_remaining_cooldown(value):
	overlay.set_offensive_progress_value(value)
