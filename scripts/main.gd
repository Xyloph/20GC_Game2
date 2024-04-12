extends Node2D

@onready var ball : Ball = $Ball
@onready var player : Node2D = $Player
@onready var player_block : Block = $Player/Block
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer
@onready var ui: UI = $UI
@onready var markers: Markers = $Markers
@onready var game_over: CanvasLayer = $GameOver

const PLAYER_SPEED = 400
const ORIGINAL_PLAYER_WIDTH = 128

var hit_sound = preload("res://assets/sounds/hit.wav")
var rebound_sound = preload("res://assets/sounds/rebound.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.block_destroyed.connect(_on_block_destroyed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# player movement
	var direction := Input.get_axis("ui_left", "ui_right")
	player.position.x = clamp(
		lerp(player.position.x, player.position.x + (direction * PLAYER_SPEED * delta)
		,0.75),0, markers.get_right() - player_block.size.x)

# when ball goes south, remove one life / game over
func _life_loss() -> void:
	ball.reset_ball()
	ball.position = Vector2(markers.get_right() / 2, player.position.y - 40)
	$Player/Block.size.x = ORIGINAL_PLAYER_WIDTH
	var done = ui.decrement_life()
	if done:
		# save high score and show screen
		ui.save_high_score(false)
		# remove ball so it stops bouncing
		ball.queue_free()
		# show game over screen
		game_over.show()

# when hitting top, paddle must become slimmer
func _hit_top() -> void:
	$Player/Block.size.x -= 20
	if ($Player/Block.size.x <= 0):
		# when paddle size is too small, life loss
		_life_loss()

# when a block gets destroyed, score and speed goes up
func _on_block_destroyed() -> void:
	ui.increment_score()
	ball.ball_speed += 20

# hook to force saving the high score on quit
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST || what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_and_quit()

func _on_ui_game_over() -> void:
	pass # Replace with function body.

func _on_pause_menu_quit() -> void:
	_save_and_quit()
	
func _save_and_quit() -> void:
	ui.save_high_score(true)

func _on_ball_play_hit_sound() -> void:
	if not audio.playing:
		audio.stream = hit_sound
		audio.play()

func _on_ball_play_rebound_sound() -> void:
	if not audio.playing:
		audio.stream = rebound_sound
		audio.play()
