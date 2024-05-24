class_name JumpingState
extends FallingState


func on_enter(player: Player):
	player.velocity.y = player.JUMP_VELOCITY
