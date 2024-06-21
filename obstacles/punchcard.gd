extends Area2D


var can_be_activated = true
var player: Player


signal on_activated


func _ready():
	$AnimationHandler.sprite = $AnimatedSprite2D
	$AnimationHandler.play("idle")


func _physics_process(delta):
	if can_be_activated and overlaps_body(player) and player.current_state == player.DIVING_STATE:
		on_activated.emit()
		$AnimationHandler.play("punch_in")
		$AnimationHandler.queue_animation("idle")
		can_be_activated = false
	
	if not can_be_activated and not overlaps_body(player):
		can_be_activated = true
