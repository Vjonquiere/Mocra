extends Control

## WORKING WITH MAX 7 CHARACTERS

var player_name

onready var player_label = $backgroundTexture/playerNameLabel
onready var animation_player = $AnimationPlayer

func _ready():
	player_label.set_text(player_name)

func setup(player_name:String):
	self.player_name = player_name
	return self

func has_animation(animation_name:String):
	return animation_player.has_animation(animation_name)

func play_animation(animation_name:String):
	if has_animation(animation_name):
		animation_player.play(animation_name)

func delete():
	animation_player.play("delete")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "delete":
		self.queue_free()
