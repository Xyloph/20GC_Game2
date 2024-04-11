extends CanvasLayer
class_name UI

@onready var life_label = $PanelContainer/HBoxContainer/LifeLabel
@onready var score_label = $PanelContainer/HBoxContainer/ScoreLabel
@onready var high_score_label = $PanelContainer/HBoxContainer/HighScoreLabel

var high_score_res: HighScore
var score := 0
var life := 3

signal game_over

func _ready() -> void:
	load_high_score()

func increment_score() -> void:
	score += 1
	if (high_score_res.high_score < score):
		high_score_res.high_score = score
		_set_high_score_label(high_score_res.high_score)
	_set_score_label(score)

func decrement_life() -> void:
	life -= 1
	_set_life_label(life)

func save_high_score() -> void:
	high_score_res.save()
	# it's the last thing we do
	get_tree().quit()

func load_high_score() -> void:
	high_score_res = HighScore.load()
	_set_high_score_label(high_score_res.high_score)

func _set_high_score_label(value):
	high_score_label.text = "High Score: " + str(value)

func _set_score_label(value):
	score_label.text = "Score: " + str(value)

func _set_life_label(value):
	life_label.text = "Life: " + str(value)
