extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $rectangleofcolor
@onready var animation_player = $playerofanimations

func _ready():
	print_tree()
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fade_to_red":
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false
	
func transition():
	color_rect.visible = true
	animation_player.play("fade_to_red")
