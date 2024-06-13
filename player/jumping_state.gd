class_name JumpingState
extends FallingState


func on_enter(player: Player):
	player.velocity.y = player.JUMP_VELOCITY
	self.animation_handler.play("jump")
	self.animation_handler.queue_animation("transition_to_fall")
	self.animation_handler.queue_animation("fall")


func handle_input(player: Player):
	if player.velocity.y >= 0 and self.animation_handler.get_playing() == "jump":
		self.animation_handler.stop()
	
	return super(player)
