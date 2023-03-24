extends TextureRect

var middle = 250
var pos = null
var center = Vector2(250, 250)

var last_action = null
var current_action = ["idle"]

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func distance(x, y):
	if x[0] > y[0]:
		return sqrt(pow((x[0]-y[0]),2) + pow((x[1]-y[1]),2))
	else:
		return sqrt(pow((y[0]-x[0]),2) + pow((y[1]-x[1]),2))


func _on_UnderTexture_gui_input(event):
	if event is InputEventScreenDrag:
		pos = event.get_position()
#		if sqrt(pow((middle-pos[0]),2) + pow((middle-pos[1]),2)) <= 500:
		if distance(center, pos) <= 250:
#			if pos[0] <= 500 and pos[0] >= 0 and pos[1] <= 500 and pos[1] >= 0:
			$movableTexture.set_position(Vector2(pos[0]-115/2, pos[1]-115/2))
			move()
	elif event is InputEventScreenTouch:
		if event.button_pressed == true:
			move()
		else:
			pos = center
			$movableTexture.set_position(Vector2(middle-115/2, middle-115/2))
			move()

func move():
	if pos == null:
		return
	var direction = Vector2(0,0)
	if pos[0] > middle + 50:
		direction[0] = 1
	if pos[0] < middle - 50:
		direction[0] = -1
	if pos[1] < middle - 50:
		direction[1] = -1
	if pos[1] > middle + 50:
		direction[1] = 1
	match direction:
		Vector2(0,0):
			current_action = ["idle"]
		Vector2(1,0):
			current_action = ["ui_right"]
		Vector2(-1,0):
			current_action = ["ui_left"]
		Vector2(0,1):
			current_action = ["ui_down"]
		Vector2(0, -1):
			current_action = ["ui_up"]
		Vector2(1,1):
			current_action = ["ui_down", "ui_right"]
		Vector2(1,-1):
			current_action = ["ui_up", "ui_right"]
		Vector2(-1,1):
			current_action = ["ui_down", "ui_left"]
		Vector2(-1,-1):
			current_action = ["ui_up", "ui_left"]
	if last_action != current_action && last_action != null && last_action[0] != "idle":
		for i in range(len(last_action)):
			Input.action_release(last_action[i])
	if current_action[0] != "idle" && current_action != last_action:
		for i in range(len(current_action)):
			Input.action_press(current_action[i])
	last_action = current_action
	
