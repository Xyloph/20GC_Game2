@tool
extends Node2D
class_name Block

@onready var col_rect = $StaticBody2D/CollisionShape2D

@export var is_player := false
@export var hit_points : int = 1
@export var outline_size : float = 2.0 :
	set(value):
		outline_size = value
		queue_redraw()

@export var size : Vector2 = Vector2(128,32) :
	set(value):
		size = value
		col_rect.transform.origin = value / 2
		col_rect.shape.size = value
		queue_redraw()
@export var color : Color = Color("white") :
	set(value):
		color = value
		queue_redraw()
@export var outline : Color = Color("black") :
	set(value):
		outline = value
		queue_redraw()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size),color, true)
	draw_rect(Rect2(Vector2.ZERO, size),outline, false, outline_size)

func _ready():
	col_rect.shape.size = size
	col_rect.transform.origin = size / 2

func _process(_delta):
	pass
