extends Control

var width_center = ( int(ProjectSettings.get_setting("display/window/size/width")) / 2)
var height_center = ( int(ProjectSettings.get_setting("display/window/size/height")) / 2)

func _ready():
	
	$credits_label.set_text(Global.credits)
	$shinycredits_label.set_text(Global.shiny_credits)
	$boost_label.set_text(Global.boost)


func _on_Button_pressed():
	
	$ErrorLabel.visible = false
	
	Networking.con.put_data("open_box/classic".to_utf8())
	var cards = Networking.waiting_for_cards()

	Global.card = preload("res://scenes/Common.tscn")

	
	if cards[0] == "display_cards":
		cards.remove(0)
		for i in range(len(cards)):
			Global.pack_content[i] = _create_card_instance(cards[i])
			
		run_opening_anim()
		Global.card_index = 0
		create_open_env()
		dispay_card(Global.pack_content, Global.card_index)
		Global.card_number = len(Global.pack_content)
		update_client_infos()
		
	if cards[0] == "error":
		$ErrorLabel.set_text(cards[1])
		$ErrorLabel.visible = true
	
	
func _create_card_instance(card_str):
	var instance  = Global.card.instance()
	$".".add_child(instance)
	instance.position.y = height_center - 30
	instance.position.x = width_center
	
	var card_infos = card_str.split("/")
	instance._change_informations(card_infos[1], card_infos[2], card_infos[3], card_infos[4], card_infos[5])
	
	return instance

func dispay_card(pack_content, card):
	pack_content[card].visible = true


func run_opening_anim():
	var anim_scen = load("res://scenes/open_pack_anim.tscn")
	var anim_scene  = anim_scen.instance()
	$".".add_child(anim_scene)
	anim_scene.position.y = height_center
	anim_scene.position.x = width_center
	anim_scene.play_anim()

func create_open_env():
	$TextureRect.visible = false
	$show_next_card.visible = true
	


func _on_show_next_card_pressed():
	if Global.card_index < Global.card_number -1:
		Global.pack_content[Global.card_index].visible = false
		Global.card_index += 1
		Global.pack_content[Global.card_index].visible = true

	elif Global.card_index == Global.card_number - 1:
		Global.pack_content[Global.card_index].visible = false
		Global.pack_content.clear()
		$show_next_card.visible = false
		$TextureRect.visible = true

func update_client_infos():
	Networking.con.put_data("update_client_infos".to_utf8())
	var received_data = Networking.waiting_for_server()
	$credits_label.set_text(received_data[1])
	$shinycredits_label.set_text(received_data[2])
	$boost_label.set_text(str(stepify(float(received_data[3]),0.01)))



func _on_CollectionButton_pressed():
	get_tree().change_scene("res://scenes/Collection.tscn")
