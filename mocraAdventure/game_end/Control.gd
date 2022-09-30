extends Control


onready var playerTags = [$playerTag1, $playerTag2, $playerTag3]
var cardTypes = ["character", "object1", "object2", "object3", "ground"]
# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.current = true

#room_stats = {"completed_objectives": 50/75/100 "player_array": [rpc_ids] "player_id":{"cards": card_dict "name": player_name}}

func init(level_name, room_stats):
	$AnimationPlayer/.play("display")
	$nameLabel.set_text(level_name)
	match room_stats["completed_objectives"]:
		50:
			print("level finished at 50% ")
		75:
			print("level finished at 75% ")
		100:
			print("level finished at 100% ")

	for i in range(len(room_stats["player_array"])):
		var current_rpc_id = room_stats["player_array"][i]
		playerTags[i].set_name(room_stats[current_rpc_id]["name"])
		{"character":["Wood", "1"], "object1":["Flamingo", "1"] ,"object2":["Cow", "1"] , "object3":["Snake", "1"] , "ground":["Phantom", "1"]}
		for j in range(len(cardTypes)):
			playerTags[i].set_new_card(cardTypes[j], room_stats[current_rpc_id]["cards"][cardTypes[j]][0], room_stats[current_rpc_id]["cards"][cardTypes[j]][1])

 
func _on_quitButton_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
