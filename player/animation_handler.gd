class_name AnimationHandler
extends Node

var sprite: AnimatedSprite2D
var queue = []


func _process(delta):
	assert(sprite != null)
	if not sprite.is_playing():
		var to_be_played = queue.pop_front()
		assert(sprite.sprite_frames.has_animation(to_be_played))
		sprite.play(to_be_played)


# pre: name is a string with the name of an animation of sprite
# post: name is pushed to queue
func queue_animation(name: String):
	assert(sprite.sprite_frames.has_animation(name))
	queue.push_back(name)


# pre: name is a string wih the name of an animation of sprite
# post: the animation is played immediately, skipping the queue
func play(name: String):
	assert(sprite.sprite_frames.has_animation(name))
	sprite.play(name)


# post: the animation that is currently playing is stopped
func stop():
	sprite.stop()


func face_left():
	sprite.flip_h = true


func face_right():
	sprite.flip_h = false
