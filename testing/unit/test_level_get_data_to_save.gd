extends GutTest


var level_script = load("res://levels/level.gd")
var test_data = [[false, false, false], [true, false, false], [false, true, false], [true, true, false], [false, false, true], [true, false, true], [false, true, false], [true, true, true]]

func test_data_grab(params=use_parameters(test_data)):
	var level = partial_double(level_script).new()
	level.name = "test"
	level.met_low_par = params[0]
	level.met_med_par = params[1]
	level.met_high_par = params[2]
	
	var result = autoqfree(level.get_data_to_save())
	
	assert_eq(result["test_met_low_par"], params[0])
	assert_eq(result["test_met_med_par"], params[1])
	assert_eq(result["test_met_high_par"], params[2])
