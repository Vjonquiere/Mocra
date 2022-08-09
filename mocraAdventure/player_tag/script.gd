extends Control

var node

# Called when the node enters the scene tree for the first time.
func _ready():
	print("player_tag init")

func set_name(name:String) -> void:
	$Profile/NameLabel.set_text(name)

func set_profile_pic(path:String) -> void:
	pass

func play_loading_anim() -> void:
	$LoadingSprite.visible = true
	$ReadyTexture.visible = false
	$AnimationPlayer.play("loading")

func stop_loading_anim() -> void:
	$LoadingSprite.visible = false
	$ReadyTexture.visible = true
	$AnimationPlayer.stop()

func toggle_ready_state(state):
	if state:
		$ReadyTexture.set_texture(load("res://mocraAdventure/player_tag/ready.png"))
	else:
		$ReadyTexture.set_texture(load("res://mocraAdventure/player_tag/not_ready.png"))

func set_new_card(card_usage:String, card_name:String, amount:String) -> void:
	match card_usage:
		"character":
			node = "Selection/Character"
		"object1":
			node = "Selection/Object1"
		"object2":
			node = "Selection/Object2"
		"object3":
			node = "Selection/Object3"

	get_node(node + "/Avatar").set_texture(load("res://cards/avatar/{path}.png".format({"path":card_name})))
	get_node(node + "/CardNameLabel").set_text(card_name)
	get_node(node + "/AmountLabel").set_text(amount)
