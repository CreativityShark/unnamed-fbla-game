class_name Conversation
extends Node


var dialogues = []
@export var file_name: String


func _ready():
	if file_name:
		load_file(file_name)


# Pre: filepath leads to a txt file formatted like so:
#	Line 1: character name
#	Line 2: path to character image
#	Line 3: text to display
func load_from_filepath(filepath: String):
	assert(FileAccess.file_exists(filepath))
	var file = FileAccess.open(filepath, FileAccess.READ)
	while file.get_position() < file.get_length():
		var dialogue = Dialogue.new()
		dialogue.name = file.get_line()
		dialogue.image = load(file.get_line())
		dialogue.text = file.get_line()
		assert(file.get_error() == 0)
		dialogues.push_front(dialogue)


func load_file(file_name: String):
	load_from_filepath("res://dialogue/" + file_name + ".txt")


class Dialogue:
	var name: String
	var image: Texture2D
	var text: String
