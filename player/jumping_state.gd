class_name JumpingState
extends FallingState


func handle_input(player: Player, delta):
	if not Input.is_action_pressed("up"):
		return player.FALLING_STATE
	
	# Half the effect of gravity
	if not player.is_on_floor():
		player.velocity.y -= player.GRAVITY * delta * player.gravity_reduction_factor
	
	return super(player, delta)


func on_enter(player: Player):
	player.velocity.y = player.JUMP_VELOCITY
