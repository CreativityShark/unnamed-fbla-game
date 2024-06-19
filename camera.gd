class_name Camera
extends Node2D


var player: Player
var target = Vector2.ZERO
var screen_offset: Vector2
@export var deadzone_size = 75 
var has_left_deadzone = false
var x_rate = 0.3
var y_rate = 0.03


func _ready():
	screen_offset = get_viewport_rect().size * 0.5
	reset_camera()


func _process(delta):
	if can_move_target():
		handle_x()
		handle_y()
	
	#if not get_viewport().get_visible_rect().has_point(player.position):
		#x_rate = 1
		#y_rate = 1
	#else:
		#x_rate = 0.15
		#y_rate = 0.03
	
	get_viewport().canvas_transform.origin.x += (-target.x - get_viewport().canvas_transform.origin.x) * x_rate
	get_viewport().canvas_transform.origin.y += (-target.y - get_viewport().canvas_transform.origin.y) * y_rate


func handle_x():
	target.x = player.position.x - screen_offset.x
	#if player.velocity.x != 0:
		#target.x += screen_offset.x * 0.5 * Input.get_axis("left", "right")


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
	if get_viewport() == null or player == null:
		return
	get_viewport().canvas_transform.origin = -(player.position - screen_offset)
	target = player.position - screen_offset
