extends Node2D

@export var player_controller: PlayerController
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D

func _process(delta):
	sprite.flip_h = player_controller.direction == -1

	if abs(player_controller.velocity.x) > 0.0:
		animation_player.play("movement")
	elif abs(player_controller.velocity.y) > 0.0:
		animation_player.play("jump")
	else:
		animation_player.play("idle")
