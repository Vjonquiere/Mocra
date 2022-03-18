extends Control

func _ready():
	pass 

func change_avatar(card_name:String):
	var avatar = load("res://cards/avatar/{test}.png".format({'test':card_name}))
	$Avatar.set_texture(avatar)

func change_informations(card_name:String, card_description:String):
	$TitleVar.set_text(card_name)
	$DescriptionVar.set_text(card_description)
