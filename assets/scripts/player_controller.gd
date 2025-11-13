extends CharacterBody2D
class_name PlayerController

@export var speed = 5.0
@export var jump_power = 6
@export var Jump_Buffer_Timer: float = 0.1
@export var Coyote_Time: float = 0.5
@export var High_jump_time: float = 0.2
@export var min_knockback := 100
@export var slow_knockback := 1.1

var speed_multiplier = 27.0
var jump_multiplier = -33.0
var direction = 0
var Jump_Buffer: bool = false
var Jump_Available: bool = true
var Jump_jump_timer = 0
var health = 100
var knockback = Vector2(150,150)

@onready var heart1 = $UI/Hearts/HBoxContainer/Heart
@onready var heart2 = $UI/Hearts/HBoxContainer/Heart2
@onready var heart3 = $UI/Hearts/HBoxContainer/Heart3
@onready var heart4 = $UI/Hearts/HBoxContainer/Heart4
@onready var heart5 = $UI/Hearts/HBoxContainer/Heart5
@onready var animationplayer = $PlayerAnimator/AnimationPlayer
@onready var hurttimer = $Timer
@onready var camera = $Camera2D
@onready var transition = $transition_screen

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if Jump_Available:
			get_tree().create_timer(Coyote_Time).timeout.connect(Coyote_Timeout)
		velocity += get_gravity() * delta
	else:
		Jump_Available = true
		if Jump_Buffer:
			Jump()
			Jump_Buffer = false

	if Input.is_action_just_pressed("jump"):
		if Jump_Available:
			Jump_Available = false
			Jump()
			Jump_jump_timer = High_jump_time
		else:
			Jump_Buffer = true
			get_tree().create_timer(Jump_Buffer_Timer).timeout.connect(on_jump_buffer_timeout)

	if Input.is_action_pressed("jump"):
		if Jump_jump_timer > 0:
			velocity -= get_gravity() * delta * 0.5
			Jump_jump_timer -= delta
	else:
		Jump_jump_timer = 0

	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed * speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)

	if knockback.length() > min_knockback:
		knockback /= slow_knockback
		velocity = knockback
		move_and_slide()
		return

	move_and_slide()

func Jump() -> void:
	velocity.y = jump_power * jump_multiplier
	Jump_Available = false

func on_jump_buffer_timeout() -> void:
	Jump_Buffer = false

func Coyote_Timeout() -> void:
	Jump_Available = false

func reduce_health() -> void:
	health -= 20
	camera.screen_shake(6, 0.1)
	get_tree().create_timer(0.5).timeout.connect(_on_timer_timeout)
	animationplayer.play("hurt")

	if health == 80:
		heart1.hide()
	elif health == 60:
		heart2.hide()
	elif health == 40:
		heart3.hide()
	elif health == 20:
		heart4.hide()
	elif health == 0:
		heart5.hide()
		await handle_death()

func handle_death() -> void:
	await transition.transition()
	Globals.reset_player_stats()
	get_tree().reload_current_scene()
	await transition.on_transition_finished

func _on_timer_timeout() -> void:
	animationplayer.play("idle")
