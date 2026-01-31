extends Control


func _on_startbutton_pressed() -> void:
	print ("game started")
	get_tree().change_scene_to_file("res://assets/scenes/areas/area_1.tscn")

func _on_quitbutton_pressed() -> void:
	print ("game quit")
	get_tree().quit()

func _on_optionsbutton_pressed() -> void:
	print ("opened options")
