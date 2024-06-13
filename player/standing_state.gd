class_name StandingState
extends State

var falling = false
var timer: Timer


func handle_input(player: Player, delta):
	set_x_velocity(player, delta)
	
	if !player.is_on_floor():
		if timer.is_stopped():
			timer.start(player.COYOTE_TIME_WINDOW)
		if falling:
			return player.FALLING_STATE
	if Input.is_action_just_pressed("up"):
		return player.JUMPING_STATE
	elif Input.is_action_just_pressed("down") and abs(player.velocity.x) >= player.SLIDE_THRESHOLD and not already_sliding():
		return player.SLIDING_STATE
	
	super(player, delta)


func set_x_velocity(player: Player, delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		if direction == sign(player.velocity.x):
			player.velocity.x = move_toward(player.velocity.x, player.MAX_SPEED * direction, player.ACCELERATION)
		else:
			player.velocity.x = player.SPEED * direction
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)


func already_sliding():
	return false


func on_enter(player: Player):
	timer = Timer.new()
	timer.name = "CoyoteTimer"
	timer.timeout.connect(_on_coyote_timer_timeout)
	add_child(timer)
	falling = false

func on_exit(_player: Player):
	timer.stop()
	timer.queue_free()
	falling = false


func _on_coyote_timer_timeout():
	falling = true
