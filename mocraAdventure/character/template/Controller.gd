extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision("res://mocraAdventure/character/debug/CollisionShape.tres")
	set_sprite_sheet("res://mocraAdventure/character/debug/SpriteFrame.tres")

func set_collision(collision_shape_path:String) -> void:
	$KinematicBody2D/CollisionShape2D.set_shape(load(collision_shape_path))

func set_sprite_sheet(sprite_shape_path:String) -> void:
	$KinematicBody2D/AnimatedSprite.set_sprite_frames(load(sprite_shape_path))
	$KinematicBody2D/AnimatedSprite.play("idle")
