extends GutTest

var main = preload("res://main.gd")
var level = preload("res://levels/level.gd")

func test_data_is_saved():
	var main_double = partial_double(main).new()
	var level_double = double(level).new()
	var test_data = autoqfree({"test" = "successful?"})
	stub(level_double, "get_data_to_save").to_return(test_data)
	
	main_double.save_data = {}
	main_double.current_level = level_double
	main_double.save_level_data()
	assert_eq(main_double.save_data, test_data)
