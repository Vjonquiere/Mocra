class_name Queue

var array =  []

func _init():
	print("Queue initied")

func _to_string():
	var string = "\n"
	for i in range(len(array)):
		string += str(i) + ")" + str(array[i]) + "\n"
	return string

func enqueue(elt):
	array.append(elt)

func dequeue():
	return array.pop_front()

func get_head():
	if !self.is_empty():
		return array[0]

func is_empty():
	return len(array) == 0
