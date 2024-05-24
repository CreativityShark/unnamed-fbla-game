extends CanvasLayer

var level: Level
@export var card_texture: Texture2D
@export var no_card_texture: Texture2D
var speakers: Array[String]
var texts: Array[String]
var times: Array[int]


func _ready():
	get_tree().paused = true
	$MainMenu.show()


func on_level_change():
	$Dialogue.hide()
	$Dialogue/DialogueTimer.stop()
	speakers = []
	texts = []
	times = []
	
	if level.is_hub:
		$TimeDisplay.hide()
	else:
		$TimeDisplay.show()
		$TimeDisplay/LowPar.text = as_time(level.low_par)
		$TimeDisplay/MedPar.text = as_time(level.med_par)
		$TimeDisplay/HighPar.text = as_time(level.high_par)


func _process(delta):
	$TimeDisplay/HUDTimer.text = as_time(level.time)
	
	update_time_display()


func update_time_display():
	if level.time <= level.low_par:
		$TimeDisplay/LowPar.label_settings.font_color = Color(1, 1, 1)
	else:
		$TimeDisplay/LowPar.label_settings.font_color = Color(0.5, 0.5, 0.5)
	if level.time <= level.med_par:
		$TimeDisplay/MedPar.label_settings.font_color = Color(1, 1, 1)
	else:
		$TimeDisplay/MedPar.label_settings.font_color = Color(0.5, 0.5, 0.5)
	if level.time <= level.high_par:
		$TimeDisplay/HighPar.label_settings.font_color = Color(1, 1, 1)
	else:
		$TimeDisplay/HighPar.label_settings.font_color = Color(0.5, 0.5, 0.5)
	
	if level.met_low_par:
		$TimeDisplay/LowPar/CardIcon.texture = card_texture
	else:
		$TimeDisplay/LowPar/CardIcon.texture = no_card_texture
	if level.met_med_par:
		$TimeDisplay/MedPar/CardIcon.texture = card_texture
	else:
		$TimeDisplay/MedPar/CardIcon.texture = no_card_texture
	if level.met_high_par:
		$TimeDisplay/HighPar/CardIcon.texture = card_texture
	else:
		$TimeDisplay/HighPar/CardIcon.texture = no_card_texture


func display_dialogue(texts: Array[String], speakers: Array[String], times: Array[int]):
	self.texts = texts
	self.speakers = speakers
	self.times = times
	display_piece(texts[0], speakers[0], times[0])


func display_piece(text, speaker, time):
	$Dialogue/Speaker.text = speaker
	$Dialogue/Text.text = text
	$Dialogue.show()
	$Dialogue/DialogueTimer.wait_time = time
	$Dialogue/DialogueTimer.start()


func _on_dialogue_timer_timeout():
	texts.remove_at(0)
	speakers.remove_at(0)
	times.remove_at(0)
	if not texts.is_empty() and not speakers.is_empty() and not times.is_empty():
		display_piece(texts[0], speakers[0], times[0])
	else:
		$Dialogue.hide()


func _on_start_button_pressed():
	get_tree().paused = false
	$MainMenu.hide()


func as_time(time: int):
	return "%d:%02d" % [time / 60, time % 60]
