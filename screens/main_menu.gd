extends Control

var quit: Callable
var wipe


func _on_start_button_pressed():
	await wipe.start_wipe()
	get_tree().paused = false
	self.hide()
	await wipe.finish_wipe()


func _on_quit_button_pressed():
	quit.call()
