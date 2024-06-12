class_name FallingState
extends State


func handle_input(player: Player, delta):
	if player.is_on_floor():
		return player.STANDING_STATE
	
	var direction = Input.get_axis("left", "right")
	if direction:
		if direction != sign(player.velocity.x):
			player.velocity.x = player.SPEED * direction
	
	if Input.is_action_just_pressed("up"):
		return player.DIVING_STATE
	if Input.is_action_just_pressed("down"):
		return player.POUNDING_STATE
	
	super(player, delta)


func animate(sprite: Node, player: Player):
	super(sprite, player)
	if player.velocity.y < 0:
		sprite.play("jump")
	else:
		sprite.play("fall")
