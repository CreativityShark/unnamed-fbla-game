class_name SlidingState
extends StandingState


var grace_timer: Timer
var in_grace = true


func handle_input(player: Player, delta):
	# If player inputs horizontal direction opposite of current motion or is going slower than the threshold, return to standing
	if Input.get_axis("left", "right") == -sign(player.velocity.x) or abs(player.velocity.x) < player.SLIDE_THRESHOLD:
		return player.STANDING_STATE
	
	return super(player, delta)


func set_x_velocity(player: Player, delta):
	if not in_grace:
		player.velocity.x -= player.velocity.x * player.SLIDE_GRACE_DECAY * delta


func already_sliding():
	return true


func on_enter(player: Player):
	super(player)
	grace_timer = Timer.new()
	grace_timer.name = "GraceTimer"
	grace_timer.timeout.connect(_on_grace_timer_timeout)
	add_child(grace_timer)
	in_grace = true
	grace_timer.start()
	
	player.velocity.x = max(abs(player.velocity.x), player.MAX_SPEED) * sign(player.velocity.x)
	
	player.animation_handler.play("transition_to_slide")
	player.animation_handler.queue_animation("slide")


func on_exit(player: Player):
	grace_timer.stop()
	grace_timer.queue_free()
	in_grace = true


func _on_grace_timer_timeout():
	in_grace = false
