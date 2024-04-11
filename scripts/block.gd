@tool
extends StaticBody2D
class_name Block

@onready var col_rect = $CollisionShape2D

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

func hit_block() -> void:
	if self.hit_points == 1:
		self.queue_free()
		EventBus.block_destroyed.emit()
	else:
		self.hit_points -= 1
		_set_color_from_hp()

func _set_color_from_hp() -> void:
	match self.hit_points:
		1: self.color = Color("green")
		2: self.color = Color("yellow")
		3: self.color = Color("red")
		_: self.color = Color("purple")

func _draw():
	draw_rect(Rect2(Vector2.ZERO, size),color, true)
	draw_rect(Rect2(Vector2.ZERO, size),outline, false, outline_size)

func _ready():
	col_rect.shape.size = size
	col_rect.transform.origin = size / 2

func _process(_delta):
	pass

func _on_area_2d_body_exited(body: Node2D) -> void:
	if not is_player:
		var ball := body as Ball
		if ball:
			# just checking it's really a ball
			hit_block()
