extends Node2D

var map_infos
var map

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func test(map_path:String):
	print("GAME MASTER INITIED")
	map_infos = Map.new()
	map_infos.load_map(map_path)
	map = MapConstrucor.new()
	map.set_map(map_infos)
	map.load_tileSet()
	$".".add_child(map.displayMap())

func _init():
	test("res://mocraAdventure/map/map1.json")

