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

func reset_area():
	reset_spades()
	
signal spades_changed

func add_spade():
	spades += 1
	spades_changed.emit(spades)
