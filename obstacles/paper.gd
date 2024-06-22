class_name Paper
extends AnimatableBody2D


@export var bounce_force = -500
var velocity = -500
var initial_position: Vector2
var player: Player
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	initial_position = position


func _process(delta):
	if $AnimatedSprite2D == null:
		return
	
	if velocity < 0:
		$AnimatedSprite2D.play("wave")
	else:
		$AnimatedSprite2D.play("fall")


func _physics_process(delta):
	if position.y > initial_position.y:
		queue_free()
	
	position.y += velocity * delta
	velocity = min(velocity + GRAVITY * delta, 50)
	
	if $Area2D.overlaps_body(player):
		if not player.current_state.is_attack():
			$CollisionShape2D.set_deferred("disabled", false)
		else:
			$CollisionShape2D.set_deferred("disabled", true)
	else:
		$CollisionShape2D.set_deferred("disabled", true)


func _on_area_2d_body_entered(body):
	if body is Player and body.current_state == body.DIVING_STATE:
		body.velocity.y += bounce_force
		$PaperParticles.emitting = true
		$AnimatedSprite2D.hide()
		await get_tree().create_timer(0.5).timeout
		queue_free()
