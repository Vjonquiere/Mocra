class_name Player

var player_name = ""
var MocraID = 0
var rcpID = 0

var character = null
var objects = null

var current_position = [0,0]

## SELF ???


func init(player_name:String, MocraID, rcpID):
	self.player_name = player_name
	self.MocraID = MocraID
	self.rcpID = rcpID

func get_rcpID():
	return self.rcpID

func set_character(character_cardID):
	character = character_cardID

func set_objects(objects_cardIDs:Array):
	objects = objects_cardIDs

func load
