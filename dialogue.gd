class_name Dialogue
extends Area2D

@export var speakers: Array[String]
@export var texts: Array[String]
@export var durations: Array[int]
var player: Player
var show_dialogue: Callable
var has_seen = false


func _process(delta):
	if overlaps_body(player):
		display()


func display():
	if not has_seen:
		show_dialogue.call(texts, speakers, durations)
		has_seen = true
