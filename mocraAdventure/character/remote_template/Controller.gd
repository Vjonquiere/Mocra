extends KinematicBody2D

signal anim_playing_finished()

var anim_playing = false


func _ready():
	set_collision("res://mocraAdventure/character/debug/CollisionShape.tres")
	set_sprite_sheet("res://mocraAdventure/character/debug/SpriteFrame.tres")
#	$AnimatedSprite.get_sprite_frames().set_animation_loop("walk", false)


func move(new_pos):
	var current_pos = self.get_position()
	$Label.set_text("pos (" + str(round(new_pos[0])) + "," + str(round(new_pos[1])) + ")")
#	move_and_slide(new_pos)
#	translate(new_pos)
	self.set_position(new_pos)
	$AnimatedSprite.play("walk")
	if round(current_pos[0]) == round(new_pos[0]) and round(current_pos[1]) == round(new_pos[1]):
		$AnimatedSprite.play("idle")

func offensive_1():
	$AnimatedSprite.play("offensive_1")

func set_collision(collision_shape_path:String) -> void:
	$CollisionShape2D.set_shape(load(collision_shape_path))

func set_sprite_sheet(sprite_shape_path:String) -> void:
	$AnimatedSprite.set_sprite_frames(load(sprite_shape_path))
	$AnimatedSprite.play("idle")


func _on_CharacterController_anim_playing_finished():
	anim_playing = false
