extends Node2D


var max_health = 100
var min_health = 0
var health = max_health
var id
var entity

func _ready():
	pass

func set_max_health(new_max_health:int):
	max_health = new_max_health
	health = new_max_health
	$healBar.value = new_max_health

func remove_health(amount:int):
	health -= amount
	$healBar.value -= amount
	play_animation("hit")

func add_health(amount:int):
	health += amount
	$healBar.value += amount

func link_model(entity_model):
	entity = entity_model

func play_animation(animation_name:String) -> void:
	if entity.has_method("play_animation"):
		entity.play_animation(animation_name)
