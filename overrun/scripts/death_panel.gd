extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Gamemanager.lives <= 0:
		$".".show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true


func _on_try_again_pressed() -> void:
	get_tree().paused = false
	Gamemanager.lives = 3
	$".".hide()
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	Gamemanager.lives = 3
	$".".hide()
	get_tree().change_scene_to_file("res://scenes/gamemenu.tscn")
