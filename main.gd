extends Node

@export var current_floor_name: String
var current_level: Level
var save_data = {}


func _ready():
	print("hello world!")
	
	get_tree().paused = true
	
	load_save()
	
	if save_data.has("Cards Collected"):
		$Player.card_count = save_data["Cards Collected"]
	if save_data.has("Current Floor"):
		current_floor_name = save_data["Current Floor"]
	
	change_level(current_floor_name, null)
	
	ready_gui()


func _process(delta):
	if Input.is_action_just_pressed("quit"):
		save()
		get_tree().quit()


# Pre: A file exists at user://epic.save and it is foratted as proper JSON
# Post: save_data will contain data from the save file
func load_save():
	assert(FileAccess.file_exists("user://epic.save"))
	var save_file = FileAccess.open("user://epic.save", FileAccess.READ)
	assert(save_file)
	var json = JSON.new()
	json.parse(save_file.get_as_text())
	print(json.get_error_line())
	print(json.get_error_message())
	if json.get_data() != null:
		save_data = json.get_data()
	save_file.close()


func save():
	save_data["Cards Collected"] = $Player.card_count
	save_data["Current Floor"] = current_floor_name
	save_level_data()
	
	assert(FileAccess.file_exists("user://epic.save"))
	var save_file = FileAccess.open("user://epic.save", FileAccess.WRITE_READ)
	assert(save_file)
	save_file.store_line(JSON.stringify(save_data, "\t"))
	save_file.close()


# pre: 
# post: the data returned by the current level is put into save_data
func save_level_data():
	if current_level != null:
		var data = current_level.get_data_to_save()
		for key in data:
			save_data[key] = data[key]
			
		current_level.queue_free()


func change_level(level_name: String, exit_location):
	var level_path = load("res://levels/" + level_name + ".tscn")
	var level = level_path.instantiate()
	
	save_level_data()
	
	level.player = $Player
	level.change_level = Callable(self, "change_level")
	level.harm_player.connect(Callable(self, "_on_level_harm_player"))
	
	$World.add_child(level)
	
	level.load_data_from_save(save_data)
	
	if exit_location is Vector2:
		$Player.position = exit_location
	else:
		$Player.position = level.spawn_pos
	
	$Player.velocity = Vector2.ZERO
	
	if level.is_hub:
		current_floor_name = level_name
	
	current_level = level
	var time_display = $GUIHandler.get_screen("TimeDisplay")
	if (time_display != null):
		assert(time_display.is_in_group("screen"))
		time_display.on_level_change(level)


func reset_level():
	$Player.velocity = Vector2.ZERO
	$Player.position = current_level.spawn_pos
	current_level.reset_time()


func ready_gui():
	var card_count = load("res://screens/card_count.tscn").instantiate()
	card_count.player = $Player
	$GUIHandler.display(card_count)
	
	var time_display = load("res://screens/time_display.tscn").instantiate()
	time_display.current_level = current_level
	#time_display.hide()
	$GUIHandler.display(time_display)
	
	var game_over = load("res://screens/game_over.tscn").instantiate()
	game_over.quit = Callable(self, "bye_bye_now")
	game_over.hide()
	$GUIHandler.display(game_over)
	
	var main_menu = load("res://screens/main_menu.tscn").instantiate()
	main_menu.quit = Callable(self, "bye_bye_now")
	$GUIHandler.display(main_menu)


func _on_level_harm_player():
	$GUIHandler.show_screen("GameOver")
	reset_level()
	get_tree().paused = true


func bye_bye_now():
	save()
	get_tree().quit()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save()
