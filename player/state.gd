class_name State
extends Node


var animation_handler: AnimationHandler


func handle_input(player: Player, delta):
	if not player.is_on_floor():
		player.velocity.y += player.GRAVITY * delta


func on_enter(_player: Player):
	pass


func on_exit(_player: Player):
	pass
