extends Control

func _ready():
	pass # Replace with function body.

func change_avatar(card_name:String):
	var avatar = load("res://cards/avatar/{test}.png".format({'test':card_name}))
	$Avatar.set_texture(avatar)

func change_informations(effect:String, cooldown:String):
	$EffectLabel/EffectVar.set_text(effect)
	$CooldownLabel/CooldownVar.set_text(cooldown)
