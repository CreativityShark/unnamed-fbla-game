class_name Player
extends CharacterBody2D


@export_category("Physics")
@export_group("Running")
@export var SPEED = 300.0
@export var MAX_SPEED = 1000.0
@export var ACCELERATION = 10.0
@export_group("Jumping")
@export var JUMP_VELOCITY = -600.0
@export var COYOTE_TIME_WINDOW = 0.25
@export var GRAVITY_REDUCTION_FACTOR = 0.5
@export_group("Diving")
@export var DIVE_FORCE = 400
@export_group("Sliding")
@export var SLIDE_THRESHOLD = 300.0
@export var SLIDE_GRACE_PERIOD = 1.0
@export var SLIDE_GRACE_DECAY = 1.5 
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5

static var STANDING_STATE = StandingState.new()
static var FALLING_STATE = FallingState.new()
static var JUMPING_STATE = JumpingState.new()
static var DIVING_STATE = DivingState.new()
static var SLIDING_STATE = SlidingState.new()

var animation_handler = AnimationHandler.new()

var facing_left = false
var ponytail_x = -16
var current_state: State = FALLING_STATE

@export_category("Card Progress")
@export var card_count = 0

func _ready():
	STANDING_STATE.name = "StandingState"
	add_child(STANDING_STATE)
	FALLING_STATE.name = "FallingState"
	add_child(FALLING_STATE)
	JUMPING_STATE.name = "JumpingState"
	add_child(JUMPING_STATE)
	DIVING_STATE.name = "DivingState"
	add_child(DIVING_STATE)
	SLIDING_STATE.name = "SlidingState"
	add_child(SLIDING_STATE)
	
	current_state.on_enter(self)
	
	animation_handler.name = "AnimationHandler"
	animation_handler.sprite = $AnimatedSprite2D
	add_child(animation_handler)


func _process(delta):
	if sign(velocity.x) < 0:
		animation_handler.face_left()
		$PonytailBase.position.x = -ponytail_x
	elif sign(velocity.x) > 0:
		animation_handler.face_right()
		$PonytailBase.position.x = ponytail_x
	
	$PonytailBase.animate_ponytail(velocity * 5, Vector2(0, GRAVITY))


func _physics_process(delta):
	handle_input(delta)
	
	move_and_slide()
	
	if (facing_left and velocity.x > 0) or (!facing_left and velocity.x < 0):
		facing_left = !facing_left


func handle_input(delta):
	var new_state = current_state.handle_input(self, delta)
	if new_state is State:
		current_state.on_exit(self)
		current_state = new_state
		current_state.on_enter(self)
