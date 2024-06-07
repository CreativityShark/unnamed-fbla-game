extends Sprite2D

@export var ponytail_length = 100
@export var step = 10


func animate_ponytail(velocity, gravity):
	var target = (gravity - velocity).normalized() * ponytail_length
	$PonytailEnd.position = move_vector_toward($PonytailEnd.position, target, step)


func move_vector_toward(v1: Vector2, v2: Vector2, step):
	return Vector2(move_toward(v1.x, v2.x, step), move_toward(v1.y, v2.y, step))
