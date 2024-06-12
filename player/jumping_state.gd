class_name JumpingState
extends FallingState


func handle_input(player: Player, delta):
	if not Input.is_action_pressed("up"):
		return player.FALLING_STATE
	
	# Half the effect of gravity
	if not player.is_on_floor() and player.velocity.y < 0:
		player.velocity.y -= player.GRAVITY * delta * player.GRAVITY_REDUCTION_FACTOR
	
	return super(player, delta)


func on_enter(player: Player):
	player.velocity.y = player.JUMP_VELOCITY
