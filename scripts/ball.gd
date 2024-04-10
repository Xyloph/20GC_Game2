@tool
extends RigidBody2D
class_name Ball

@onready var col_shape = $CollisionShape2D

func get_radius() -> int:
	return col_shape.shape.radius

func _draw():
	draw_circle(Vector2.ZERO ,col_shape.shape.radius, Color("white"))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
