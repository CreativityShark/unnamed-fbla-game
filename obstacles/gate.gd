extends AnimatableBody2D


@export var speed = 100
@export var open_position: Vector2
@export var default_position: Vector2
var is_open = false


func _physics_process(delta):
	if is_open:
		position.x = move_toward(position.x, open_position.x, speed * delta)
		position.y = move_toward(position.y, open_position.y, speed * delta)
	else:
		position.x = move_toward(position.x, default_position.x, speed * delta)
		position.y = move_toward(position.y, default_position.y, speed * delta)


func _on_punch_card_on_activated():
	is_open = true
	$GateTimer.start()


func _on_gate_timer_timeout():
	is_open = false
