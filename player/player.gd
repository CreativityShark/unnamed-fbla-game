class_name Player
extends CharacterBody2D


const SPEED = 300.0
const MAX_SPEED = 1000.0
const ACCELERATION = 10.0
const JUMP_VELOCITY = -650.0

static var STANDING_STATE = StandingState.new()
static var JUMPING_STATE = JumpingState.new()
static var DIVING_STATE = DivingState.new()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_left = false
var current_state: State = STANDING_STATE

@export_category("Card Progress")
@export var card_count = 0


func _process(delta):
	current_state.animate($AnimatedSprite2D, self)
	
	if sign(velocity.x) < 0:
		$AnimatedSprite2D.flip_h = true
	elif sign(velocity.x) > 0:
		$AnimatedSprite2D.flip_h = false


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
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

