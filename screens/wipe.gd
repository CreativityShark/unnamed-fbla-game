extends Control


@export var start = -3289
@export var midway = 0
@export var end = 3289
@export var speed = 100


func start_wipe():
	while $ColorRect.position.x < midway:
		$ColorRect.position.x = move_toward($ColorRect.position.x, midway, speed)
		await get_tree().create_timer(0.01).timeout


func finish_wipe():
	while $ColorRect.position.x < end:
		$ColorRect.position.x = move_toward($ColorRect.position.x, end, speed)
		await get_tree().create_timer(0.01).timeout
	$ColorRect.position.x = start
