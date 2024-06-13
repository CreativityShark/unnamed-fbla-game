class_name PoundingState
extends State

const POUND_SPEED = 75.0


func handle_input(player: Player, delta):
	player.velocity.y += POUND_SPEED
	
	if player.is_on_floor():
		return player.STANDING_STATE
	
	# TEMPORARY SOLUTION UNTIL MERGING WITH MAIN, WHERE ALL STATES ARE STATIC AND HANDLER CAN BE SET THERE
	player.animation_handler.play("pound")
	
	return super(player, delta)


func on_enter(player: Player):
	player.velocity.x = 0
	player.velocity.y = player.JUMP_VELOCITY
