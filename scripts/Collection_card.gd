extends Node2D

var colors = {"Common":"#7D7D7D", "Not Much Common":"#2c65e8", "Unusual":"#00D989", "Rare":"#C3DD25", "Extremely Rare":"#C40000", "Unbelievable":"#0091B4", "Mythical":"#FF9000", "RAINBOW":"#00CDAD"}

# Called when the node enters the scene tree for the first time.
func _ready():
	$CardBackground/Avatar.texture = load("res://cards/avatar/9.png")
	get_node(".").visible = false


func _change_informations(serie, name, scarcity, owned_number):
	$CardBackground/Avatar.texture = load("res://cards/avatar/{character}.png".format({"character": name}))
	$".".texture = load("res://cards/backgrounds/{scarcity}.png".format({"scarcity": scarcity}))
	$CardBackground/NameLabel/Name.set_text(name)
	$CardBackground/SerieLabel/Serie.set_text(serie)
	$CardBackground/Owned.set_text(owned_number)
	$CardBackground/Owned.set("custom_colors/font_color",Color(colors[scarcity]))


func _display_card():
	get_node(".").visible = true