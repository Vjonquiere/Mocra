extends TextureRect

var next_title
var next_subhead

func set_title(title:String):
	$titleLabel.set_text(title)

func set_subhead(subhead:String):
	$subheadLabel.set_text(subhead)

func first_objective(title, subhead):
	set_title(title)
	set_subhead(subhead)

func next_objective(title, subhead):
	next_title = title
	next_subhead = subhead
	$AnimationPlayer.play("objective_completed")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "objective_completed":
		set_title(next_title)
		set_subhead(next_subhead)
		$AnimationPlayer.play("next_objective")
