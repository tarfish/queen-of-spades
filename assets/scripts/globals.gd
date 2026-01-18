extends Node

var max_health := 100
var current_health := 100
var spades := 0

func _ready():
	reset_spades()

func reset_spades():
	spades = 0

func reset_player_stats():
	current_health = max_health

func add_spade():
	spades += 1
	if spades >= 3:
		var portal := get_tree().get_first_node_in_group("portal") as Portal
		if portal:
			portal.open()

func reset_area():
	reset_spades()
