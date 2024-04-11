extends RigidBody2D
class_name Ball

@onready var col_shape = $CollisionShape2D
@onready var markers: Markers = $Markers

const ORIGINAL_BALL_SPEED = 300
var ball_speed = 300
var ball_velocity : Vector2

signal play_hit_sound
signal play_rebound_sound
signal hit_top
signal hit_bottom

func reset_ball() -> void:
	ball_speed = ORIGINAL_BALL_SPEED
	ball_velocity = Vector2(0,-1)

func get_radius() -> int:
	return col_shape.shape.radius

func _draw():
	draw_circle(Vector2.ZERO ,col_shape.shape.radius, Color("white"))

# Called when the node enters the scene tree for the first time.
func _ready():
	# set an initial ball velocity
	ball_velocity = Vector2(0,-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		# edge "collision"
	if self.global_position.x - self.get_radius() <= 0 or self.global_position.x + self.get_radius() >= markers.get_right():
		# bounce
		ball_velocity.x *= -1
		play_rebound_sound.emit()
	
	# top "collision"
	if self.global_position.y - self.get_radius() <= markers.get_left():
		# bounce
		ball_velocity.y *= -1
		hit_top.emit()
		
	# bottom "collision"
	if self.global_position.y + self.get_radius() >= markers.get_bottom():
		hit_bottom.emit()

	# ball movement	
	var collision := self.move_and_collide(ball_velocity * ball_speed * delta) as KinematicCollision2D
	if collision:
		play_hit_sound.emit()
		# We only collide with StaticBody2D which parents are Blocks
		var collider := collision.get_collider().get_parent() as Block
		if collider.is_player:
			# bounce with a different angle based on where ball hit block
			var global_half = collider.global_position.x + collider.size.x / 2
			var x = 0.0
			var col_x := collision.get_position().x
			if (col_x > global_half):
				# to the right
				x =  (col_x - global_half) / (collider.size.x / 2)
			else:
				# to the left
				x = (global_half - col_x) / (collider.size.x / 2) * -1.0
			ball_velocity = Vector2(x, ball_velocity.y * -1).normalized()
		else:
			# straight bounce from the top blocks
			ball_velocity = ball_velocity.bounce(collision.get_normal())
			collider.hit_block()
