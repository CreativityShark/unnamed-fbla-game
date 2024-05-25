class_name State
extends Node


func handle_input(_player: Player):
	pass


func on_enter(_player: Player):
	pass


func on_exit(_player: Player):
	pass


func animate(sprite: Node, _player: Player):
	assert(sprite.name == "AnimatedSprite2D")
