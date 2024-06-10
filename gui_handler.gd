extends CanvasLayer


# Takes a filepath to the screen to be displayed as input and adds it as a child to the GUI Handler
func display(screen: Control):
	self.add_child(screen)
	assert(screen.is_in_group("screen"))


func get_screen(name: String):
	return self.find_child(name, false, false)


func hide_screen(name: String):
	self.find_child(name, false, false).hide()


func show_screen(name: String):
	self.find_child(name, false, false).show()
