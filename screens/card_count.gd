extends Control

var player: Player


func _process(delta):
	$Label.text = str(player.card_count)
