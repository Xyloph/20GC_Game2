extends CanvasLayer
class_name UI

@onready var life_label = $PanelContainer/HBoxContainer/LifeLabel
@onready var score_label = $PanelContainer/HBoxContainer/ScoreLabel
@onready var high_score_label = $PanelContainer/HBoxContainer/HighScoreLabel

func set_high_score(value):
	high_score_label.text = "High Score: " + str(value)

func set_score(value):
	score_label.text = "Score: " + str(value)

func set_life(value):
	life_label.text = "Life: " + str(value)
