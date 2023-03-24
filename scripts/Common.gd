extends Sprite2D

var colors = {"Common":"#7D7D7D", "Not Much Common":"#2c65e8", "Unusual":"#00D989", "Rare":"#C3DD25", "Extremely Rare":"#C40000", "Unbelievable":"#0091B4", "Mythical":"#FF9000", "RAINBOW":"#00CDAD"}
var battle_points = {"Common": 20, "Not Much Common": 30, "Unusual": 45, "Rare": 60, "Extremely Rare": 70, "Unbelievable":80, "Mythical": 90, "RAINBOW": 100}
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

func display_battle_points(scarcity):
	$PointImage/PointVar.set_text("+ " + str(battle_points[scarcity]))
	$PointImage.visible = true

func _display_card():
	get_node(".").visible = true
