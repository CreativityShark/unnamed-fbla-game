class_name Printer
extends Area2D


@export var launch_velocity = -500
@export var cooldown = 10.0
@export var initial_cooldown = 10.0
var player: Player
var paper_scene = load("res://obstacles/paper.tscn")
var harm_player: Callable


func _ready():
	$PrinterTimer.start(initial_cooldown)
	$AnimationHandler.sprite = $AnimatedSprite2D
	$AnimationHandler.play("idle") 


func _process(delta):
	if $PrinterTimer.time_left < 5 and ($AnimationHandler.get_playing() == "idle" or $AnimationHandler.get_playing() == "reload"):
		$AnimationHandler.play("suck")
		$AnimationHandler.queue_animation("idle_empty")
		$SuckSFX.play()


func _physics_process(delta):
	if overlaps_body(player) and player.current_state.is_attack():
		$AnimationHandler.play("crumble")
		$ExplosionParticles.emitting = true
		await get_tree().create_timer(0.5).timeout
		queue_free()


func _on_printer_timer_timeout():
	$AnimationHandler.play("shimmey")
	await get_tree().create_timer(1).timeout
	$AnimationHandler.play("bounce")
	$AnimationHandler.queue_animation("reload")
	$AnimationHandler.queue_animation("idle")
	shoot()
	$PrinterTimer.start(cooldown)
	$ShootSFX.play()
	await $ShootSFX.finished
	$ReloadSFX.play()


func shoot():
	var paper = paper_scene.instantiate()
	paper.velocity = launch_velocity
	paper.player = player
	paper.harm_player = harm_player
	add_child(paper)
