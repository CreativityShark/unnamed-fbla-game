extends GutTest


var handler_script = load("res://player/animation_handler.gd")


func test_adding_to_animation_queue():
	var sprite = double(AnimatedSprite2D).new()
	var frames = double(SpriteFrames).new()
	stub(frames, "has_animation").to_return(true)
	sprite.sprite_frames = frames
	
	var handler = partial_double(handler_script).new()
	handler.sprite = sprite
	
	handler.queue_animation("test")
	
	assert_has(handler.queue, "test")
