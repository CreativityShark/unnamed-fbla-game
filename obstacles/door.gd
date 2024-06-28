extends Area2D

@export var destination_name: String
@export var card_requirement = 0
@export var exit_location: Vector2
@export var dialogue_file_name: String
var convo: Conversation
var player: Player
var gui: GUIHandler
var change_level: Callable

func _ready():
	$ShowPrompt/CardBubble/Label.text = str(card_requirement)
	if dialogue_file_name:
		convo = Conversation.new()
		convo.load_file(dialogue_file_name)


func _process(delta):
	if Input.is_action_just_pressed("down") and overlaps_body(player) and player.is_on_floor() and player.card_count >= card_requirement:
		if convo:
			var dialogue_display = gui.get_screen("DialogueDisplay")
			dialogue_display.display_dialogue(convo)
			await dialogue_display.ended
		$DoorSFX.play()
		await gui.get_screen("Wipe").start_wipe()
		change_level.call(destination_name, exit_location * 4)
	
	if $ShowPrompt.overlaps_body(player) and card_requirement > 0:
		$ShowPrompt/CardBubble.show()
	else:
		$ShowPrompt/CardBubble.hide()
