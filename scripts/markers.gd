extends Node2D
class_name Markers

@onready var top_left: Node2D = $TopLeft
@onready var lower_right: Node2D = $LowerRight

# This is a helper class.
# Godot will stretch/scale the nodes based on the project settings.
# To get the post-transformation size to detect edges
# we can refer to the node godot moved. Set as Top Level.

func get_right() -> float:
	return lower_right.position.x
	
func get_left() -> float:
	return top_left.position.x

func get_top() -> float:
	return top_left.position.y

func get_bottom() -> float:
	return lower_right.position.y
