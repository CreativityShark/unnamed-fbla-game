class_name Player
extends CharacterBody2D


const SPEED = 300.0
const MAX_SPEED = 1000.0
const ACCELERATION = 10.0
const JUMP_VELOCITY = -650.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

static var STANDING_STATE = StandingState.new()
static var JUMPING_STATE = JumpingState.new()
static var DIVING_STATE = DivingState.new()

var effective_gravity = GRAVITY
var facing_left = false
var ponytail_x = -16
var current_state: State = STANDING_STATE

@export_category("Card Progress")
@export var card_count = 0


func _process(delta):
	current_state.animate($AnimatedSprite2D, self)
	
	if sign(velocity.x) < 0:
		$AnimatedSprite2D.flip_h = true
		$PonytailBase.position.x = -ponytail_x
	elif sign(velocity.x) > 0:
		$AnimatedSprite2D.flip_h = false
		$PonytailBase.position.x = ponytail_x
	
	$PonytailBase.animate_ponytail(velocity, Vector2(0, GRAVITY))


func _physics_process(delta):
	if not Input.is_action_pressed("up") and effective_gravity != GRAVITY:
		effective_gravity = GRAVITY
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	handle_input()
	
	move_and_slide()
	
	if (facing_left and velocity.x > 0) or (!facing_left and velocity.x < 0):
		facing_left = !facing_left


func handle_input():
	var new_state = current_state.handle_input(self)
	if new_state is State:
		current_state.on_exit(self)
		current_state = new_state
		current_state.on_enter(self)
		current_state.animate_on_enter($AnimatedSprite2D, self)

