extends Area2D
class_name Portal

@export var sprite: Sprite2D
@export var rotation_speed: float = 2.0

var area_path := "res://assets/scenes/areas/"
var is_open := false

func _ready():
	close()
	body_entered.connect(_on_body_entered)

func open():
	is_open = true
	sprite.region_rect.position.x = 32

func close():
	is_open = false
	sprite.region_rect.position.x = 0

func _process(delta: float) -> void:
	rotation += rotation_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if is_open and body.is_in_group("player"):
		next_level()

func next_level():
	GameState.current_area += 1
	var full_path = area_path + "area_" + str(GameState.current_area) + ".tscn"
	get_tree().change_scene_to_file(full_path)
