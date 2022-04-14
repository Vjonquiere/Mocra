extends Node

class_name Pile

var array = []

func _init() -> void:
	print("Pile initied")

func stack(object) -> void:
	array.append(object)

func unstack():
	return array.pop_back()

func isEmpty() -> bool:
	print(array)
	if len(array) == 0:
		return true
	else:
		return false
