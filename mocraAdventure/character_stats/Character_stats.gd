extends Node2D


func _ready():
	$".".set_position(Vector2(150,400))
	change_card_type("TANK")
	change_stats(60,40,70,95)


func change_stats(HP:int, ExL:int, Spd:int, Dam:int) -> void:
	$HPLabel/TextureProgress.value = HP
	$ExLLabel/TextureProgress.value = ExL
	$SpdLabel/TextureProgress.value  = Spd
	$DamLabel/TextureProgress.value = Dam

func change_card_type(type:String) -> void:
	$TypeLabel.set_text(type)
