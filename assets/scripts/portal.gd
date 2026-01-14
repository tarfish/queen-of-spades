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

func _on_body_entered(body: Node2D) -> void:
	if is_open:
		pass
