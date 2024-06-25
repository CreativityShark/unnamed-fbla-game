class_name DialogueTrigger
extends Area2D


var player: Player
var gui: GUIHandler
var convo: Conversation
@export var file_name: String


func _ready():
	convo = Conversation.new()
	convo.load_file(file_name)


func _on_body_entered(body):
	if body == player:
		gui.get_screen("DialogueDisplay").display_dialogue(convo)
