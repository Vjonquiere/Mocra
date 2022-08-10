extends KinematicBody2D

signal anim_playing_finished()
export (int) var speed = 200

var velocity = Vector2()
var anim_playing = false

func get_input():
	velocity = Vector2()
	if Input.is_action_just_pressed("offensive"):
		$AnimatedSprite.play("offensive_1")
		anim_playing = true
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down"):
		velocity.x += 1
		velocity.y += 1
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up"):
		velocity.x += 1
		velocity.y -= 1
		$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down"):
		velocity.x -= 1
		velocity.y += 1
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


func _on_KinematicBody2D_anim_playing_finished():
	anim_playing = false
