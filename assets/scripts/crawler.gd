extends CharacterBody2D

@export var player: CharacterBody2D
@export var speed := 50.0
@export var chase_speed := 90.0
@export var acceleration := 300.0
@export var knockback := 250.0
@export var patrol_left_distance: float = 32.0
@export var patrol_right_distance: float = 32.0

@onready var sprite: AnimatedSprite2D = $sprite
@onready var raycast: RayCast2D = $sprite/RayCast2D
@onready var timer: Timer = $Timer

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := Vector2.LEFT
var left_bounds: float
var right_bounds: float

enum State { WANDER, CHASE }
var state := State.WANDER

func _ready():
	left_bounds = position.x - patrol_left_distance
	right_bounds = position.x + patrol_right_distance

func _physics_process(delta):
	handle_gravity(delta)
	update_state()
	update_direction()
	move_enemy(delta)

func update_state():
	if raycast.is_colliding() and raycast.get_collider() == player:
		state = State.CHASE
		timer.stop()
	elif state == State.CHASE and timer.is_stopped():
		timer.start()

func update_direction():
	if state == State.WANDER:
		if position.x <= left_bounds:
			direction = Vector2.RIGHT
		elif position.x >= right_bounds:
			direction = Vector2.LEFT
	else:
		direction.x = sign(player.position.x - position.x)
		direction.y = 0

	sprite.flip_h = direction.x > 0

func move_enemy(delta):
	var target_speed = chase_speed if state == State.CHASE else speed
	var target_velocity = Vector2(direction.x * target_speed, velocity.y)
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	move_and_slide()

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _on_timer_timeout():
	state = State.WANDER

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.reduce_health()
		body.knockback = position.direction_to(body.position) * knockback
