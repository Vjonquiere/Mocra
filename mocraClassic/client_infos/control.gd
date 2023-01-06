extends Control


onready var credits_widget = $credits/Control
onready var shiny_credits_widget = $shinyCredits/Control
onready var default_position = {$credits/Control: $credits/Control.get_position(), $shinycredits/Control: $shinyCredits/Control.get_position()}
# Called when the node enters the scene tree for the first time.
func _ready():
	#$credits/Control.add_credits(5000)
	pass

func set_credits(amount):
	set_animation_position(str(amount), credits_widget)
	if int(amount) < int(self.get_credits()):
		self.remove_credits(abs(int(amount)-int(self.get_credits())))
	elif int(amount) > int(self.get_credits()):
		self.add_credits(abs(int(amount)-int(self.get_credits())))
	$credits/creditsLabel.set_text(str(amount))

func get_credits():
	return $credits/creditsLabel.get_text()

func set_shiny_cedits(amount):
	set_animation_position(str(amount), shiny_credits_widget)
	$shinyCredits/shinyCreditsLabel.set_text(str(amount))

func set_boost(boost):
	$boost/boostLabel.set_text(str(boost))

func add_credits(amount):
	$credits/Control.add_credits(amount)

func remove_credits(amount):
	$credits/Control.remove_credits(amount)

func set_animation_position(label, node):
	if len(label) > 6:
		node.set_position(Vector2(default_position[node][0]-40*(len(label)-6), default_position[node][1]))
