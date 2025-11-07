extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D


func _process(delta):
	#for flipping
	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true
	
	#movement animation
	if abs(player_controller.velocity.x) > 0.0:
		animation_player.play("movement")
		print("move")
	#idle animation
	elif abs(player_controller.velocity.x) == 0.0:
		animation_player.play("idle")
		print("idle")
	if abs(player_controller.velocity.y) < 0.0:
		animation_player.play("jump")
		print("jump")
