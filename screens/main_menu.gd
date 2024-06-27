extends Control

var quit: Callable
var wipe


func _on_start_button_pressed():
	$ButtonSFX.play()
	await wipe.start_wipe()
	get_tree().paused = false
	self.hide()
	await wipe.finish_wipe()


func _on_quit_button_pressed():
	$ButtonSFX.play()
	await wipe.start_wipe()
	quit.call()


func _on_controls_button_pressed():
	$ButtonSFX.play()
	$ControlsWindow.set_visible(not $ControlsWindow.is_visible())
