extends CanvasLayer
@onready var restart_button: Button = $Panel/VBoxContainer/RestartButton
@onready var quit_button: Button = $Panel/VBoxContainer/QuitButton
@export_file var scene_to_load_file_path: String = "res://scenes/main.tscn"

func _ready() -> void:
	assert(FileAccess.file_exists(scene_to_load_file_path), "This file doesn't exist!")
	
func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file(scene_to_load_file_path)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_visibility_changed() -> void:
	if visible:
		restart_button.grab_focus()
