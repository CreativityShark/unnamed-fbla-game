class_name StandingState
extends State

var falling = false
var timer: Timer


func handle_input(player: Player, delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		if direction == sign(player.velocity.x):
			player.velocity.x = move_toward(player.velocity.x, player.MAX_SPEED * direction, player.ACCELERATION)
		else:
			player.velocity.x = player.SPEED * direction
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	
	if !player.is_on_floor():
		if timer.is_stopped():
			timer.start(player.COYOTE_TIME_WINDOW)
		if falling:
			return player.FALLING_STATE
	if Input.is_action_pressed("up"):
		return player.JUMPING_STATE
	super(player, delta)


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


func animate(sprite: Node, player: Player):
	if player.velocity.x == 0:
		sprite.play("idle")
	else:
		sprite.play("run")
