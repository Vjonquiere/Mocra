extends CanvasLayer

signal remove_blur()

func _ready():
	$lifeBars/l1.set_type("life")

func first_objective(title, subhead):
	$Control.first_objective(title,subhead)

func next_objective(title, subhead):
	$Control.next_objective(title,subhead)

func set_offensive_progress_value(value):
	$offensiveProgress.set_progress_value(value)

func set_offensive_progress_max_value(value):
	$offensiveProgress.set_progress_max(value)


func _on_optionsButton_pressed():
	get_node(".").add_child(load("res://mocraClassic/parameters/Control.tscn").instance())
	$blur.visible = true


func _on_CanvasLayer_remove_blur():
	$blur.visible = false
