extends Control


var locked = false
var selection = false
@onready var player_list = get_node("PlayerList")
var selection_dic = {"character":["Wood", "1"], "object1":["Flamingo", "1"] ,"object2":["Cow", "1"] , "object3":["Snake", "1"] , "ground":["Phantom", "1"]}

signal selection_done(card, card_id, card_name, number_of_cards)
signal level_changed(level_id)

func _ready():
	var card_type_array = ["object1", "object2", "object3"]
	for i in range(len(card_type_array)):
		set_card_selected("CardsSelector2/CardsSelector/SpecialCards/ObjectsSelector/" + card_type_array[i], card_type_array[i], selection_dic[card_type_array[i]][0])
	set_card_selected("CardsSelector2/CardsSelector/CardSelection", "character", selection_dic["character"][0])
	set_card_selected("CardsSelector2/CardsSelector/SpecialCards/TerrainSelector", "ground", selection_dic["ground"][0])
	get_parent().emit_signal("selection_updated", selection_dic)

func set_card_selected(node:String, type:String, card_name:String):
	get_node(node + "/CardAvatar").set_texture(load("res://cards/avatar/{path}.png".format({"path":card_name})))
	get_node(node + "/CardNameLabel").set_text(card_name)
	get_node(node + "/AmountSelectedLabel").set_text("1")

func set_lobby_infos(LobbyCodeVar:String, PlayerNumberVar:String, StatusVar:String):
	$LobbyInfos/LobbyCodeLabel/LobbyCodeVar.set_text(LobbyCodeVar)
	$LobbyInfos/PlayerNumberLabel/PlayerNumberVar.set_text(PlayerNumberVar)
	$LobbyInfos/StatusLabel/StatusVar.set_text(StatusVar)

func _on_CardSelection_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and locked == false and selection == false:
		print("Card selection clicked")
		selection = true
		card_selection_gui("character", "character")


func _on_Object1_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and locked == false and selection == false:
		print("object 1 selection clicked")
		selection = true
		card_selection_gui("object", "object1")


func _on_Object2_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and locked == false and selection == false:
		print("object 2 selection cicked")
		selection = true
		card_selection_gui("object", "object2")


func _on_Object3_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and locked == false and selection == false:
		print("object 3 selection clicked")
		selection = true
		card_selection_gui("object", "object3")


func _on_TerrainSelector_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and locked == false and selection == false:
		print("Terrain selection clicked")
		selection = true
		card_selection_gui("ground", "ground")


func _on_LevelSelector_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and locked == false and selection == false:
		print("Level selection clicked")
		selection = true
		var level_selector = load("res://mocraAdventure/level_selector/level_selector.tscn").instantiate()
		level_selector.set_scale(Vector2(1,1))
		get_node(".").add_child(level_selector)


func card_selection_gui(type:String, card_usage:String):
		var card_selector = load("res://mocraAdventure/card_selector/CardSelector.tscn").instantiate()
		get_node(".").add_child(card_selector)
		card_selector.set_position(Vector2(210,0))
		card_selector.init_selection(type, card_usage)
		var card_array = await card_selector.search_cards().completed
		card_selector.construct_cards(card_array)

func set_level(level_id:String):
	$LevelSelected/SelectedLevelLabel.set_text("Selected level: " + level_id)

func set_room_leader():
	$LevelSelector.visible = true

func _on_Control_selection_done(card, card_id, card_name, number_of_cards):
	if card == null:
		selection = false
		return 0
	var modification_node
	var amount_label
	var name_label
	var card_avatar_node
	var card_avatar = load("res://cards/avatar/{path}.png".format({"path":card_name}))
	match card:
		"character":
			await $CardsSelector2/CardsSelector/CardSelection/Stats.get_card_stats(card_id, "character").completed
			modification_node = $CardsSelector2/CardsSelector/CardSelection
			amount_label = $CardsSelector2/CardsSelector/CardSelection/AmountSelectedLabel
			name_label = $CardsSelector2/CardsSelector/CardSelection/CardNameLabel
			card_avatar_node = $CardsSelector2/CardsSelector/CardSelection/CardAvatar
		"object1":
			amount_label = $CardsSelector2/CardsSelector/SpecialCards/ObjectsSelector/object1/AmountSelectedLabel
			name_label = $CardsSelector2/CardsSelector/SpecialCards/ObjectsSelector/object1/CardNameLabel
			card_avatar_node = $CardsSelector2/CardsSelector/SpecialCards/ObjectsSelector/object1/CardAvatar
		"object2":
			amount_label = $CardsSelector2/CardsSelector/SpecialCards/ObjectsSelector/object2/AmountSelectedLabel
			name_label = $CardsSelector2/CardsSelector/SpecialCards/ObjectsSelector/object2/CardNameLabel
			card_avatar_node = $CardsSelector2/CardsSelector/SpecialCards/ObjectsSelector/object2/CardAvatar
		"object3":
			amount_label = $CardsSelector2/CardsSelector/SpecialCards/ObjectsSelector/object3/AmountSelectedLabel
			name_label = $CardsSelector2/CardsSelector/SpecialCards/ObjectsSelector/object3/CardNameLabel
			card_avatar_node = $CardsSelector2/CardsSelector/SpecialCards/ObjectsSelector/object3/CardAvatar
		"ground":
			amount_label = $CardsSelector2/CardsSelector/SpecialCards/TerrainSelector/AmountSelectedLabel
			name_label = $CardsSelector2/CardsSelector/SpecialCards/TerrainSelector/CardNameLabel
			card_avatar_node = $CardsSelector2/CardsSelector/SpecialCards/TerrainSelector/CardAvatar
	card_avatar_node.set_texture(card_avatar)
	name_label.set_text(card_name)
	amount_label.set_text(str(number_of_cards))
	selection = false
	selection_dic[card] = [card_name, str(number_of_cards)]
	get_parent().emit_signal("selection_updated", selection_dic)
	print("card: ", card, " card id: ", str(card_id), " number of cards: ", str(number_of_cards))


func _on_LeaveButton_pressed():
	rpc_id(1, "leave_room")


func _on_Control_level_changed(level_id):
	selection = false
	rpc_id(1, "set_selected_level", level_id)


func _on_ReadyButton_toggled(button_pressed):
	if button_pressed:
		selection = true
		get_parent().emit_signal("ready_update", true)
	else:
		selection = false
		get_parent().emit_signal("ready_update", false)
