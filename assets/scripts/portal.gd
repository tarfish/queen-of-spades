extends Area2D
class_name Portal

@export var sprite: Sprite2D
@export var rotation_speed: float = 2.0

@onready var transition = $transition_screen

var area_path := "res://assets/scenes/areas/"
var is_open := false

func _ready():
	close()
	body_entered.connect(_on_body_entered)

	Globals.spades_changed.connect(_on_spades_changed)

	if Globals.spades >= 3:
		open()

func _on_spades_changed(value):
	if value >= 3:
		open()

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
	Globals.reset_area()

	var full_path = area_path + "area_" + str(GameState.current_area) + ".tscn"
	await transition.transition()
	await transition.on_transition_finished
	get_tree().change_scene_to_file(full_path)
