extends Area2D

@export var destination_name: String
@export var card_requirement = 0
@export var exit_location: Vector2
var player: Player
var gui: GUIHandler
var change_level: Callable

func _ready():
	$ShowPrompt/CardBubble/Label.text = "%02d" % card_requirement


func _process(delta):
	if Input.is_action_just_pressed("down") and overlaps_body(player) and player.is_on_floor() and player.card_count >= card_requirement:
		await gui.get_screen("Wipe").start_wipe()
		change_level.call(destination_name, exit_location)
	
	if $ShowPrompt.overlaps_body(player) and card_requirement > 0:
		$ShowPrompt/CardBubble.show()
	else:
		$ShowPrompt/CardBubble.hide()
