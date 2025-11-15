extends Node2D

var is_attacking = false

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D

func _process(delta):
	#for flipping
	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true
	if is_attacking:
		return
	
	#movement animation
	if not is_attacking:
		if abs(player_controller.velocity.x) > 0.0:
			animation_player.play("movement")
		elif abs(player_controller.velocity.y) > 0.0:
			animation_player.play("jump")
		else:
			animation_player.play("idle")
		
	if Input.is_action_just_pressed("attack"):
		attack()
		
func attack():
	print("attack")
	
	var overlapping_object = get_parent().get_node("AttackArea").get_overlapping_bodies()
	for area in overlapping_object:
		if area.is_in_group("crawler"):
			var parent = area.get_parent()
			print(parent.name)

	is_attacking = true
	animation_player.play("attack")

func _on_attack_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false
