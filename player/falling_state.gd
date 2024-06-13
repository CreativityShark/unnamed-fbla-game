class_name FallingState
extends State


func on_enter(player: Player):
	player.animation_handler.play("fall")


func handle_input(player: Player, delta):
	if player.is_on_floor():
		return player.STANDING_STATE
	
	var direction = Input.get_axis("left", "right")
	if direction:
		if direction != sign(player.velocity.x):
			player.velocity.x = player.SPEED * direction
	
	if Input.is_action_just_pressed("up"):
		return player.DIVING_STATE
	super(player, delta)
