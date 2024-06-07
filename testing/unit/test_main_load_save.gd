extends GutTest

func test_save_file():
	assert_true(FileAccess.file_exists("user://epic.save"))

func test_save_file_json():
	if not FileAccess.file_exists("user://epic.save"):
		fail_test("Save file doesn't exist!")
		return
	var file = FileAccess.open("user://epic.save", FileAccess.READ)
	var json = JSON.new()
	var parse = autoqfree(json.parse(file.get_as_text()))
	assert_eq(json.get_error_line(), 0)
	file.close()
