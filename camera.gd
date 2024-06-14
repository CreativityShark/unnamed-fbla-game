class_name Camera
extends Node2D


var player: Player
var target = Vector2.ZERO
var screen_offset: Vector2
@export var deadzone_size = 75 
var has_left_deadzone = false
var y_rate = 0.03


func _ready():
	screen_offset = get_viewport_rect().size * 0.5
	reset_camera()


func _process(delta):
	if can_move_target():
		target.x = player.position.x - screen_offset.x
		handle_y()
	
	get_viewport().canvas_transform.origin.x += (-target.x - get_viewport().canvas_transform.origin.x) * 0.1
	get_viewport().canvas_transform.origin.y += (-target.y - get_viewport().canvas_transform.origin.y) * y_rate


func handle_y():
	if (player.is_on_floor()):
		target.y = player.position.y - screen_offset.y


func can_move_target():
	if has_left_deadzone:
		if player.velocity == Vector2.ZERO:
			has_left_deadzone = false
			return false
		return true 
	else:
		var player_screen_pos = player.position + get_viewport().canvas_transform.origin - screen_offset
		if abs(player_screen_pos.x) > deadzone_size or abs(player_screen_pos.y) > deadzone_size:
			has_left_deadzone = true
			return true 
		return false


func reset_camera():
	if get_viewport() == null:
		return
	get_viewport().canvas_transform.origin = -(player.position - screen_offset)
	target = player.position - screen_offset
