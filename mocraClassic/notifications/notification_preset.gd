extends Control

var child
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(preset_path, notification):
	if preset_path == "res://mocraClassic/notifications/friend/preset.tscn":
		if notification[0] == "friend_request":
			child = load(preset_path).instantiate().setup(str(notification[1]))
		else:
			child = load(preset_path).instantiate().setup(str(notification[1]), "refused")
	elif preset_path == "res://mocraClassic/notifications/cards/preset.tscn":
		child = load(preset_path).instantiate().setup(str(notification[1]), str(notification[2]), str(notification[3]))
	$backgroundTexture.add_child(child)
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
		child.queue_free()
		self.queue_free()
