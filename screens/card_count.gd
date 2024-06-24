extends Control

var player: Player


func _process(delta):
	$ColorRect/Label.text = str(player.card_count)
