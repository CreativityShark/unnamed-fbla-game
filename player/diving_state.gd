class_name DivingState
extends State


func handle_input(player: Player, delta):
	if player.is_on_floor():
		player.get_node("LandSFX").play()
		return player.STANDING_STATE
	
	return super(player, delta)


func on_enter(player: Player):
	player.velocity.y = player.JUMP_VELOCITY
	player.velocity.x += player.DIVE_FORCE * sign(player.velocity.x)
	
	player.animation_handler.play("dive")


func is_attack():
	return true
