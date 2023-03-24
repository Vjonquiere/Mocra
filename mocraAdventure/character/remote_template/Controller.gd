extends CharacterBody2D

signal anim_playing_finished()

var anim_playing = false
var idle = true

func _ready():
	set_collision("res://mocraAdventure/character/debug/CollisionShape3D.tres")
	set_sprite_sheet("res://mocraAdventure/character/debug/SpriteFrame.tres")
#	$AnimatedSprite2D.get_sprite_frames().set_animation_loop("walk", false)


func move(new_pos):
	var current_pos = self.get_position()
	$Label.set_text("pos (" + str(round(new_pos[0])) + "," + str(round(new_pos[1])) + ")")
set_velocity(new_pos)
move_and_slide()
#	velocity
#	translate(new_pos)
	self.set_position(new_pos)
	if !anim_playing:
		if round(current_pos[0]) == round(new_pos[0]) and round(current_pos[1]) == round(new_pos[1]) and idle == false:
			idle = true
			$AnimatedSprite2D.play("idle")
		if round(current_pos[0]) != round(new_pos[0]) or round(current_pos[1]) != round(new_pos[1]):
			idle = false
			$AnimatedSprite2D.play("walk")

func offensive_1():
	idle = false
	anim_playing = true
	$AnimatedSprite2D.play("offensive_1")
	$AnimatedSprite2D.set_frame(0)

func set_collision(collision_shape_path:String) -> void:
	$CollisionShape2D.set_shape(load(collision_shape_path))

func set_sprite_sheet(sprite_shape_path:String) -> void:
	$AnimatedSprite2D.set_sprite_frames(load(sprite_shape_path))
	$AnimatedSprite2D.play("idle")


func _on_CharacterController_anim_playing_finished():
	anim_playing = false
