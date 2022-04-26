extends KinematicBody2D

onready var SM = $StateMachine
onready var VP = get_viewport_rect()

var velocity = Vector2.ZERO
var jump_power = Vector2.ZERO
var direction = 1
var atking = false
var health = 20

export var gravity = Vector2(0,30)

export var move_speed = 20
export var max_move = 300

export var jump_speed = 100

export var max_jump = 1200

export var leap_speed = 100
export var max_leap = 1200


var moving = false
var is_jumping = false


func _ready():
	pass


func _physics_process(_delta):
	velocity.x = clamp(velocity.x,-max_move,max_move)
	if Input.is_action_pressed("attack"):
		set_animation("Attacking")
		atking = true
		$Area2D/Atk.set_deferred("disabled", false)

	if direction < 0 and not $AnimatedSprite.flip_h: $AnimatedSprite.flip_h = true
	if direction > 0 and $AnimatedSprite.flip_h: $AnimatedSprite.flip_h = false
	
	if position.y > Global.death_zone:
		die()
		

func is_moving():
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		return true
	return false

func move_vector():
	return Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),1.0)

func _unhandled_input(event):
	if event.is_action_pressed("left"):
		direction = -1
	if event.is_action_pressed("right"):
		direction = 1

func set_animation(anim):
	if $AnimatedSprite.animation == anim: return
	if $AnimatedSprite.frames.has_animation(anim): $AnimatedSprite.play(anim)
	else: $AnimatedSprite.play()

func die():
	var _target = get_tree().change_scene("res://Menu/Death.tscn")

func damage(d):
	health -= d
	if health <= 0:
		die()

func _on_AnimatedSprite_animation_finished():
	if atking == true:
		set_animation("Idle")
		atking = false
		$Area2D/Atk.set_deferred("disabled", true)



func _on_Area2D_body_entered(body):
	if atking == true and body.name != "Bullet":
		body.damage  (1)
	else: pass
