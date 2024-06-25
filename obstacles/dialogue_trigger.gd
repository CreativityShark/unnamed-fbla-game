class_name DialogueTrigger
extends Area2D


var player: Player
var gui: GUIHandler
var convo: Conversation
var has_played = false
@export var one_shot = false
@export var file_name: String


func _ready():
	convo = Conversation.new()
	convo.load_file(file_name)


func _on_body_entered(body):
	if body == player and not has_played:
		gui.get_screen("DialogueDisplay").display_dialogue(convo)
		has_played = true
