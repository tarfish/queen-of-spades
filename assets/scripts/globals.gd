extends Node

var max_health := 100
var current_health := 100

func reset_player_stats():
	current_health = max_health

func _input(event: InputEvent):
	if event.is_action_pressed("r") and OS.is_debug_build():
		get_tree().reload_current_scene.call_deferred()
