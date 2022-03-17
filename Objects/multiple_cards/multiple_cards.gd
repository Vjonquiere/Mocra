extends Node2D


func _ready():
	print("multiple cards init")

func set_card_number(card_number:String):
	$Number.set_text(card_number)
