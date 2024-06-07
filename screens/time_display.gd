extends Control

var current_level: Level
@export var card_texture: Texture2D
@export var no_card_texture: Texture2D


func _ready():
	on_level_change(current_level)


func _process(delta):
	if (current_level != null):
		$HUDTimer.text = as_time(current_level.time)
		update_time_display()


func on_level_change(level: Level):
	assert(level != null)
	current_level = level
	if (level.is_hub):
		self.hide()
	else:
		self.show()
		$LowPar.text = as_time(level.low_par)
		$MedPar.text = as_time(level.med_par)
		$HighPar.text = as_time(level.high_par)


func as_time(time: int):
	assert(time >= 0)
	return "%d:%02d" % [time / 60, time % 60]


func update_time_display():
	if current_level.time <= current_level.low_par:
		$LowPar.label_settings.font_color = Color(1, 1, 1)
	else:
		$LowPar.label_settings.font_color = Color(0.5, 0.5, 0.5)
	if current_level.time <= current_level.med_par:
		$MedPar.label_settings.font_color = Color(1, 1, 1)
	else:
		$MedPar.label_settings.font_color = Color(0.5, 0.5, 0.5)
	if current_level.time <= current_level.high_par:
		$HighPar.label_settings.font_color = Color(1, 1, 1)
	else:
		$HighPar.label_settings.font_color = Color(0.5, 0.5, 0.5)
	
	if current_level.met_low_par:
		$LowPar/CardIcon.texture = card_texture
	else:
		$LowPar/CardIcon.texture = no_card_texture
	if current_level.met_med_par:
		$MedPar/CardIcon.texture = card_texture
	else:
		$MedPar/CardIcon.texture = no_card_texture
	if current_level.met_high_par:
		$HighPar/CardIcon.texture = card_texture
	else:
		$HighPar/CardIcon.texture = no_card_texture
