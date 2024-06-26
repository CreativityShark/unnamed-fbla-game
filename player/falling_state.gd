class_name FallingState
extends State


func on_enter(player: Player):
	var animation = player.animation_handler.get_playing()
	if animation != "jump" and animation != "transtion_to_fall":
		player.animation_handler.play("fall")


func handle_input(player: Player, delta):
	if player.is_on_floor():
		player.get_node("LandSFX").play()
		return player.STANDING_STATE
	
	var direction = Input.get_axis("left", "right")
	if direction:
		if direction != sign(player.velocity.x):
			player.velocity.x = player.SPEED * direction
	
	if Input.is_action_just_pressed("up"):
		return player.DIVING_STATE
	
	# Allow animation to transition to fall if currently playing the jump animation
	if player.velocity.y >= 0 and player.animation_handler.get_playing() == "jump":
		player.animation_handler.stop()
	
	super(player, delta)
