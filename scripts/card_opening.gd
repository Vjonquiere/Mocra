extends Control

var width_center = ( int(ProjectSettings.get_setting("display/window/size/width")) / 2)
var height_center = ( int(ProjectSettings.get_setting("display/window/size/height")) / 2)
var classic_theme = load("res://Theme/Theme.tres") 
var multiple_cards = load("res://Objects/multiple_cards/multiple_cards.tscn")
const battle_points = {"Common": 20, "Not Much Common": 30, "Unusual": 45, "Rare": 60, "Extremely Rare": 70, "Unbelievable":80, "Mythical": 90, "RAINBOW": 100}
var card_index = 0
var pack_content = {}
var opponent_card_dic = {}
var opponent_card = null
var opening_type = null
var player_score = []
var opponent_score = []
var actual_score = 0
var actual_opponent_score = 0
var player_score_var = Label.new()
var player_score_label = Label.new()
var opponent_score_var = Label.new()
var opponent_score_label = Label.new()
var can_show_next_card = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var card_str = Global.card_str

	$BetweenCardsAnim.position.y = height_center - 30
	$BetweenCardsAnim.position.x = width_center

	Global.card = preload("res://scenes/Common.tscn")
	if card_str[0] == "display_cards":
		card_str.remove(0)
		for i in range(len(card_str)):
			pack_content[i] = _create_card_instance(card_str[i])
		$pack_open_anim.play("default")

	if card_str[0] == "battle":
		opening_type = "battle"
		opponent_card = Global.opponent_card_str
		opponent_card.remove(0)
		card_str.remove(0)
		for i in range(len(card_str)):
			opponent_card_dic[i] = _create_opponent_card_instance(opponent_card[i])
			pack_content[i] = _create_card_instance(card_str[i])
		$pack_open_anim.play("default")
	
	
func _create_opponent_card_instance(card_str):
	var instance  = Global.card.instance()
	$".".add_child(instance)
	instance.position.y = height_center - 30
	instance.position.x = width_center - 300
	
	var card_infos = card_str.split("/")
	instance._change_informations(card_infos[1], card_infos[2], card_infos[3], card_infos[4], card_infos[5])
	instance.scale = Vector2(0.7,0.7)
	instance.display_battle_points(card_infos[4])
	opponent_score.append(int(battle_points[card_infos[4]])) 
	
	return instance
	
func _create_card_instance(card_str):
	var instance  = Global.card.instance()
	$".".add_child(instance)
	instance.position.y = height_center - 30
	instance.position.x = width_center
	
	var card_infos = card_str.split("/")
	var multiple_card = multiple_cards.instance()

	if opening_type != "battle" and card_infos[8] != "1":
		multiple_card.set_scale(Vector2(0.3,0.3))
		multiple_card.set_position(Vector2(130,-230))
		multiple_card.set_card_number(card_infos[8])
		instance.add_child(multiple_card)
	print("card_infos = ", card_infos)
	instance._change_informations(card_infos[1+1], card_infos[2+1], card_infos[3+1], card_infos[4+1], card_infos[5+1])
	
	if opening_type == "battle":
		instance.display_battle_points(card_infos[4])
		player_score.append(int(battle_points[card_infos[4]])) 
	
	return instance

func dispay_card(pack_content, card):
	pack_content[card].visible = true
	if opening_type == "battle":
		opponent_card_dic[card].visible = true

func _input(event):
	if event is InputEventMouseButton and can_show_next_card == true:
		can_show_next_card = false
		if card_index < Global.card_number -1:
			$BetweenCardsAnim.visible = true
			pack_content[card_index].visible = false
			if opening_type == "battle":
				opponent_card_dic[card_index].visible = false
			card_index += 1
			pack_content[card_index].visible = true
			if opening_type == "battle":
				opponent_card_dic[card_index].visible = true
			$BetweenCardsAnim.frame = 0
			$BetweenCardsAnim.play("opening")
	
		elif card_index == Global.card_number - 1:
			pack_content[card_index].visible = false
			if opening_type == "battle":
				opponent_card_dic[card_index].visible = false
			pack_content.clear()
			opponent_card_dic.clear()
			
			if opening_type == "battle":
				$ResultOverlay.visible = true
				$ResultOverlay/YourScoreLabel/YourScoreVar.set_text(str(actual_score))
				$ResultOverlay/OpponentScoreLabel/OpponentScoreVar.set_text(str(actual_opponent_score))
				print(Global.battle_result)
				if Global.battle_result[1] == "winner":
					$ResultOverlay/ResultImage.texture = load("res://images/battle_mode/battle_win.png")
				elif Global.battle_result[1] == "loser":
					$ResultOverlay/ResultImage.texture = load("res://images/battle_mode/battle_lose.png")
				else:
					$ResultOverlay/ResultImage.texture = load("res://images/battle_mode/battle_draw.png")
			else:
				get_tree().change_scene("res://scenes/Menu.tscn")




func _on_BetweenCardsAnim_animation_finished():
	$BetweenCardsAnim.visible = false
	if opening_type == "battle":
		actual_opponent_score = actual_opponent_score + opponent_score[card_index]
		print(actual_opponent_score)
		actual_score = actual_score + player_score[card_index]
		player_score_var.set_text(str(actual_score))
		opponent_score_var.set_text(str(actual_opponent_score))
	can_show_next_card = true


func _on_pack_open_anim_animation_finished():
	$pack_open_anim.hide()
	card_index = 0
	dispay_card(pack_content, card_index)
	Global.card_number = len(pack_content)

	
	#### HERE IS ALL THE SCORE LABEL SETUP FOR BATTLE MOD
	if opening_type == "battle":
		$".".add_child(player_score_var)
		$".".add_child(player_score_label)
		player_score_label.set_position(Vector2(width_center + 160, height_center - 200))
		player_score_label.set_text('Your Score:')
		player_score_label.set_theme(classic_theme)
		player_score_var.set_position(Vector2(width_center + 305, height_center - 200))
		player_score_var.set_theme(classic_theme)
		actual_score = actual_score + player_score[card_index]
		actual_opponent_score = actual_opponent_score + opponent_score[card_index]
		player_score_var.set_text(str(actual_score))

		$".".add_child(opponent_score_var)
		$".".add_child(opponent_score_label)
		opponent_score_label.set_position(Vector2(width_center + 160, height_center - 150))
		opponent_score_label.set_text('Opponent Score:')
		opponent_score_label.set_theme(classic_theme)
		opponent_score_var.set_position(Vector2(width_center + 350, height_center - 150))
		opponent_score_var.set_theme(classic_theme)
		opponent_score_var.set_text(str(actual_opponent_score))
		
	can_show_next_card = true


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Battle.tscn")
