extends Node

@export var current_floor_name: String
var current_level: Level
var save_data = {}


func _ready():
	print("hello world!")
	
	get_tree().paused = true
	
	var save_file = FileAccess.open("user://epic.save", FileAccess.READ)
	var json = JSON.new()
	json.parse(save_file.get_line())
	if json.get_data() != null:
		save_data = json.get_data()
	save_file.close()
	
	if save_data.has("Cards Collected"):
		$Player.card_count = save_data["Cards Collected"]
	if save_data.has("Current Floor"):
		current_floor_name = save_data["Current Floor"]
	
	$Camera2D.player = $Player
	$GUI.level = current_level
	
	change_level(current_floor_name, null)


func _process(delta):
	$GUI/CardCount/Label.text = str($Player.card_count)
	
	if Input.is_action_just_pressed("quit"):
		save()
		get_tree().quit()


func save():
	save_data["Cards Collected"] = $Player.card_count
	save_data["Current Floor"] = current_floor_name
	save_level_data()
	
	var save_file = FileAccess.open("user://epic.save", FileAccess.WRITE_READ)
	save_file.store_line(JSON.stringify(save_data))
	save_file.close()
	print("saved!")


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
	level.show_dialogue = Callable($GUI, "display_dialogue")
	level.harm_player.connect(Callable(self, "_on_level_harm_player"))
	
	$World.add_child(level)
	
	level.load_data_from_save(save_data)
	
	if exit_location is Vector2:
		$Player.position = exit_location
	else:
		$Player.position = level.spawn_pos
	
	$GUI.level = level
	$GUI.on_level_change()
	
	if level.is_hub:
		current_floor_name = level_name
	
	current_level = level
	
	if level_name == "win":
		$GUI/WinMenu.show()


func _on_level_harm_player():
	$GUI/GameOverMenu.show()
	$Player.position = current_level.spawn_pos
	current_level.reset_time()
	get_tree().paused = true


func _on_continue_button_pressed():
	get_tree().paused = false
	$Player.position = current_level.spawn_pos
	$GUI/GameOverMenu.hide()


func _on_quit_button_pressed():
	save()
	get_tree().quit()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save()
