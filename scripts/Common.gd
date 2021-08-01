extends Sprite

var colors = {"Common":"#7D7D7D", "Not Much Common":"#2c65e8", "Unusual":"#00D989", "Rare":"#C3DD25", "Extremely Rare":"#C40000", "Unbelievable":"#0091B4", "Mythical":"#FF9000", "RAINBOW":"#00CDAD"}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Avatar.texture = load("res://cards/avatar/9.png")
	get_node(".").visible = false


func _change_informations(edition, serie, name, scarcity, drop_rate):
	$Avatar.texture = load("res://cards/avatar/{character}.png".format({"character": name}))
	$".".texture = load("res://cards/backgrounds/{scarcity}.png".format({"scarcity": scarcity}))
	$NameLabel/NameVar.set_text(name)
	$ScarcityLabel/ScarcityVar.set_text(scarcity)
	$ScarcityLabel/ScarcityVar.set("custom_colors/font_color",Color(colors[scarcity]))
	$DropRateLabel/DropRateVar.set_text(drop_rate)
	$NameLabel4/NameVar2.set_text(serie)
	$Label.set_text(edition)

func _display_card():
	get_node(".").visible = true