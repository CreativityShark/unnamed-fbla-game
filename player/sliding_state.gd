class_name SlidingState
extends State


var falling = false
var coyote_timer: Timer
var grace_timer: Timer
var in_grace = true


func handle_input(player: Player, delta):
	if not player.is_on_floor():
		if coyote_timer.is_stopped():
			coyote_timer.start(player.COYOTE_TIME_WINDOW)
		if falling:
			return player.FALLING_STATE
		else:
			falling = false
	
	if Input.is_action_just_pressed("up"):
		return player.JUMPING_STATE
	
	if Input.get_axis("left", "right") == -sign(player.velocity.x) or abs(player.velocity.x) < player.SLIDE_THRESHOLD:
		return player.STANDING_STATE
	
	if not in_grace:
		player.velocity.x -= player.velocity.x * player.SLIDE_GRACE_DECAY * delta
	
	return super(player, delta)


func on_enter(player: Player):
	super(player)
	coyote_timer = Timer.new()
	coyote_timer.name = "CoyoteTimer"
	coyote_timer.timeout.connect(_on_coyote_timer_timeout)
	add_child(coyote_timer)
	falling = false
	
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
	falling = false


func _on_grace_timer_timeout():
	in_grace = false


func _on_coyote_timer_timeout():
	falling = true


func is_attack():
	return true
