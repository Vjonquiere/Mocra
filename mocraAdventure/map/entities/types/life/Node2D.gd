extends Node2D


var max_health = 100
var min_health = 0
var health = max_health

func _ready():
	pass

func set_max_health(new_max_health:int):
	max_health = new_max_health
	health = new_max_health
	$healBar.value = new_max_health

func remove_health(amount:int):
	health -= amount
	$healBar.value -= amount

func add_health(amount:int):
	health += amount
	$healBar.value += amount

func link_entity(entity_path):
	var entity = load(entity_path).instance()
	$".".add_child(entity)
