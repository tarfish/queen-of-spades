extends CharacterBody2D
class_name PlayerController

@export var speed = 10.0
@export var jump_power = 10.0
@export var Jump_Buffer_Timer: float = 0.1
@export var Coyote_Time: float = 0.5

var speed_multiplier = 30.0
var jump_multiplier = -30.0
var direction = 0
var Jump_Buffer: bool = false
var Jump_Available: bool = true


func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		if Jump_Available:
			get_tree().create_timer(Coyote_Time).timeout.connect(Coyote_Timeout)
		velocity += get_gravity() * delta
	else:
		Jump_Available = true

		if Jump_Buffer:
			Jump()
			Jump_Buffer = false

	# Handle jump
	if Input.is_action_just_pressed("jump") and Jump_Available:
		Jump_Available = false
		Jump()
	else:
		Jump_Buffer = true
		get_tree().create_timer(Jump_Buffer_Timer).timeout.connect(on_jump_buffer_timeout)

	# Handle movement
	direction = Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * speed * speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_multiplier)

	move_and_slide()


func Jump() -> void:
	velocity.y = jump_power * jump_multiplier
	Jump_Available = false


func on_jump_buffer_timeout() -> void:
	Jump_Buffer = false


func Coyote_Timeout() -> void:
	Jump_Available = false
