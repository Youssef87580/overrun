extends StaticBody2D

@onready var hearts : Array[AnimatedSprite2D ] = [$"../player/hud/hearts/HBoxContainer/Node2D/heart1",
$"../player/hud/hearts/HBoxContainer/Node2D2/heart2",
$"../player/hud/hearts/HBoxContainer/Node2D3/heart3"]

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		Gamemanager.decrease_health(hearts)
		var sign
		var direction = body.global_position.direction_to(global_position)
		if direction.x > 0:
			sign = -1.2
		else:
			sign = 1.2
		body.repel(sign)
