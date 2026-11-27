extends StaticBody2D

@onready var hearts : Array[AnimatedSprite2D ] = [$"../player/hud/hearts/HBoxContainer/Node2D/heart1",
$"../player/hud/hearts/HBoxContainer/Node2D2/heart2",
$"../player/hud/hearts/HBoxContainer/Node2D3/heart3"]
@onready var collision_shape = $CollisionShape2D2
@onready var area2d_collision = $Area2D/CollisionShape2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.set_collision_layer_value(8, false)
		#collision_shape.set_deferred("disabled", true)
		#area2d_collision.set_deferred("disabled", true)
		body.take_damage()
		Gamemanager.decrease_health(hearts)
		var sign
		var direction = body.global_position.direction_to(global_position)
		if direction.x > 0:
			sign = -1.2
		else:
			sign = 1.2
		body.repel(sign)
		print(get_tree(),"treeeee")
		print(is_inside_tree(),"treeeee")
		if Gamemanager.lives > 0:
			await get_tree().create_timer(2).timeout
			body.set_collision_layer_value(8, true)
			#collision_shape.set_deferred("disabled", false)
			#area2d_collision.set_deferred("disabled", false)
