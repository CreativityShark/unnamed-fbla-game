extends Node2D


var screen_size: Vector2
var screen_offset: Vector2


func _ready():
	screen_size = get_viewport_rect().size
	screen_offset = screen_size / 2


func _process(delta):
	var camera_pos = -get_viewport_transform().get_origin()
	position = camera_pos + screen_offset
	# Remember to set position relative to viewport
	$Foreground.position.x = fmod(-position.x / 4, screen_size.x)
	$Buildings.position.x = fmod(-position.x / 8, screen_size.x)
	$Hills.position.x = fmod(-position.x / 16, screen_size.x)
	$Sky.position.y = -position.y
