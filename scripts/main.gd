extends Node2D

@onready var ball = $Ball
@onready var player = $Player
@onready var player_block = $Player/Block
@onready var audio = $AudioStreamPlayer
@onready var main = $"."
@onready var lower_right = $LowerRight
@onready var top_left = $TopLeft
@onready var ui: UI = $UI

const PLAYER_SPEED = 400
const ORIGINAL_BALL_SPEED = 300
const ORIGINAL_PLAYER_WIDTH = 128
var ball_speed = 300
var ball_velocity : Vector2

var hit_sound = preload("res://assets/sounds/hit.wav")
var rebound_sound = preload("res://assets/sounds/rebound.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	# set an initial ball velocity
	ball_velocity = Vector2(0,-1)
	EventBus.block_destroyed.connect(_on_block_destroyed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# player movement
	var direction := Input.get_axis("ui_left", "ui_right")
	player.position.x = clamp(
		lerp(player.position.x, player.position.x + (direction * PLAYER_SPEED * delta)
		,0.75),0, lower_right.position.x - player_block.size.x)
	
	# edge "collision"
	if ball.global_position.x - ball.get_radius() <= 0 or ball.global_position.x + ball.get_radius() >= lower_right.position.x:
		# bounce
		ball_velocity.x *= -1
		if not audio.playing:
			audio.stream = rebound_sound
			audio.play()
	
	# top "collision"
	if ball.global_position.y - ball.get_radius() <= top_left.position.y:
		# bounce
		ball_velocity.y *= -1
		_hit_top()
		
	# bottom "collision"
	if ball.global_position.y + ball.get_radius() >= lower_right.position.y:
		_life_loss()

	# ball movement	
	var collision := ball.move_and_collide(ball_velocity * ball_speed * delta) as KinematicCollision2D
	if collision:
		audio.stream = hit_sound
		audio.play()
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

# when ball goes south, remove one life / game over
func _life_loss() -> void:
	ball_speed = ORIGINAL_BALL_SPEED
	ball_velocity = Vector2(0,-1)
	ball.position = Vector2(lower_right.position.x / 2, player.position.y - 40)
	$Player/Block.size.x = ORIGINAL_PLAYER_WIDTH
	ui.decrement_life()

# when hitting top, paddle must become slimmer
func _hit_top() -> void:
	$Player/Block.size.x -= 20
	if ($Player/Block.size.x <= 0):
		# when paddle size is too small, life loss
		_life_loss()

# when a block gets destroyed, score and speed goes up
func _on_block_destroyed() -> void:
	ui.increment_score()
	ball_speed += 20
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST || what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_and_quit()

func _on_ui_game_over() -> void:
	pass # Replace with function body.

func _on_pause_menu_quit() -> void:
	_save_and_quit()
	
func _save_and_quit() -> void:
	ui.save_high_score()
