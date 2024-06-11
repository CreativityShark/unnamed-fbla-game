class_name DivingState
extends State


func handle_input(player: Player, delta):
	if player.is_on_floor():
		return player.STANDING_STATE
	
	if Input.is_action_just_pressed("down"):
		return player.FALLING_STATE
	
	super(player, delta)


func on_enter(player: Player):
	player.velocity.y = player.JUMP_VELOCITY
	player.velocity.x += player.DIVE_FORCE * sign(player.velocity.x)


func animate(sprite: Node, _player: Player):
	sprite.play("dive")
