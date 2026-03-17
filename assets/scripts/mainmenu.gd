extends Control

@onready var buttons: VBoxContainer = $buttons
@onready var options: Panel = $options

func _ready() -> void:
	options.visible = false
	buttons.visible = true

func _on_startbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/areas/area_1.tscn")

func _on_quitbutton_pressed() -> void:
	get_tree().quit()

func _on_optionsbutton_pressed() -> void:
	buttons.visible = false
	options.visible = true

func _on_optionsquitbutton_pressed() -> void:
	buttons.visible = true
	options.visible = false


func _on_musicvolume_value_changed(value: float) -> void:
	pass
