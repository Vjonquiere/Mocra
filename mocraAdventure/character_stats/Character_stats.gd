extends Node2D


func _ready():
	$".".set_position(Vector2(150,400))
	change_card_type("TANK")
	change_stats(60,40,70,95)

func get_card_stats(id, card_type):
	var req = "get_MA_card_infos/" + str(id) + "/" + card_type
	Networking.send_data(req)
	var res = yield(Networking.waiting_for_server("/"), "completed")
	change_stats(int(res[2]), int(res[3]), int(res[4]), int(res[5]))
	change_card_type(res[6])

func change_stats(HP:int, ExL:int, Spd:int, Dam:int) -> void:
	$HPLabel/TextureProgress.value = HP
	$ExLLabel/TextureProgress.value = ExL
	$SpdLabel/TextureProgress.value  = Spd
	$DamLabel/TextureProgress.value = Dam

func change_card_type(type:String) -> void:
	$TypeLabel.set_text(type)
