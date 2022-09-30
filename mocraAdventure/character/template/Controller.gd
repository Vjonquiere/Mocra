extends KinematicBody2D

signal anim_playing_finished()
export (int) var speed = 200

var velocity = Vector2()
var anim_playing = false

var offensive_timer = Timer.new()
var offensive_cooldown_active = false

func _ready():
	set_collision("res://mocraAdventure/character/debug/CollisionShape.tres")
	set_sprite_sheet("res://mocraAdventure/character/debug/SpriteFrame.tres")
	$".".add_child(offensive_timer)
	offensive_timer.connect("timeout", self, "_on_offensive_timeout")
	offensive_timer.set_wait_time(1.0) ## AUTOMATISATION 

func is_player():
	return true

func set_collision(collision_shape_path:String) -> void:
	$CollisionShape2D.set_shape(load(collision_shape_path))

func set_sprite_sheet(sprite_shape_path:String) -> void:
	$AnimatedSprite.set_sprite_frames(load(sprite_shape_path))
	$AnimatedSprite.play("idle")


func get_input():
	var anim_to_play = null
	velocity = Vector2()
	if Input.is_action_just_pressed("offensive") and offensive_cooldown_active == false:
		print("timer starting")
		offensive_cooldown_active = true
		offensive_timer.start()
		offensive_1()
		$offensive1Area/offensive1CollisionShape.disabled = false
		$AnimatedSprite.play("offensive_1")
		anim_playing = true
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down"):
		velocity.x += 1
		velocity.y += 1
		anim_to_play = "walk"
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up"):
		velocity.x += 1
		velocity.y -= 1
		anim_to_play = "walk"
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down"):
		velocity.x -= 1
		velocity.y += 1
		anim_to_play = "walk"
	elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up"):
		velocity.x -= 1
		velocity.y -= 1
		anim_to_play = "walk"
	elif Input.is_action_pressed("ui_right"):
		velocity.x += 1
		anim_to_play = "walk"
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		anim_to_play = "walk"
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
		anim_to_play = "walk"
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		anim_to_play = "walk"
	else:
		anim_to_play = "idle"
	if !anim_playing:
		$AnimatedSprite.play(anim_to_play)
	velocity = velocity.normalized() * speed


func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	var pos = self.get_position()
	$Label.set_text("pos (" + str(round(pos[0])) + "," + str(round(pos[1])) + ")")
	get_parent().move(self.get_position())
	if !offensive_timer.is_stopped():
		get_parent().update_offensive_remaining_cooldown(offensive_timer.get_time_left())

func offensive_1():
	get_parent().offensive_1()

func _on_CharacterController_anim_playing_finished():
	$offensive1Area/offensive1CollisionShape.disabled = true
	anim_playing = false

func _on_offensive1Area_body_entered(body):
	if !(body is KinematicBody2D):
		get_parent().entity_hurt(body.get_id())

func _on_offensive_timeout():
	print("timeout")
	offensive_cooldown_active = false
	offensive_timer.stop()

func set_current_camera(state):
	$Camera2D.current = state
