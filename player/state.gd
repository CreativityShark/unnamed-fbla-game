class_name State
extends Node


func handle_input(player: Player, delta):
	if not player.is_on_floor():
		player.velocity.y += player.GRAVITY * delta


func on_enter(_player: Player):
	pass


func on_exit(_player: Player):
	pass


func animate(sprite: Node, _player: Player):
	assert(sprite.name == "AnimatedSprite2D")


func animate_on_enter(sprite: Node, _player: Player):
	assert(sprite.name == "AnimatedSprite2D")
