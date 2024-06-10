class_name DivingState
extends State

const DIVE_FORCE = 400.0


func handle_input(player: Player):
	if player.is_on_floor():
		return player.STANDING_STATE
	
	if Input.is_action_just_pressed("down"):
		return player.FALLING_STATE
	
	return super(player)


func on_enter(player: Player):
	player.velocity.y = player.JUMP_VELOCITY / 2
	player.velocity.x += DIVE_FORCE * sign(player.velocity.x)


func animate(sprite: Node, player: Player):
	sprite.play("dive")
