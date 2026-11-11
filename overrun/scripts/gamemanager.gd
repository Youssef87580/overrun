extends Node

var lives = 3

func decrease_health(hearts):
	lives -= 1
	print(lives)
	for i in 3:
		if i < lives:
			hearts[i].play("heart")
		else:
			hearts[i].play("broken_heart")
	if lives == 0:
		lives = 3
		get_tree().reload_current_scene()
		



func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
