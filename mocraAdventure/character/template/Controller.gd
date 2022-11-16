extends KinematicBody2D

signal anim_playing_finished()
export (int) var speed = 200

var velocity = Vector2()
var anim_playing = false

var offensive_timer = Timer.new()
var offensive_cooldown_active = false

var object1_timer = Timer.new()
var object1_cooldown_active = false

var object2_timer = Timer.new()
var object2_cooldown_active = false

var object3_timer = Timer.new()
var object3_cooldown_active = false

var usable_entity = null

func _ready():
	set_collision("res://mocraAdventure/character/debug/CollisionShape.tres")
	set_sprite_sheet("res://mocraAdventure/character/debug/SpriteFrame.tres")
	$".".add_child(offensive_timer)
	offensive_timer.connect("timeout", self, "_on_offensive_timeout")
	offensive_timer.set_wait_time(1.0) ## AUTOMATISATION 
	$".".add_child(object1_timer)
	object1_timer.connect("timeout", self, "_on_object1_timeout")
	object1_timer.set_wait_time(1.0) ## AUTOMATISATION 
	$".".add_child(object2_timer)
	object2_timer.connect("timeout", self, "_on_object2_timeout")
	object2_timer.set_wait_time(1.0) ## AUTOMATISATION 
	$".".add_child(object3_timer)
	object3_timer.connect("timeout", self, "_on_object3_timeout")
	object3_timer.set_wait_time(1.0) ## AUTOMATISATION 

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

	if Input.is_action_just_pressed("use") and usable_entity != null:
		anim_to_play = "idle"
		get_parent().entity_use(usable_entity)
	elif Input.is_action_just_pressed("object1") and !object1_cooldown_active:
		anim_to_play = "idle"
		object1_cooldown_active = true
		get_parent().use_object("object1")
		object1_timer.start()
	elif Input.is_action_just_pressed("object2") and !object2_cooldown_active:
		anim_to_play = "idle"
		object2_cooldown_active = true
		get_parent().use_object("object2")
		object2_timer.start()
	elif Input.is_action_just_pressed("object3") and !object3_cooldown_active:
		anim_to_play = "idle"
		object3_cooldown_active = true
		get_parent().use_object("object3")
		object3_timer.start()

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
	if !(body is KinematicBody2D) && body.has_method("get_id"):
		get_parent().entity_hurt(body.get_id())

func _on_offensive_timeout():
	offensive_cooldown_active = false
	offensive_timer.stop()

func _on_object1_timeout():
	object1_cooldown_active = false
	object1_timer.stop()

func _on_object2_timeout():
	object2_cooldown_active = false
	object2_timer.stop()

func _on_object3_timeout():
	object3_cooldown_active = false
	object3_timer.stop()

func set_current_camera(state):
	$Camera2D.current = state


func entity_can_be_used(id):
	usable_entity = id

func entity_cant_be_used(id):
	usable_entity = null
