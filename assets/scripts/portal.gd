extends Area2D
class_name portal

@export var sprite : Sprite2D

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
