extends GutTest

var level_class = preload('res://levels/level.gd')
var level_1 = preload('res://levels/level_1.tscn')
var level_2 = preload('res://levels/level_2.tscn')
var level_3 = preload('res://levels/level_3.tscn')

var levels = [level_1, level_2, level_3]

func test_nothing_to_add(params = use_parameters(levels)):
	var level = autoqfree(level_class.new())
	var scene = autoqfree(params.instantiate())
	
	level.load_data_from_save({})
	
	assert_eq(level.met_low_par, false)
	assert_eq(level.met_med_par, false)
	assert_eq(level.met_high_par, false)

func test_irrelevant_data(params = use_parameters(levels)):
	var level = autoqfree(level_class.new())
	var scene = autoqfree(params.instantiate())
	
	level.load_data_from_save({"irrelevant_data": null})
	
	assert_eq(level.met_low_par, false)
	assert_eq(level.met_med_par, false)
	assert_eq(level.met_high_par, false)
