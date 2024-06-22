extends Area2D


@export var blast_force = 1000


func _on_body_entered(body):
	if body is Player and overlaps_body(body):
		var direction = body.position.direction_to(position)
		print(direction)
		body.velocity = direction * blast_force
		body.velocity.y -= 10
		print(body.velocity)
