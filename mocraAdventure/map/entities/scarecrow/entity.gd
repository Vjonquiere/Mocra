extends StaticBody2D

var id


func play_animation(animation_name:String):
	if $AnimationPlayer.has_animation(animation_name):
		$AnimationPlayer.play(animation_name)

func set_id(new_id):
	id = new_id

func get_id():
	return id
