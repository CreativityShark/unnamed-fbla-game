class_name Camera
extends Node2D


var player: Player
var target = Vector2.ZERO
var screen_offset: Vector2
@export var deadzone_size = 75 
var has_left_deadzone = false


func _ready():
	screen_offset = get_viewport_rect().size * 0.5
	get_viewport().canvas_transform.origin = -(player.position - screen_offset)


func _process(delta):
	if can_move_target():
		target = player.position
		target -= screen_offset 
	
	get_viewport().canvas_transform.origin = (0.8 * get_viewport().canvas_transform.origin) + (0.2 * -target) 


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
