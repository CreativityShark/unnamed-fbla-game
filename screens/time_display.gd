extends Control

var current_level: Level
@export var card_texture: Texture2D
@export var no_card_texture: Texture2D


func _ready():
	on_level_change(current_level)


func _process(delta):
	if (current_level != null):
		$ColorRect/HUDTimer.text = as_time(current_level.time)
		update_time_display()


func on_level_change(level: Level):
	assert(level != null)
	current_level = level
	if (level.is_hub):
		self.hide()
	else:
		self.show()
		$ColorRect/LowPar.text = as_time(level.low_par)
		$ColorRect/MedPar.text = as_time(level.med_par)
		$ColorRect/HighPar.text = as_time(level.high_par)


func as_time(time: int):
	assert(time >= 0)
	return "%d:%02d" % [time / 60, time % 60]


func update_time_display():
	if current_level.met_low_par:
		$ColorRect/LowPar/CardIcon.texture = card_texture
	else:
		$ColorRect/LowPar/CardIcon.texture = no_card_texture
	if current_level.met_med_par:
		$ColorRect/MedPar/CardIcon.texture = card_texture
	else:
		$ColorRect/MedPar/CardIcon.texture = no_card_texture
	if current_level.met_high_par:
		$ColorRect/HighPar/CardIcon.texture = card_texture
	else:
		$ColorRect/HighPar/CardIcon.texture = no_card_texture
