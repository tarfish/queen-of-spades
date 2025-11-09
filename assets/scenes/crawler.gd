extends CharacterBody2D

@export var player: CharacterBody2D
@export var speed: int = 50
@export var chase_speed: int = 50
@export var acceleration: int = -30
@export var knockback := 1000

@onready var sprite: AnimatedSprite2D = $sprite
@onready var raycast: RayCast2D = $sprite/RayCast2D
@onready var timer: Timer = $Timer
@onready var raycast2: RayCast2D = $sprite/RayCast2D2

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2

enum states {
	wander,
	chase
}
var current_state = states.wander

func _ready():
	left_bounds = self.position + Vector2(-10,0)
	right_bounds = self.position + Vector2(10,0)
	
func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)
	change_direction()
	look_for_player()

func look_for_player():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider == player:
			chase_player()
		elif current_state == states.chase:
			stop_chase()
	elif current_state == states.chase:
		stop_chase()

func chase_player() -> void:
	timer.stop()
	current_state = states.chase
	
func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()

func handle_movement(delta: float) -> void:
	if current_state == states.wander:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(direction * chase_speed, acceleration * delta)
		
	move_and_slide()

func change_direction() -> void:
	if current_state == states.wander:
		if sprite.flip_h:
			if self.position.x <= right_bounds.x:
				direction = Vector2(1,0)
				acceleration = 100
				raycast2.enabled = true
			else:
				sprite.flip_h = false
				raycast.target_position = Vector2(-35,0)
				acceleration = -100
				raycast2.enabled = false
		else:
			if self.position.x >= left_bounds.x:
				direction = Vector2(1,0)
				acceleration = -100
				raycast.enabled = true
			else:
				sprite.flip_h = true
				raycast.target_position = Vector2(35,0)
				acceleration = 100
				raycast.enabled = false
	else:
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		if direction.x == 1:
			sprite.flip_h = true
			acceleration = -100
		else:
			sprite.flip_h = false
			acceleration = 100
			
func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity + delta

func _on_timer_timeout() -> void:
	current_state = states.wander

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		body.reduce_health()
		print (body.health)
		body.knockback = position.direction_to(body.position) * knockback
