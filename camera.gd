extends Camera2D

@export var begin_zoom_at = 1400
@export var end_zoom_at = 2000

var follow_player = true
var camera_target: Vector2
var screen_size
var player


func _ready():
	screen_size = self.get_viewport_rect().size


func _process(delta):
	if !follow_player:
		position = camera_target
		return
	position = player.position
	position.x += player.velocity.x / 2
