extends KinematicBody2D

signal anim_playing_finished()
export (int) var speed = 200

var velocity = Vector2()
var anim_playing = false

func _ready():
	set_collision("res://mocraAdventure/character/debug/CollisionShape.tres")
	set_sprite_sheet("res://mocraAdventure/character/debug/SpriteFrame.tres")



func set_collision(collision_shape_path:String) -> void:
	$CollisionShape2D.set_shape(load(collision_shape_path))

func set_sprite_sheet(sprite_shape_path:String) -> void:
	$AnimatedSprite.set_sprite_frames(load(sprite_shape_path))
	$AnimatedSprite.play("idle")


func get_input():
	velocity = Vector2()
	if Input.is_action_just_pressed("offensive"):
		$AnimatedSprite.play("offensive_1")
		anim_playing = true
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down"):
		velocity.x += 1
		velocity.y += 1
		$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up"):
		velocity.x += 1
		velocity.y -= 1
		$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down"):
		velocity.x -= 1
		velocity.y += 1
		$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up"):
		velocity.x -= 1
		velocity.y -= 1
		$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("ui_right"):
		velocity.x += 1
		$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
		$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idle")
	velocity = velocity.normalized() * speed


func _physics_process(delta):
	if anim_playing != true:
		get_input()
		velocity = move_and_slide(velocity)
		var pos = self.get_position()
		$Label.set_text("pos (" + str(round(pos[0])) + "," + str(round(pos[1])) + ")")
		get_parent().move(self.get_position())


func _on_CharacterController_anim_playing_finished():
	anim_playing = false
