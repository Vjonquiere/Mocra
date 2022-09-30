extends CanvasLayer

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
