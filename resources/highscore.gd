extends Node
class_name HighScore

const path = "user://high_score.save"

static func save(value):
	var file := FileAccess.open(path, FileAccess.WRITE)
	print("Saving high score")
	file.store_var(value)
	file.close()

static func load() -> int:
	if FileAccess.file_exists(path):
		var file := FileAccess.open(path, FileAccess.READ)
		var score := file.get_var() as int
		print("Loading high score")
		file.close()
		return score
	else:
		return 0 # default high score
