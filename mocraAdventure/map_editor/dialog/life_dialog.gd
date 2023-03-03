extends Control


onready var life_value = [$DefLifeLabel/DefLifeSpinBox.get_value(), $maxLifeLabel/maxLifeSpinBox.get_value()]


func _ready():
	pass # Replace with function body.

func _on_maxLifeSpinBox_value_changed(value):
	life_value[1] = value

func _on_DefLifeSpinBox_value_changed(value):
	life_value[0] = value

func _on_leaveButton_pressed():
	get_parent().emit_signal("close_dialog", [null])
	self.queue_free()

func _on_editButton_pressed():
	get_parent().emit_signal("close_dialog", life_value)
