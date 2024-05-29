extends Control

var quit: Callable


func _on_start_button_pressed():
	get_tree().paused = false
	self.hide()


func _on_quit_button_pressed():
	quit.call()
