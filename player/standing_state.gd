class_name StandingState
extends State


func handle_input(player: Player):
	var direction = Input.get_axis("left", "right")
	if direction:
		if direction == sign(player.velocity.x):
			player.velocity.x = move_toward(player.velocity.x, player.MAX_SPEED * direction, player.ACCELERATION)
		else:
			player.velocity.x = player.SPEED * direction
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	
	if !player.is_on_floor():
		return FallingState.new()
	elif Input.is_action_pressed("up"):
		return player.JUMPING_STATE
