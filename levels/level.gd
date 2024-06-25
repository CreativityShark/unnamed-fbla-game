class_name Level
extends TileMap

@export var is_hub = false
@export var low_par = 0
@export var med_par = 0
@export var high_par = 0
@export var spawn_pos = Vector2(0, 0)
# ID should be the scene's filename (e.g. the ID for level_1.tscn would be level_1)
@export var id: String
var met_low_par = false
var met_med_par = false
var met_high_par = false
var time = 0
var player: Player
var gui: GUIHandler
var change_level: Callable
var has_collided = false

signal harm_player


func _ready():
	for child in get_tree().get_nodes_in_group("door"):
		child.player = player
		child.gui = gui
		child.change_level = change_level
	for child in get_tree().get_nodes_in_group("obstacle"):
		child.player = player
		if child is Printer:
			child.harm_player = Callable(do_player_harm)
		if child is DialogueTrigger:
			child.gui = gui


func _physics_process(delta):
	var collision = player.get_last_slide_collision()
	if collision:
		var pos = local_to_map(to_local(collision.get_position()))
		var data = self.get_cell_tile_data(0, pos)
		# Check that player is not at spawn pos to keep from emitting immediately after unpausing and thus pausing again
		# I'd prefer a cleaner solution, but this will work for now
		if data and data.get_custom_data("harms_player") and player.position != spawn_pos:
			harm_player.emit()


# pre: met_*_par variables have values and get_tree() returns a value that isn't null
# post: all save data for this level is returned
func get_data_to_save():
	var data = {}
	data[id + "_met_low_par"] = met_low_par
	data[id + "_met_med_par"] = met_med_par
	data[id + "_met_high_par"] = met_high_par
	for child in get_children():
		if child is DialogueTrigger and child.one_shot:
			data[id + "_" + child.name + "_has_played"] = child.has_played
	return data


func load_data_from_save(data: Dictionary):
	if data.has(id + "_met_low_par"):
		met_low_par = data[id + "_met_low_par"]
	if data.has(id + "_met_med_par"):
		met_med_par = data[id + "_met_med_par"]
	if data.has(id + "_met_high_par"):
		met_high_par = data[id + "_met_high_par"]
	for child in get_children():
		if child is DialogueTrigger and child.one_shot and data.has(id + "_" + child.name + "_has_played"):
			child.has_played = data[id + "_" + child.name + "_has_played"]


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


func do_player_harm():
	harm_player.emit()


func _on_level_timer_timeout():
	time += 1
