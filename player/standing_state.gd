class_name StandingState
extends State

var falling = false
var timer: Timer
var run_sfx_cooldown: Timer


func handle_input(player: Player, delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		if direction == sign(player.velocity.x):
			player.velocity.x = move_toward(player.velocity.x, player.MAX_SPEED * direction, player.ACCELERATION)
		else:
			player.velocity.x = player.SPEED * direction
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	
	if player.velocity.x == 0:
		player.animation_handler.play("idle")
	else:
		# Playback speed equals x velocity / 600, but with a clamped between 0.4 and 1.2
		player.animation_handler.play("run", max(min(abs(player.velocity.x / 600), 1.2), 0.4))
		if run_sfx_cooldown.is_stopped():
			player.running_sfx.pick_random().play()
			run_sfx_cooldown.start(0.2)
	
	if not player.is_on_floor():
		if timer.is_stopped():
			timer.start(player.COYOTE_TIME_WINDOW)
		if falling:
			return player.FALLING_STATE
		else:
			falling = false
	
	if Input.is_action_just_pressed("up"):
		return player.JUMPING_STATE
	
	elif Input.is_action_just_pressed("down") and abs(player.velocity.x) >= player.SLIDE_THRESHOLD:
		return player.SLIDING_STATE
	
	super(player, delta)


func on_enter(player: Player):
	timer = Timer.new()
	timer.name = "CoyoteTimer"
	timer.timeout.connect(_on_coyote_timer_timeout)
	add_child(timer)
	run_sfx_cooldown = Timer.new()
	run_sfx_cooldown.name = "RunSFXCooldown"
	run_sfx_cooldown.one_shot = true
	add_child(run_sfx_cooldown)
	falling = false

func on_exit(_player: Player):
	timer.stop()
	timer.queue_free()
	falling = false


func _on_coyote_timer_timeout():
	falling = true
