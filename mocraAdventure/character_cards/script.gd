extends Control

func _ready():
	pass # Replace with function body.

func change_avatar(card_name:String) -> void:
	var avatar = load("res://cards/avatar/{card}.png".format({'card':card_name}))
	$Avatar.set_texture(avatar)

func change_informations(hp:String, extra_life:String, speed:String, damage:String, type:String, number_of_owned_cards:String) -> void:
	$HPLabel/HPVar.set_text(hp)
	$ExtraLifeLabel/ExtraLifeVar.set_text(extra_life)
	$SpeedLabel/SpeedVar.set_text(speed)
	$DamageLabel/DamageVar.set_text(damage)
	$TypeLabel/TypeVar.set_text(type)
	$OwnedLabel/OwnedVar.set_text(number_of_owned_cards)
