extends Resource
class_name HighScore

const path = "user://high_score.res"

@export var high_score : int = 0

func save():
	ResourceSaver.save(self, path)

static func load() -> HighScore:
	if ResourceLoader.exists(path):
		return ResourceLoader.load(path) as HighScore
	else:
		return HighScore.new()
