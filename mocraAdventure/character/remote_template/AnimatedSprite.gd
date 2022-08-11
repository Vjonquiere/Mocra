extends AnimatedSprite

func _on_AnimatedSprite_animation_finished():
	get_parent().emit_signal("anim_playing_finished")
