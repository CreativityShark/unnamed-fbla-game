class_name FallingState
extends State

var can_jump = true


func on_enter(player: Player):
	player.animation_handler.play("fall")


func handle_input(player: Player):
	if player.is_on_floor():
		return player.STANDING_STATE
	
	var direction = Input.get_axis("left", "right")
	if direction:
		if direction != sign(player.velocity.x):
			player.velocity.x = player.SPEED * direction
	
	if Input.is_action_just_pressed("up"):
		#if can_jump:
			#return player.JUMPING_STATE
		return player.DIVING_STATE
	if Input.is_action_just_pressed("down"):
		return PoundingState.new()
	
	# TEMPORARY SOLUTION UNTIL MERGE, WHERE ALL STATES ARE STATIC AND HANDLER CAN BE SET IN PLAYER.GD
	#if player.velocity.y < 0:
		#player.animation_handler.play("jump")
	#else:
		#player.animation_handler.play("fall")


func _on_coyote_timer_timeout():
	can_jump = false
