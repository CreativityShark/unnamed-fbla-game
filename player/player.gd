class_name Player
extends CharacterBody2D


@export_category("Physics")
@export var SPEED = 300.0
@export var MAX_SPEED = 1000.0
@export var ACCELERATION = 10.0
@export var JUMP_VELOCITY = -650.0
@export var DIVE_FORCE = 400
@export var COYOTE_TIME_WINDOW = 0.5
@export var GRAVITY_REDUCTION_FACTOR = 0.5
@export var SLIDE_THRESHOLD = 300.0
@export var SLIDE_GRACE_PERIOD = 3.0
@export var SLIDE_GRACE_DECAY = 0.75
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5

static var STANDING_STATE = StandingState.new()
static var FALLING_STATE = FallingState.new()
static var JUMPING_STATE = JumpingState.new()
static var DIVING_STATE = DivingState.new()
static var POUNDING_STATE = PoundingState.new()
static var SLIDING_STATE = SlidingState.new()

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
	POUNDING_STATE.name = "PoundingState"
	add_child(POUNDING_STATE)
	SLIDING_STATE.name = "SlidingState"
	add_child(SLIDING_STATE)
	
	current_state.on_enter(self)


func _process(_delta):
	current_state.animate($AnimatedSprite2D, self)
	
	if sign(velocity.x) < 0:
		$AnimatedSprite2D.flip_h = true
		$PonytailBase.position.x = -ponytail_x
	elif sign(velocity.x) > 0:
		$AnimatedSprite2D.flip_h = false
		$PonytailBase.position.x = ponytail_x
	
	$PonytailBase.animate_ponytail(velocity, Vector2(0, GRAVITY))


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
		current_state.animate_on_enter($AnimatedSprite2D, self)

