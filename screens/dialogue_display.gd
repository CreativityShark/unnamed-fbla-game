extends Control


var current_convo: Conversation
var current_dialogue: Conversation.Dialogue
var left_pos = Vector2(128, 364)
var right_pos = Vector2(1536, 364)


signal ended


func _process(delta):
	if visible and Input.is_action_just_pressed("down") and $GraceTimer.is_stopped():
		next_dialogue()


func display_dialogue(convo: Conversation):
	$GraceTimer.start()
	get_tree().paused = true
	current_convo = convo
	next_dialogue()
	self.show()
	$TextTimer.start()


func end():
	$TextTimer.stop()
	self.hide()
	get_tree().paused = false
	ended.emit()


func next_dialogue():
	if current_convo.dialogues.is_empty():
		end()
		return
	current_dialogue = current_convo.dialogues.pop_back()
	$PicWindow/Header/Name.text = current_dialogue.name
	$PicWindow/Pic.texture = current_dialogue.image
	$ColorRect/Text.text = current_dialogue.text
	
	if current_dialogue.name == "Other Character":
		$PicWindow.position = right_pos
	else:
		$PicWindow.position = left_pos
	
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
