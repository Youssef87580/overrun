extends Control

func _ready() -> void:
	$CenterContainer/VBoxContainer/start.pressed.connect(_on_start_pressed)
	$CenterContainer/VBoxContainer/options.pressed.connect(_on_options_pressed)
	$CenterContainer/VBoxContainer/quit.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/remap.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
