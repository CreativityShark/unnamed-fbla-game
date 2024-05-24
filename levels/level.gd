class_name Level
extends TileMap

@export var is_hub = false
@export var low_par = 0
@export var med_par = 0
@export var high_par = 0
@export var spawn_pos = Vector2(0, 0)
var met_low_par = false
var met_med_par = false
var met_high_par = false
var time = 0
var player: Player
var change_level: Callable
var show_dialogue: Callable

signal harm_player


func _ready():
	for child in get_tree().get_nodes_in_group("door"):
		child.player = player
		child.change_level = change_level
	for child in get_tree().get_nodes_in_group("dialogue"):
		child.player = player
		child.show_dialogue = show_dialogue


func _physics_process(delta):
	var collision = player.get_last_slide_collision()
	if collision:
		var pos = local_to_map(to_local(collision.get_position()))
		var data = self.get_cell_tile_data(0, pos)
		if data and data.get_custom_data("harms_player"):
			harm_player.emit()


func get_data_to_save():
	var data = {}
	data[name + "_met_low_par"] = met_low_par
	data[name + "_met_med_par"] = met_med_par
	data[name + "_met_high_par"] = met_high_par
	for child in get_tree().get_nodes_in_group("dialogue"):
		data[child.name + "has_seen"] = child.has_seen
	return data


func load_data_from_save(data: Dictionary):
	if data.has(name + "_met_low_par"):
		met_low_par = data[name + "_met_low_par"]
	if data.has(name + "_met_med_par"):
		met_med_par = data[name + "_met_med_par"]
	if data.has(name + "_met_high_par"):
		met_high_par = data[name + "_met_high_par"]
	for child in get_tree().get_nodes_in_group("dialogue"):
		if data.has(child.name + "has_seen"):
			child.has_seen = data[child.name + "has_seen"]


func _on_start_body_entered(body):
	if body != player: return
	$LevelTimer.start()
	print("start")


func _on_finish_body_entered(body):
	if body != player: return
	$LevelTimer.stop()
	if not met_low_par and time <= low_par:
		met_low_par = true
		player.card_count += 1
	if not met_med_par and time <= med_par:
		met_med_par = true
		player.card_count += 1
	if not met_high_par and time <= high_par:
		met_high_par = true
		player.card_count += 1
	print("stop")


func reset_time():
	$LevelTimer.stop()
	time = 0


func _on_level_timer_timeout():
	time += 1
	print(time)
