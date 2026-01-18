extends Area2D
class_name Portal

@export var sprite : Sprite2D
@export var rotation_speed: float = 2.0

var is_open = false

func _ready():
	close()

func open():
	is_open = true
	sprite.region_rect.position.x = 32
	
func close():
	is_open = false
	sprite.region_rect.position.x = 0

func _on_area_2d_body_entered(body):
	if is_open && body.is_in_group("player"):
		pass

func _process(delta: float) -> void:
	rotation += rotation_speed * delta
