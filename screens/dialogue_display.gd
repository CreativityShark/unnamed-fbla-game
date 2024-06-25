extends Control


var current_convo: Conversation
var current_dialogue: Conversation.Dialogue


func _process(delta):
	if Input.is_action_just_pressed("down"):
		next_dialogue()


func display_dialogue(convo: Conversation):
	get_tree().paused = true
	current_convo = convo
	next_dialogue()
	$TextTimer.start()
	self.show()


func end():
	$TextTimer.stop()
	self.hide()
	get_tree().paused = false


func next_dialogue():
	if current_convo.dialogues.is_empty():
		end()
		return
	current_dialogue = current_convo.dialogues.pop_back()
	$ColorRect/Text.text = current_dialogue.text
	$ColorRect/Text.visible_characters = 0
	$ControlDelay.stop()
	$ColorRect/ControlMessage.hide()


func _on_text_timer_timeout():
	if $ColorRect/Text.visible_characters < len($ColorRect/Text.text):
		$ColorRect/Text.visible_characters += 1
	elif $ControlDelay.is_stopped() and not $ColorRect/ControlMessage.visible:
		$ControlDelay.start()


func _on_control_delay_timeout():
	$ColorRect/ControlMessage.show()
